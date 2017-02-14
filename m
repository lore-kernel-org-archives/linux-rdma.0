From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 3/7] mlx5: Add WQE segments implementation
Date: Tue, 14 Feb 2017 15:48:20 +0200
Message-ID: <1487080104-28991-4-git-send-email-yishaih@mellanox.com>
References: <1487080104-28991-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487080104-28991-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add generic and x86 SSE3 versions of WQE
segments implementations.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5dv.h | 179 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 179 insertions(+)

diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 5709039..4fae71b 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -35,7 +35,14 @@
 
 /* For __be64 type */
 #include <linux/types.h>
+/* For htonl/htons */
 #include <arpa/inet.h>
+/* Some system requires this file instead of arpa/inet.h */
+#include <netinet/in.h>
+#if defined(__SSE3__)
+#include <emmintrin.h>
+#include <tmmintrin.h>
+#endif /* defined(__SSE3__) */
 
 /* Always inline the functions */
 #ifdef __GNUC__
@@ -406,4 +413,176 @@ struct mlx5_wqe_eth_seg {
 	uint8_t		inline_hdr[16];
 };
 
+/*
+ * Control segment - contains some control information for the current WQE.
+ *
+ * Output:
+ *	seg	  - control segment to be filled
+ * Input:
+ *	pi	  - WQEBB number of the first block of this WQE.
+ *		    This number should wrap at 0xffff, regardless of
+ *		    size of the WQ.
+ *	opcode	  - Opcode of this WQE. Encodes the type of operation
+ *		    to be executed on the QP.
+ *	opmod	  - Opcode modifier.
+ *	qp_num	  - QP/SQ number this WQE is posted to.
+ *	fm_ce_se  - FM (fence mode), CE (completion and event mode)
+ *		    and SE (solicited event).
+ *	ds	  - WQE size in octowords (16-byte units). DS accounts for all
+ *		    the segments in the WQE as summarized in WQE construction.
+ *	signature - WQE signature.
+ *	imm	  - Immediate data/Invalidation key/UMR mkey.
+ */
+static MLX5DV_ALWAYS_INLINE
+void mlx5dv_set_ctrl_seg(struct mlx5_wqe_ctrl_seg *seg, uint16_t pi,
+			 uint8_t opcode, uint8_t opmod, uint32_t qp_num,
+			 uint8_t fm_ce_se, uint8_t ds,
+			 uint8_t signature, uint32_t imm)
+{
+	seg->opmod_idx_opcode	= htonl(((uint32_t)opmod << 24) | ((uint32_t)pi << 8) | opcode);
+	seg->qpn_ds		= htonl((qp_num << 8) | ds);
+	seg->fm_ce_se		= fm_ce_se;
+	seg->signature		= signature;
+	/*
+	 * The caller should prepare "imm" in advance based on WR opcode.
+	 * For IBV_WR_SEND_WITH_IMM and IBV_WR_RDMA_WRITE_WITH_IMM,
+	 * the "imm" should be assigned as is.
+	 * For the IBV_WR_SEND_WITH_INV, it should be htonl(imm).
+	 */
+	seg->imm		= imm;
+}
+
+/* x86 optimized version of mlx5dv_set_ctrl_seg()
+ *
+ * This is useful when doing calculations on large data sets
+ * for parallel calculations.
+ *
+ * It doesn't suit for serialized algorithms.
+ */
+#if defined(__SSE3__)
+static MLX5DV_ALWAYS_INLINE
+void mlx5dv_x86_set_ctrl_seg(struct mlx5_wqe_ctrl_seg *seg, uint16_t pi,
+			     uint8_t opcode, uint8_t opmod, uint32_t qp_num,
+			     uint8_t fm_ce_se, uint8_t ds,
+			     uint8_t signature, uint32_t imm)
+{
+	__m128i val  = _mm_set_epi32(imm, qp_num, (ds << 16) | pi,
+				     (signature << 24) | (opcode << 16) | (opmod << 8) | fm_ce_se);
+	__m128i mask = _mm_set_epi8(15, 14, 13, 12,	/* immediate */
+				     0,			/* signal/fence_mode */
+				     0x80, 0x80,	/* reserved */
+				     3,			/* signature */
+				     6,			/* data size */
+				     8, 9, 10,		/* QP num */
+				     2,			/* opcode */
+				     4, 5,		/* sw_pi in BE */
+				     1			/* opmod */
+				     );
+	*(__m128i *) seg = _mm_shuffle_epi8(val, mask);
+}
+#endif /* defined(__SSE3__) */
+
+/*
+ * Datagram Segment - contains address information required in order
+ * to form a datagram message.
+ *
+ * Output:
+ *	seg		- datagram segment to be filled.
+ * Input:
+ *	key		- Q_key/access key.
+ *	dqp_dct		- Destination QP number for UD and DCT for DC.
+ *	ext		- Address vector extension.
+ *	stat_rate_sl	- Maximum static rate control, SL/ethernet priority.
+ *	fl_mlid		- Force loopback and source LID for IB.
+ *	rlid		- Remote LID
+ *	rmac		- Remote MAC
+ *	tclass		- GRH tclass/IPv6 tclass/IPv4 ToS
+ *	hop_limit	- GRH hop limit/IPv6 hop limit/IPv4 TTL
+ *	grh_gid_fi	- GRH, source GID address and IPv6 flow label.
+ *	rgid		- Remote GID/IP address.
+ */
+static MLX5DV_ALWAYS_INLINE
+void mlx5dv_set_dgram_seg(struct mlx5_wqe_datagram_seg *seg,
+			  uint64_t key, uint32_t dqp_dct,
+			  uint8_t ext, uint8_t stat_rate_sl,
+			  uint8_t fl_mlid, uint16_t rlid,
+			  uint8_t *rmac, uint8_t tclass,
+			  uint8_t hop_limit, uint32_t grh_gid_fi,
+			  uint8_t *rgid)
+{
+
+	/* Always put 64 bits, in q_key, the reserved part will be 0 */
+	seg->av.key.dc_key	= htobe64(key);
+	seg->av.dqp_dct		= htonl(((uint32_t)ext << 31) | dqp_dct);
+	seg->av.stat_rate_sl	= stat_rate_sl;
+	seg->av.fl_mlid		= fl_mlid;
+	seg->av.rlid		= htons(rlid);
+	memcpy(seg->av.rmac, rmac, 6);
+	seg->av.tclass		= tclass;
+	seg->av.hop_limit	= hop_limit;
+	seg->av.grh_gid_fl	= htonl(grh_gid_fi);
+	memcpy(seg->av.rgid, rgid, 16);
+}
+
+/*
+ * Data Segments - contain pointers and a byte count for the scatter/gather list.
+ * They can optionally contain data, which will save a memory read access for
+ * gather Work Requests.
+ */
+static MLX5DV_ALWAYS_INLINE
+void mlx5dv_set_data_seg(struct mlx5_wqe_data_seg *seg,
+			 uint32_t length, uint32_t lkey,
+			 uintptr_t address)
+{
+	seg->byte_count = htonl(length);
+	seg->lkey       = htonl(lkey);
+	seg->addr       = htobe64(address);
+}
+/*
+ * x86 optimized version of mlx5dv_set_data_seg()
+ *
+ * This is useful when doing calculations on large data sets
+ * for parallel calculations.
+ *
+ * It doesn't suit for serialized algorithms.
+ */
+#if defined(__SSE3__)
+static MLX5DV_ALWAYS_INLINE
+void mlx5dv_x86_set_data_seg(struct mlx5_wqe_data_seg *seg,
+			     uint32_t length, uint32_t lkey,
+			     uintptr_t address)
+{
+	__m128i val  = _mm_set_epi32((uint32_t)address, (uint32_t)(address >> 32), lkey, length);
+	__m128i mask = _mm_set_epi8(12, 13, 14, 15,	/* local address low */
+				     8, 9, 10, 11,	/* local address high */
+				     4, 5, 6, 7,	/* l_key */
+				     0, 1, 2, 3		/* byte count */
+				     );
+	*(__m128i *) seg = _mm_shuffle_epi8(val, mask);
+}
+#endif /* defined(__SSE3__) */
+
+/*
+ * Eth Segment - contains packet headers and information for stateless L2, L3, L4 offloading.
+ *
+ * Output:
+ *	 seg		 - Eth segment to be filled.
+ * Input:
+ *	cs_flags	 - l3cs/l3cs_inner/l4cs/l4cs_inner.
+ *	mss		 - Maximum segment size. For TSO WQEs, the number of bytes
+ *			   in the TCP payload to be transmitted in each packet. Must
+ *			   be 0 on non TSO WQEs.
+ *	inline_hdr_sz	 - Length of the inlined packet headers.
+ *	inline_hdr_start - Inlined packet header.
+ */
+static MLX5DV_ALWAYS_INLINE
+void mlx5dv_set_eth_seg(struct mlx5_wqe_eth_seg *seg, uint8_t cs_flags,
+			uint16_t mss, uint16_t inline_hdr_sz,
+			uint8_t *inline_hdr_start)
+{
+	seg->cs_flags		= cs_flags;
+	seg->mss		= htons(mss);
+	seg->inline_hdr_sz	= htons(inline_hdr_sz);
+	memcpy(seg->inline_hdr_start, inline_hdr_start, inline_hdr_sz);
+}
 #endif /* _MLX5DV_H_ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
