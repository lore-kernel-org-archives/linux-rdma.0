From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 5/5] IB/srpt: Ensure that modifying the use_srq configfs attribute works
Date: Fri, 3 Nov 2017 16:20:56 -0700
Message-ID: <20171103232056.30614-6-bart.vanassche@wdc.com>
References: <20171103232056.30614-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103232056.30614-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The use_srq configfs attribute is created after it is read. Hence
modify srpt_tpg_attrib_use_srq_store() such that this function
switches dynamically between non-SRQ and SRQ mode.

Reported-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index ca602eb50078..fde4f6741316 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3054,7 +3054,9 @@ static ssize_t srpt_tpg_attrib_use_srq_store(struct config_item *item,
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
 	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
+	struct srpt_device *sdev = sport->sdev;
 	unsigned long val;
+	bool enabled;
 	int ret;
 
 	ret = kstrtoul(page, 0, &val);
@@ -3062,7 +3064,17 @@ static ssize_t srpt_tpg_attrib_use_srq_store(struct config_item *item,
 		return ret;
 	if (val != !!val)
 		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&sdev->mutex);
+	if (ret < 0)
+		return ret;
+	enabled = sport->enabled;
+	/* Log out all initiator systems before changing 'use_srq'. */
+	srpt_set_enabled(sport, false);
 	sport->port_attrib.use_srq = val;
+	srpt_use_srq(sdev, sport->port_attrib.use_srq);
+	srpt_set_enabled(sport, enabled);
+	mutex_unlock(&sdev->mutex);
 
 	return count;
 }
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
