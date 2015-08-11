From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/8] IB/srp: Register the indirect data buffer descriptor
Date: Mon, 10 Aug 2015 17:09:05 -0700
Message-ID: <55C93D21.1090102@sandisk.com>
References: <55BBF4B8.2050700@sandisk.com>
 <20150803152420.GA24193@infradead.org> <55BFB40F.8000500@sandisk.com>
 <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
 <20150805195122.GA31595@obsidianresearch.com> <55C2840C.5050301@sandisk.com>
 <55C2912A.50709@sandisk.com> <20150806001006.GD2483@obsidianresearch.com>
 <55C2A7FE.7020904@sandisk.com> <20150806043642.GA14153@obsidianresearch.com>
 <55C93C61.9010508@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C93C61.9010508-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of always using the global rkey for the indirect data
buffer descriptor, register that descriptor with the HCA if
the kernel module parameter register_always has been set to Y.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 57 +++++++++++++++++++++++++++++++++++--
 drivers/infiniband/ulp/srp/ib_srp.h |  4 +++
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1029fd2..2a16ab4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1453,18 +1453,58 @@ out:
 	return ret;
 }
 
+/*
+ * Register the indirect data buffer descriptor with the HCA.
+ *
+ * Note: since the indirect data buffer descriptor has been allocated with
+ * kmalloc() it is guaranteed that this buffer is a physically contiguous
+ * memory buffer.
+ */
+static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
+		       void **next_mr, void **end_mr, u32 idb_len,
+		       __be32 *idb_rkey)
+{
+	struct srp_target_port *target = ch->target;
+	struct srp_device *dev = target->srp_host->srp_dev;
+	struct srp_map_state state;
+	struct srp_direct_buf idb_desc;
+	u64 idb_pages[1];
+	int ret;
+
+	memset(&state, 0, sizeof(state));
+	memset(&idb_desc, 0, sizeof(idb_desc));
+	state.gen.next = next_mr;
+	state.gen.end = end_mr;
+	state.desc = &idb_desc;
+	state.pages = idb_pages;
+	state.pages[0] = (req->indirect_dma_addr &
+			  dev->mr_page_mask);
+	state.npages = 1;
+	state.base_dma_addr = req->indirect_dma_addr;
+	state.dma_len = idb_len;
+	ret = srp_finish_mapping(&state, ch);
+	if (ret < 0)
+		goto out;
+
+	*idb_rkey = idb_desc.key;
+
+out:
+	return ret;
+}
+
 static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 			struct srp_request *req)
 {
 	struct srp_target_port *target = ch->target;
 	struct scatterlist *scat;
 	struct srp_cmd *cmd = req->cmd->buf;
-	int len, nents, count;
+	int len, nents, count, ret;
 	struct srp_device *dev;
 	struct ib_device *ibdev;
 	struct srp_map_state state;
 	struct srp_indirect_buf *indirect_hdr;
-	u32 table_len;
+	u32 idb_len, table_len;
+	__be32 idb_rkey;
 	u8 fmt;
 
 	if (!scsi_sglist(scmnd) || scmnd->sc_data_direction == DMA_NONE)
@@ -1546,6 +1586,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 
 	count = min(state.ndesc, target->cmd_sg_cnt);
 	table_len = state.ndesc * sizeof (struct srp_direct_buf);
+	idb_len = sizeof(struct srp_indirect_buf) + table_len;
 
 	fmt = SRP_DATA_DESC_INDIRECT;
 	len = sizeof(struct srp_cmd) + sizeof (struct srp_indirect_buf);
@@ -1554,8 +1595,18 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	memcpy(indirect_hdr->desc_list, req->indirect_desc,
 	       count * sizeof (struct srp_direct_buf));
 
+	if (register_always && (dev->use_fast_reg || dev->use_fmr)) {
+		ret = srp_map_idb(ch, req, state.gen.next, state.gen.end,
+				  idb_len, &idb_rkey);
+		if (ret < 0)
+			return ret;
+		req->nmdesc++;
+	} else {
+		idb_rkey = target->rkey;
+	}
+
 	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
-	indirect_hdr->table_desc.key = cpu_to_be32(target->rkey);
+	indirect_hdr->table_desc.key = idb_rkey;
 	indirect_hdr->table_desc.len = cpu_to_be32(table_len);
 	indirect_hdr->len = cpu_to_be32(state.total_len);
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 60a33c1..255b0e5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -288,6 +288,10 @@ struct srp_map_state {
 			struct srp_fr_desc **next;
 			struct srp_fr_desc **end;
 		} fr;
+		struct {
+			void		   **next;
+			void		   **end;
+		} gen;
 	};
 	struct srp_direct_buf  *desc;
 	u64		       *pages;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
