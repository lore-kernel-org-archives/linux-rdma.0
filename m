From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch] IB: handle -ENOMEM in forward_trap()
Date: Fri, 10 Dec 2010 10:20:56 +0300
Message-ID: <20101210072056.GZ10623@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ib_create_send_mad() can return ERR_PTR(-ENOMEM) here.

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index c9a8dd6..a1add16 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -211,6 +211,9 @@ static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, struct ib_mad *ma
 	if (agent) {
 		send_buf = ib_create_send_mad(agent, qpn, 0, 0, IB_MGMT_MAD_HDR,
 					      IB_MGMT_MAD_DATA, GFP_ATOMIC);
+
+		if (IS_ERR(send_buf))
+			return;
 		/*
 		 * We rely here on the fact that MLX QPs don't use the
 		 * address handle after the send is posted (this is
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 5648659..03a59534 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -171,6 +171,8 @@ static void forward_trap(struct mthca_dev *dev,
 	if (agent) {
 		send_buf = ib_create_send_mad(agent, qpn, 0, 0, IB_MGMT_MAD_HDR,
 					      IB_MGMT_MAD_DATA, GFP_ATOMIC);
+		if (IS_ERR(send_buf))
+			return;
 		/*
 		 * We rely here on the fact that MLX QPs don't use the
 		 * address handle after the send is posted (this is
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
