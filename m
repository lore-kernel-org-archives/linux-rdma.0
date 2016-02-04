From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 15/21] IB/srpt: Log private data associated with REJ
Date: Thu, 4 Feb 2016 14:57:07 -0800
Message-ID: <56B3D743.80004@sandisk.com>
References: <56B3D453.7030409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B3D453.7030409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To make it possible to determine why an initiator sent a REJ,
log the private data associated with the received REJ packet.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8473515..3f8925e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2252,8 +2252,17 @@ static void srpt_cm_rej_recv(struct srpt_rdma_ch *ch,
 			     const u8 *private_data,
 			     u8 private_data_len)
 {
-	pr_info("Received CM REJ for ch %s-%d; reason %d.\n",
-		ch->sess_name, ch->qp->qp_num, reason);
+	char *priv = kmalloc(private_data_len * 3 + 1, GFP_KERNEL);
+	int i;
+
+	if (priv) {
+		priv[0] = '\0';
+		for (i = 0; i < private_data_len; i++)
+			sprintf(priv + 3 * i, "%02x ", private_data[i]);
+	}
+	pr_info("Received CM REJ for ch %s-%d; reason %d; private data %s.\n",
+		ch->sess_name, ch->qp->qp_num, reason, priv ? : "(?)");
+	kfree(priv);
 	srpt_drain_channel(ch);
 }
 
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
