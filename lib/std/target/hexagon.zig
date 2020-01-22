const std = @import("../std.zig");
const Cpu = std.Target.Cpu;

pub const Feature = enum {
    duplex,
    hvx,
    hvx_length128b,
    hvx_length64b,
    hvxv60,
    hvxv62,
    hvxv65,
    hvxv66,
    long_calls,
    mem_noshuf,
    memops,
    noreturn_stack_elim,
    nvj,
    nvs,
    packets,
    reserved_r19,
    small_data,
    v5,
    v55,
    v60,
    v62,
    v65,
    v66,
    zreg,
};

pub usingnamespace Cpu.Feature.feature_set_fns(Feature);

pub const all_features = blk: {
    const len = @typeInfo(Feature).Enum.fields.len;
    std.debug.assert(len <= Cpu.Feature.Set.needed_bit_count);
    var result: [len]Cpu.Feature = undefined;
    result[@enumToInt(Feature.duplex)] = .{
        .llvm_name = "duplex",
        .description = "Enable generation of duplex instruction",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.hvx)] = .{
        .llvm_name = "hvx",
        .description = "Hexagon HVX instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.hvx_length128b)] = .{
        .llvm_name = "hvx-length128b",
        .description = "Hexagon HVX 128B instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .hvx,
        }),
    };
    result[@enumToInt(Feature.hvx_length64b)] = .{
        .llvm_name = "hvx-length64b",
        .description = "Hexagon HVX 64B instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .hvx,
        }),
    };
    result[@enumToInt(Feature.hvxv60)] = .{
        .llvm_name = "hvxv60",
        .description = "Hexagon HVX instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .hvx,
        }),
    };
    result[@enumToInt(Feature.hvxv62)] = .{
        .llvm_name = "hvxv62",
        .description = "Hexagon HVX instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .hvx,
            .hvxv60,
        }),
    };
    result[@enumToInt(Feature.hvxv65)] = .{
        .llvm_name = "hvxv65",
        .description = "Hexagon HVX instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .hvx,
            .hvxv60,
            .hvxv62,
        }),
    };
    result[@enumToInt(Feature.hvxv66)] = .{
        .llvm_name = "hvxv66",
        .description = "Hexagon HVX instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .hvx,
            .hvxv60,
            .hvxv62,
            .hvxv65,
            .zreg,
        }),
    };
    result[@enumToInt(Feature.long_calls)] = .{
        .llvm_name = "long-calls",
        .description = "Use constant-extended calls",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.mem_noshuf)] = .{
        .llvm_name = "mem_noshuf",
        .description = "Supports mem_noshuf feature",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.memops)] = .{
        .llvm_name = "memops",
        .description = "Use memop instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.noreturn_stack_elim)] = .{
        .llvm_name = "noreturn-stack-elim",
        .description = "Eliminate stack allocation in a noreturn function when possible",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.nvj)] = .{
        .llvm_name = "nvj",
        .description = "Support for new-value jumps",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .packets,
        }),
    };
    result[@enumToInt(Feature.nvs)] = .{
        .llvm_name = "nvs",
        .description = "Support for new-value stores",
        .dependencies = sparseFeatureSet(&[_]Feature{
            .packets,
        }),
    };
    result[@enumToInt(Feature.packets)] = .{
        .llvm_name = "packets",
        .description = "Support for instruction packets",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.reserved_r19)] = .{
        .llvm_name = "reserved-r19",
        .description = "Reserve register R19",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.small_data)] = .{
        .llvm_name = "small-data",
        .description = "Allow GP-relative addressing of global variables",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.v5)] = .{
        .llvm_name = "v5",
        .description = "Enable Hexagon V5 architecture",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.v55)] = .{
        .llvm_name = "v55",
        .description = "Enable Hexagon V55 architecture",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.v60)] = .{
        .llvm_name = "v60",
        .description = "Enable Hexagon V60 architecture",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.v62)] = .{
        .llvm_name = "v62",
        .description = "Enable Hexagon V62 architecture",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.v65)] = .{
        .llvm_name = "v65",
        .description = "Enable Hexagon V65 architecture",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.v66)] = .{
        .llvm_name = "v66",
        .description = "Enable Hexagon V66 architecture",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    result[@enumToInt(Feature.zreg)] = .{
        .llvm_name = "zreg",
        .description = "Hexagon ZReg extension instructions",
        .dependencies = sparseFeatureSet(&[_]Feature{}),
    };
    const ti = @typeInfo(Feature);
    for (result) |*elem, i| {
        elem.index = i;
        elem.name = ti.Enum.fields[i].name;
        elem.dependencies.initAsDependencies(i, &result);
    }
    break :blk result;
};

pub const cpu = struct {
    pub const generic = Cpu{
        .name = "generic",
        .llvm_name = "generic",
        .features = featureSet(&all_features, &[_]Feature{
            .duplex,
            .memops,
            .nvj,
            .nvs,
            .packets,
            .small_data,
            .v5,
            .v55,
            .v60,
        }),
    };
    pub const hexagonv5 = Cpu{
        .name = "hexagonv5",
        .llvm_name = "hexagonv5",
        .features = featureSet(&all_features, &[_]Feature{
            .duplex,
            .memops,
            .nvj,
            .nvs,
            .packets,
            .small_data,
            .v5,
        }),
    };
    pub const hexagonv55 = Cpu{
        .name = "hexagonv55",
        .llvm_name = "hexagonv55",
        .features = featureSet(&all_features, &[_]Feature{
            .duplex,
            .memops,
            .nvj,
            .nvs,
            .packets,
            .small_data,
            .v5,
            .v55,
        }),
    };
    pub const hexagonv60 = Cpu{
        .name = "hexagonv60",
        .llvm_name = "hexagonv60",
        .features = featureSet(&all_features, &[_]Feature{
            .duplex,
            .memops,
            .nvj,
            .nvs,
            .packets,
            .small_data,
            .v5,
            .v55,
            .v60,
        }),
    };
    pub const hexagonv62 = Cpu{
        .name = "hexagonv62",
        .llvm_name = "hexagonv62",
        .features = featureSet(&all_features, &[_]Feature{
            .duplex,
            .memops,
            .nvj,
            .nvs,
            .packets,
            .small_data,
            .v5,
            .v55,
            .v60,
            .v62,
        }),
    };
    pub const hexagonv65 = Cpu{
        .name = "hexagonv65",
        .llvm_name = "hexagonv65",
        .features = featureSet(&all_features, &[_]Feature{
            .duplex,
            .mem_noshuf,
            .memops,
            .nvj,
            .nvs,
            .packets,
            .small_data,
            .v5,
            .v55,
            .v60,
            .v62,
            .v65,
        }),
    };
    pub const hexagonv66 = Cpu{
        .name = "hexagonv66",
        .llvm_name = "hexagonv66",
        .features = featureSet(&all_features, &[_]Feature{
            .duplex,
            .mem_noshuf,
            .memops,
            .nvj,
            .nvs,
            .packets,
            .small_data,
            .v5,
            .v55,
            .v60,
            .v62,
            .v65,
            .v66,
        }),
    };
};

/// All hexagon CPUs, sorted alphabetically by name.
/// TODO: Replace this with usage of `std.meta.declList`. It does work, but stage1
/// compiler has inefficient memory and CPU usage, affecting build times.
pub const all_cpus = &[_]*const Cpu{
    &cpu.generic,
    &cpu.hexagonv5,
    &cpu.hexagonv55,
    &cpu.hexagonv60,
    &cpu.hexagonv62,
    &cpu.hexagonv65,
    &cpu.hexagonv66,
};
