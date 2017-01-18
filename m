From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 02/11] IB/core: Enable WQ creation and modification with cvlan offload
Date: Wed, 18 Jan 2017 15:39:55 +0200
Message-ID: <20170118134004.5380-3-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable WQ creation and modification with cvlan stripping offload.
This includes:
- Adding WQ creation flags.
- Extending modify WQ to get flags and flags mask to enable turning
  it on and off.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index edb9ff0..d5cdf36 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1494,6 +1494,10 @@ struct ib_wq {
 	atomic_t		usecnt;
 };
 
+enum ib_wq_flags {
+	IB_WQ_FLAGS_CVLAN_STRIPPING	= 1 << 0,
+};
+
 struct ib_wq_init_attr {
 	void		       *wq_context;
 	enum ib_wq_type	wq_type;
@@ -1501,16 +1505,20 @@ struct ib_wq_init_attr {
 	u32		max_sge;
 	struct	ib_cq	       *cq;
 	void		    (*event_handler)(struct ib_event *, void *);
+	u32		create_flags; /* Use enum ib_wq_flags */
 };
 
 enum ib_wq_attr_mask {
-	IB_WQ_STATE	= 1 << 0,
-	IB_WQ_CUR_STATE	= 1 << 1,
+	IB_WQ_STATE		= 1 << 0,
+	IB_WQ_CUR_STATE		= 1 << 1,
+	IB_WQ_FLAGS		= 1 << 2,
 };
 
 struct ib_wq_attr {
 	enum	ib_wq_state	wq_state;
 	enum	ib_wq_state	curr_wq_state;
+	u32			flags; /* Use enum ib_wq_flags */
+	u32			flags_mask; /* Use enum ib_wq_flags */
 };
 
 struct ib_rwq_ind_table {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
