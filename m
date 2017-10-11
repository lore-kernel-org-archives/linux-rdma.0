From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 02/45] IB/cm: Suppress gcc 7 fall-through complaints
Date: Wed, 11 Oct 2017 10:48:44 -0700
Message-ID: <20171011174927.25113-3-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4c4b46586af2..9b45484afd72 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2810,6 +2810,7 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
 			msg_response = CM_MSG_RESPONSE_OTHER;
 			break;
 		}
+		/* fall through */
 	default:
 		ret = -EINVAL;
 		goto error1;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
