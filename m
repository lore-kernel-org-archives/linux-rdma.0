From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 6 Aug 2015 09:24:38 -0700
Message-ID: <20150806162438.GA27608@infradead.org>
References: <20150804143447.GA22172@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150804143447.GA22172-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've pushed out a new version.  Updates:

 - the ib_recv_wr change Bart notices has been fixed.
 - iser and isert have been converted
 - the handling of the embedded WR in the qib software queue entry
   has been fixed.

Which means we're basically done now and the patch could use
broader testing.

The full patch will be too much for the list again, so here is the
git commit:

http://git.infradead.org/users/hch/scsi.git/commitdiff/a0027ed00fc3ae2686d8a843a724b50597115a71

ib_vers.h diff below:

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0940051..2f2efdd 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1100,54 +1100,94 @@ struct ib_send_wr {
 		__be32		imm_data;
 		u32		invalidate_rkey;
 	} ex;
-	union {
-		struct {
-			u64	remote_addr;
-			u32	rkey;
-		} rdma;
-		struct {
-			u64	remote_addr;
-			u64	compare_add;
-			u64	swap;
-			u64	compare_add_mask;
-			u64	swap_mask;
-			u32	rkey;
-		} atomic;
-		struct {
-			struct ib_ah *ah;
-			void   *header;
-			int     hlen;
-			int     mss;
-			u32	remote_qpn;
-			u32	remote_qkey;
-			u16	pkey_index; /* valid for GSI only */
-			u8	port_num;   /* valid for DR SMPs on switch only */
-		} ud;
-		struct {
-			u64				iova_start;
-			struct ib_fast_reg_page_list   *page_list;
-			unsigned int			page_shift;
-			unsigned int			page_list_len;
-			u32				length;
-			int				access_flags;
-			u32				rkey;
-		} fast_reg;
-		struct {
-			struct ib_mw            *mw;
-			/* The new rkey for the memory window. */
-			u32                      rkey;
-			struct ib_mw_bind_info   bind_info;
-		} bind_mw;
-		struct {
-			struct ib_sig_attrs    *sig_attrs;
-			struct ib_mr	       *sig_mr;
-			int			access_flags;
-			struct ib_sge	       *prot;
-		} sig_handover;
-	} wr;
 	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
 };
 
+struct ib_rdma_wr {
+	struct ib_send_wr	wr;
+	u64			remote_addr;
+	u32			rkey;
+};
+
+static inline struct ib_rdma_wr *rdma_wr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_rdma_wr, wr);
+}
+
+struct ib_atomic_wr {
+	struct ib_send_wr	wr;
+	u64			remote_addr;
+	u64			compare_add;
+	u64			swap;
+	u64			compare_add_mask;
+	u64			swap_mask;
+	u32			rkey;
+};
+
+static inline struct ib_atomic_wr *atomic_wr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_atomic_wr, wr);
+}
+
+struct ib_ud_wr {
+	struct ib_send_wr	wr;
+	struct ib_ah		*ah;
+	void			*header;
+	int			hlen;
+	int			mss;
+	u32			remote_qpn;
+	u32			remote_qkey;
+	u16			pkey_index; /* valid for GSI only */
+	u8			port_num;   /* valid for DR SMPs on switch only */
+};
+
+static inline struct ib_ud_wr *ud_wr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_ud_wr, wr);
+}
+
+struct ib_fast_reg_wr {
+	struct ib_send_wr	wr;
+	u64			iova_start;
+	struct ib_fast_reg_page_list *page_list;
+	unsigned int		page_shift;
+	unsigned int		page_list_len;
+	u32			length;
+	int			access_flags;
+	u32			rkey;
+};
+
+static inline struct ib_fast_reg_wr *fast_reg_wr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_fast_reg_wr, wr);
+}
+
+struct ib_bind_mw_wr {
+	struct ib_send_wr	wr;
+	struct ib_mw		*mw;
+	/* The new rkey for the memory window. */
+	u32			rkey;
+	struct ib_mw_bind_info	bind_info;
+};
+
+static inline struct ib_bind_mw_wr *bind_mw_wr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_bind_mw_wr, wr);
+}
+
+struct ib_sig_handover_wr {
+	struct ib_send_wr	wr;
+	struct ib_sig_attrs    *sig_attrs;
+	struct ib_mr	       *sig_mr;
+	int			access_flags;
+	struct ib_sge	       *prot;
+};
+
+static inline struct ib_sig_handover_wr *sig_handover_wr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_sig_handover_wr, wr);
+}
+
 struct ib_recv_wr {
 	struct ib_recv_wr      *next;
 	u64			wr_id;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
