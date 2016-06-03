From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/6] IB/mad: Fix indentation
Date: Fri, 3 Jun 2016 12:08:44 -0700
Message-ID: <8eccc2e6-d33b-6130-2460-86a1d67159ae@sandisk.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make indentation consistent. Detected by smatch.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 82fb511..2d49228 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1638,9 +1638,9 @@ static void remove_mad_reg_req(struct ib_mad_agent_private *agent_priv)
 		/* Now, check to see if there are any methods still in use */
 		if (!check_method_table(method)) {
 			/* If not, release management method table */
-			 kfree(method);
-			 class->method_table[mgmt_class] = NULL;
-			 /* Any management classes left ? */
+			kfree(method);
+			class->method_table[mgmt_class] = NULL;
+			/* Any management classes left ? */
 			if (!check_class_table(class)) {
 				/* If not, release management class table */
 				kfree(class);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
