package net.minecraft.world.level.levelgen.structure.templatesystem;

import com.mojang.serialization.Codec;
import javax.annotation.Nullable;
import net.minecraft.core.BlockPosition;
import net.minecraft.world.level.IWorldReader;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.Blocks;

public class DefinedStructureProcessorLavaSubmergedBlock extends DefinedStructureProcessor {

    public static final Codec<DefinedStructureProcessorLavaSubmergedBlock> CODEC = Codec.unit(() -> {
        return DefinedStructureProcessorLavaSubmergedBlock.INSTANCE;
    });
    public static final DefinedStructureProcessorLavaSubmergedBlock INSTANCE = new DefinedStructureProcessorLavaSubmergedBlock();

    public DefinedStructureProcessorLavaSubmergedBlock() {}

    @Nullable
    @Override
    public DefinedStructure.BlockInfo a(IWorldReader iworldreader, BlockPosition blockposition, BlockPosition blockposition1, DefinedStructure.BlockInfo definedstructure_blockinfo, DefinedStructure.BlockInfo definedstructure_blockinfo1, DefinedStructureInfo definedstructureinfo) {
        BlockPosition blockposition2 = definedstructure_blockinfo1.pos;
        boolean flag = iworldreader.getType(blockposition2).a(Blocks.LAVA);

        return flag && !Block.a(definedstructure_blockinfo1.state.getShape(iworldreader, blockposition2)) ? new DefinedStructure.BlockInfo(blockposition2, Blocks.LAVA.getBlockData(), definedstructure_blockinfo1.nbt) : definedstructure_blockinfo1;
    }

    @Override
    protected DefinedStructureStructureProcessorType<?> a() {
        return DefinedStructureStructureProcessorType.LAVA_SUBMERGED_BLOCK;
    }
}