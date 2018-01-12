From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/4] IB/core: Fix ib_wc structure size to remain in 64 bytes boundary
Date: Fri, 12 Jan 2018 07:58:41 +0200
Message-ID: <20180112055842.23125-4-leon@kernel.org>
References: <20180112055842.23125-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112055842.23125-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The change of slid from u16 to u32 results in sizeof(struct ib_wc)
cross 64B boundary, which causes more cache misses. This patch
rearranges the fields and remain the size to 64B.

Pahole output before this change:

struct ib_wc {
        union {
                u64                wr_id;                /*           8 */
                struct ib_cqe *    wr_cqe;               /*           8 */
        };                                               /*     0     8 */
        enum ib_wc_status          status;               /*     8     4 */
        enum ib_wc_opcode          opcode;               /*    12     4 */
        u32                        vendor_err;           /*    16     4 */
        u32                        byte_len;             /*    20     4 */
        struct ib_qp *             qp;                   /*    24     8 */
        union {
                __be32             imm_data;             /*           4 */
                u32                invalidate_rkey;      /*           4 */
        } ex;                                            /*    32     4 */
        u32                        src_qp;               /*    36     4 */
        int                        wc_flags;             /*    40     4 */
        u16                        pkey_index;           /*    44     2 */

        /* XXX 2 bytes hole, try to pack */

        u32                        slid;                 /*    48     4 */
        u8                         sl;                   /*    52     1 */
        u8                         dlid_path_bits;       /*    53     1 */
        u8                         port_num;             /*    54     1 */
        u8                         smac[6];              /*    55     6 */

        /* XXX 1 byte hole, try to pack */

        u16                        vlan_id;              /*    62     2 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u8                         network_hdr_type;     /*    64     1 */

        /* size: 72, cachelines: 2, members: 17 */
        /* sum members: 62, holes: 2, sum holes: 3 */
        /* padding: 7 */
        /* last cacheline: 8 bytes */
};

Pahole output after this change:

struct ib_wc {
        union {
                u64                wr_id;                /*           8 */
                struct ib_cqe *    wr_cqe;               /*           8 */
        };                                               /*     0     8 */
        enum ib_wc_status          status;               /*     8     4 */
        enum ib_wc_opcode          opcode;               /*    12     4 */
        u32                        vendor_err;           /*    16     4 */
        u32                        byte_len;             /*    20     4 */
        struct ib_qp *             qp;                   /*    24     8 */
        union {
                __be32             imm_data;             /*           4 */
                u32                invalidate_rkey;      /*           4 */
        } ex;                                            /*    32     4 */
        u32                        src_qp;               /*    36     4 */
        u32                        slid;                 /*    40     4 */
        int                        wc_flags;             /*    44     4 */
        u16                        pkey_index;           /*    48     2 */
        u8                         sl;                   /*    50     1 */
        u8                         dlid_path_bits;       /*    51     1 */
        u8                         port_num;             /*    52     1 */
        u8                         smac[6];              /*    53     6 */

        /* XXX 1 byte hole, try to pack */

        u16                        vlan_id;              /*    60     2 */
        u8                         network_hdr_type;     /*    62     1 */

        /* size: 64, cachelines: 1, members: 17 */
        /* sum members: 62, holes: 1, sum holes: 1 */
        /* padding: 1 */
};

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.13
Fixes: 7db20ecd1d97 ("IB/core: Change wc.slid from 16 to 32 bits")
Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fd84cda5ed7c..0d6a110dae7c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -983,9 +983,9 @@ struct ib_wc {
 		u32		invalidate_rkey;
 	} ex;
 	u32			src_qp;
+	u32			slid;
 	int			wc_flags;
 	u16			pkey_index;
-	u32			slid;
 	u8			sl;
 	u8			dlid_path_bits;
 	u8			port_num;	/* valid only for DR SMPs on switches */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
