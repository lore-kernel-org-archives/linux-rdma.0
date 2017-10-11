From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 44/45] RDMA/usnic: Remove a set-but-not-used variable
Date: Wed, 11 Oct 2017 10:49:26 -0700
Message-ID: <20171011174927.25113-45-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 092d4e11a633..912d8ef04352 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -392,14 +392,12 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 				void *data)
 {
 	int status = 0;
-	int vnic_idx;
 	struct ib_event ib_event;
 	enum ib_qp_state old_state;
 	struct usnic_transport_spec *trans_spec;
 	struct usnic_ib_qp_grp_flow *qp_flow;
 
 	old_state = qp_grp->state;
-	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);
 	trans_spec = (struct usnic_transport_spec *) data;
 
 	spin_lock(&qp_grp->lock);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
