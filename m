From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 4/5] IB/srpt: Wait until channel release has finished during module unload
Date: Fri, 3 Nov 2017 16:20:55 -0700
Message-ID: <20171103232056.30614-5-bart.vanassche@wdc.com>
References: <20171103232056.30614-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103232056.30614-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce the helper function srpt_set_enabled(). Protect
sport->enabled changes with sdev->mutex. Makes configfs writes
into 'enabled' wait until all channel resources have been freed.
Wait until channel release has finished during kernel module
unload.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 43 ++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 1aeb8d6ae6d9..ca602eb50078 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1821,19 +1821,31 @@ static bool srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
 	return wait;
 }
 
-static void __srpt_close_all_ch(struct srpt_device *sdev)
+static void srpt_set_enabled(struct srpt_port *sport, bool enabled)
+	__must_hold(&sdev->mutex)
 {
+	struct srpt_device *sdev = sport->sdev;
 	struct srpt_rdma_ch *ch;
 
 	lockdep_assert_held(&sdev->mutex);
 
+	if (sport->enabled == enabled)
+		return;
+	sport->enabled = enabled;
+	if (sport->enabled)
+		return;
+
+again:
 	list_for_each_entry(ch, &sdev->rch_list, list) {
-		if (srpt_disconnect_ch(ch) >= 0)
-			pr_info("Closing channel %s-%d because target %s has been disabled\n",
-				ch->sess_name, ch->qp->qp_num,
-				sdev->device->name);
-		srpt_close_ch(ch);
+		if (ch->sport == sport) {
+			pr_info("%s: closing channel %s-%d\n",
+				sdev->device->name, ch->sess_name,
+				ch->qp->qp_num);
+			if (srpt_disconnect_ch_sync(ch))
+				goto again;
+		}
 	}
+
 }
 
 static void srpt_free_ch(struct kref *kref)
@@ -2496,8 +2508,7 @@ static int srpt_release_sdev(struct srpt_device *sdev)
 
 	mutex_lock(&sdev->mutex);
 	for (i = 0; i < ARRAY_SIZE(sdev->port); i++)
-		sdev->port[i].enabled = false;
-	__srpt_close_all_ch(sdev);
+		srpt_set_enabled(&sdev->port[i], false);
 	mutex_unlock(&sdev->mutex);
 
 	res = wait_event_interruptible(sdev->ch_releaseQ,
@@ -3083,7 +3094,6 @@ static ssize_t srpt_tpg_enable_store(struct config_item *item,
 	struct se_portal_group *se_tpg = to_tpg(item);
 	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 	struct srpt_device *sdev = sport->sdev;
-	struct srpt_rdma_ch *ch;
 	unsigned long tmp;
         int ret;
 
@@ -3097,24 +3107,11 @@ static ssize_t srpt_tpg_enable_store(struct config_item *item,
 		pr_err("Illegal value for srpt_tpg_store_enable: %lu\n", tmp);
 		return -EINVAL;
 	}
-	if (sport->enabled == tmp)
-		goto out;
-	sport->enabled = tmp;
-	if (sport->enabled)
-		goto out;
 
 	mutex_lock(&sdev->mutex);
-	list_for_each_entry(ch, &sdev->rch_list, list) {
-		if (ch->sport == sport) {
-			pr_debug("%s: ch %p %s-%d\n", __func__, ch,
-				 ch->sess_name, ch->qp->qp_num);
-			srpt_disconnect_ch(ch);
-			srpt_close_ch(ch);
-		}
-	}
+	srpt_set_enabled(sport, tmp);
 	mutex_unlock(&sdev->mutex);
 
-out:
 	return count;
 }
 
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
