From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 19/21] IB/srpt: Log out all initiators if a port is
 disabled
Date: Thu, 4 Feb 2016 14:58:44 -0800
Message-ID: <56B3D7A4.4090306@sandisk.com>
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

If an initiator observes LUN deletion during shutdown of the
target stack then that will trigger an I/O error even when using
multipathd. Users need a way to avoid that shutting down the
target stack causes I/O errors, e.g. by providing a way to force
initiator logout. Hence close all sessions if a target port is
disabled.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0c88190..48009f5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3151,6 +3151,8 @@ static ssize_t srpt_tpg_enable_store(struct config_item *item,
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
 	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_device *sdev = sport->sdev;
+	struct srpt_rdma_ch *ch;
 	unsigned long tmp;
         int ret;
 
@@ -3164,11 +3166,24 @@ static ssize_t srpt_tpg_enable_store(struct config_item *item,
 		pr_err("Illegal value for srpt_tpg_store_enable: %lu\n", tmp);
 		return -EINVAL;
 	}
-	if (tmp == 1)
-		sport->enabled = true;
-	else
-		sport->enabled = false;
+	if (sport->enabled == tmp)
+		goto out;
+	sport->enabled = tmp;
+	if (sport->enabled)
+		goto out;
 
+	mutex_lock(&sdev->mutex);
+	list_for_each_entry(ch, &sdev->rch_list, list) {
+		if (ch->sport == sport) {
+			pr_debug("%s: ch %p %s-%d\n", __func__, ch,
+				 ch->sess_name, ch->qp->qp_num);
+			srpt_disconnect_ch(ch);
+			srpt_close_ch(ch);
+		}
+	}
+	mutex_unlock(&sdev->mutex);
+
+out:
 	return count;
 }
 
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
