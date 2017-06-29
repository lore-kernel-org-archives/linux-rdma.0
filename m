From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/7] mlx4: Add WQE segments implementation
Date: Thu, 29 Jun 2017 14:47:05 +0300
Message-ID: <1498736828-17875-5-git-send-email-yishaih@mellanox.com>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the following WQE segments implementation:
1. Control segment.
2. Datagram segment.
3. Data segment.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4dv.h | 88 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index 7679ece..f15c56c 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -373,5 +373,93 @@ struct mlx4_wqe_atomic_seg {
 	uint64_t		compare;
 };
 
+/*
+ * Control segment - contains some control information for the current WQE.
+ *
+ * Output:
+ *	seg	  - control segment to be filled
+ * Input:
+ *	opcode		- Opcode of this WQE. Encodes the type of operation
+ *	                  to be executed on the QP.
+ *	wqe_cnt		- Number of queue entries.
+ *	ind		- WQEBB number of the first block of this WQE.
+ *	fence_size	- Fence bit and WQE size in octowords.
+ *	srcrb_flags	- High 24 bits are SRC remote buffer; low 8 bits are
+ *	                  flags which described in mlx4_wqe_ctrl_seg struct.
+ *	imm		- Immediate data/Invalidation key.
+ */
+static MLX4DV_ALWAYS_INLINE
+void mlx4dv_set_ctrl_seg(struct mlx4_wqe_ctrl_seg *seg, uint8_t opcode, uint32_t
+			 wqe_cnt, uint32_t ind, uint8_t fence_size,
+			 uint32_t srcrb_flags, uint32_t imm)
+{
+	seg->owner_opcode = htobe32(opcode) |
+		(ind & wqe_cnt ? htobe32(1 << 31) : 0);
+	seg->fence_size = fence_size;
+	seg->srcrb_flags = srcrb_flags;
+	/*
+	 * The caller should prepare "imm" in advance based on WR opcode.
+	 * For IBV_WR_SEND_WITH_IMM and IBV_WR_RDMA_WRITE_WITH_IMM,
+	 * the "imm" should be assigned as is.
+	 * For the IBV_WR_SEND_WITH_INV, it should be htobe32(imm).
+	 */
+	seg->imm = imm;
+}
+
+/*
+ * Datagram Segment - contains address information required in order
+ * to form a datagram message.
+ *
+ * Output:
+ *	seg - datagram segment to be filled.
+ * Input:
+ *	port_pd			- Port number and protection domain.
+ *	g_slid			- GRH and source LID for IB port only.
+ *	dlid			- Remote LID.
+ *	gid_index		- Index to port GID table.
+ *	state_rate		- Maximum static rate control.
+ *	hop_limit		- IPv6 hop limit.
+ *	sl_tclass_flowlabel	- Service Level, IPv6 TClass and flow table.
+ *	dgid			- Remote GID for IB port only.
+ *	dqpn			- Destination QP.
+ *	qkey			- QKey.
+ *	vlan			- VLAN for RAW ETHERNET QP only.
+ *	mac			- Destination MAC for RAW ETHERNET QP only.
+ */
+static MLX4DV_ALWAYS_INLINE
+void mlx4dv_set_dgram_seg(struct mlx4_wqe_datagram_seg *seg, uint32_t port_pd,
+			  uint8_t g_slid, uint16_t dlid, uint8_t gid_index,
+			  uint8_t stat_rate, uint8_t hop_limit, uint32_t
+			  sl_tclass_flowlabel, uint8_t *dgid, uint32_t dqpn,
+			  uint32_t qkey, uint16_t vlan, uint8_t *mac)
+{
+	seg->av.port_pd = htobe32(port_pd);
+	seg->av.g_slid = g_slid;
+	seg->av.dlid = htobe16(dlid);
+	seg->av.gid_index = gid_index;
+	seg->av.stat_rate = stat_rate;
+	seg->av.hop_limit = hop_limit;
+	seg->av.sl_tclass_flowlabel = htobe32(sl_tclass_flowlabel);
+	memcpy(seg->av.dgid, dgid, 16);
+	seg->dqpn = htobe32(dqpn);
+	seg->qkey = htobe32(qkey);
+	seg->vlan = htobe16(vlan);
+	memcpy(seg->mac, mac, 6);
+}
+
+/*
+ * Data Segments - contain pointers and a byte count for the scatter/gather list.
+ * They can optionally contain data, which will save a memory read access for
+ * gather Work Requests.
+ */
+static MLX4DV_ALWAYS_INLINE
+void mlx4dv_set_data_seg(struct mlx4_wqe_data_seg *seg,
+			 uint32_t length, uint32_t lkey,
+			 uintptr_t address)
+{
+	seg->byte_count = htobe32(length);
+	seg->lkey       = htobe32(lkey);
+	seg->addr       = htobe64(address);
+}
 #endif /* _MLX4DV_H_ */
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
