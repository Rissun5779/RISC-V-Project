import sys
import re
from pathlib import Path

def parse_module(file_path):
    """Parse module ports from Verilog file, supporting parameterized modules."""
    text = Path(file_path).read_text()

    # 找到 module 名稱和 port list，支援 #(...) parameter
    module_match = re.search(r"module\s+(\w+)\s*(#\([^)]*\))?\s*\(([^)]*)\)", text, re.S)
    if not module_match:
        raise ValueError("No module definition found.")

    module_name = module_match.group(1)
    ports_text = module_match.group(3)  # port list 在 group 3
    ports = ports_text.replace("\n", " ").split(",")
    ports = [p.strip() for p in ports if p.strip()]

    # 找到 input/output 宣告
    io_matches = re.findall(r"(input|output)\s+(?:wire|reg)?\s*(\[[^]]+\])?\s*(\w+)", text)

    io_dict = {}
    for direction, width, name in io_matches:
        width = width.strip() if width else ""
        io_dict[name] = (direction, width)

    return module_name, ports, io_dict


def generate_tb(module_name, ports, io_dict):
    tb_lines = []
    tb_lines.append(f'module {module_name}_tb;')
    tb_lines.append("")

    # 宣告 signals
    for p in ports:
        if p in io_dict:
            direction, width = io_dict[p]
            if direction == "input":
                tb_lines.append(f"    reg {width} {p};")
            elif direction == "output":
                tb_lines.append(f"    wire {width} {p};")
    tb_lines.append("")

    # UUT instance
    tb_lines.append(f"    {module_name} uut (")
    for i, p in enumerate(ports):
        comma = "," if i < len(ports)-1 else ""
        tb_lines.append(f"        .{p}({p}){comma}")
    tb_lines.append("    );")
    tb_lines.append("")

    # 測試激勵
    tb_lines.append("    initial begin")
    tb_lines.append("        $dumpfile(\"tb.vcd\");")
    tb_lines.append(f"        $dumpvars(0, {module_name}_tb);")
    tb_lines.append("")
    tb_lines.append("        // 初始化")
    for p in ports:
        if io_dict.get(p, ("", ""))[0] == "input":
            tb_lines.append(f"        {p} = 0;")
    tb_lines.append("        #10;")
    tb_lines.append("")
    tb_lines.append("        // 測試案例")
    tb_lines.append("        // TODO: Add stimulus here")
    tb_lines.append("        #100;")
    tb_lines.append("        $finish;")
    tb_lines.append("    end")
    tb_lines.append("")
    tb_lines.append("endmodule")
    return "\n".join(tb_lines)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python gen_tb.py <verilog_file>")
        sys.exit(1)

    module_name, ports, io_dict = parse_module(sys.argv[1])
    tb_code = generate_tb(module_name, ports, io_dict)

    tb_file = Path(f"{module_name}_tb.v")
    tb_file.write_text(tb_code)
    print(f"Testbench generated: {tb_file}")
