version 1.0
import '../../../chip.wdl' as chip
import 'compare_md5sum.wdl' as compare_md5sum

workflow test_spr {
    input {
        String pe_ta
        String se_ta

        String ref_pe_ta_pr1
        String ref_pe_ta_pr2
        String ref_se_ta_pr1
        String ref_se_ta_pr2
    }
    Int spr_mem_mb = 16000

    call chip.spr as pe_spr { input :
        ta = pe_ta,
        paired_end = true,

        mem_mb = spr_mem_mb,
    }    
    call chip.spr as se_spr { input :
        ta = se_ta,
        paired_end = false,

        mem_mb = spr_mem_mb,
    }

    call compare_md5sum.compare_md5sum { input :
        labels = [
            'pe_spr_pr1',
            'pe_spr_pr2',
            'se_spr_pr1',
            'se_spr_pr2',
        ],
        files = [
            pe_spr.ta_pr1,
            pe_spr.ta_pr2,
            se_spr.ta_pr1,
            se_spr.ta_pr2,
        ],
        ref_files = [
            ref_pe_ta_pr1,
            ref_pe_ta_pr2,
            ref_se_ta_pr1,
            ref_se_ta_pr2,
        ],
    }
}
