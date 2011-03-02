From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib/cm: Cancel pending lap message when destroying an ID
Date: Wed, 2 Mar 2011 08:47:43 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC86C58E@orsmsx501.amr.corp.intel.com>
References: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When destroying a cm_id from a context of a work queue and if the lap_state of
this cm_id is IB_CM_LAP_SENT, we need to release the reference of this id that
was taken when sending the lap message.  Otherwise, if the expected apr
message gets lost, it is only after a long time that the reference will be
released, while during that the work handler thread is not available to process
other things.

This problem was reported by Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> and
Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Good catch, although, I think we can simplify the fix to the patch below
(completely untested).  Please let me know if this solves the issue for you.

 drivers/infiniband/core/cm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1d9616b..79da42d 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -888,6 +888,8 @@ retest:
 			       NULL, 0, NULL, 0);
 		break;
 	case IB_CM_ESTABLISHED:
+		if (cm_id->lap_state == IB_CM_LAP_SENT)
+			ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
 		spin_unlock_irq(&cm_id_priv->lock);
 		ib_send_cm_dreq(cm_id, NULL, 0);
 		goto retest;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
