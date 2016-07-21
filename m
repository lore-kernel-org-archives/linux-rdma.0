From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/3] iw_cm: free cm_id resources on the last deref
Date: Thu, 21 Jul 2016 10:45:13 -0500
Message-ID: <04a101d1e366$df0c9c50$9d25d4f0$@opengridcomputing.com>
References: <cover.1468879135.git.swise@opengridcomputing.com> <93c3c47c16406ef00184011948424a9597e4c6b8.1468879135.git.swise@opengridcomputing.com> <578F3B92.2050803@grimberg.me> <027401d1e28d$c15bcca0$441365e0$@opengridcomputing.com> <045f01d1e35a$93618a60$ba249f20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <045f01d1e35a$93618a60$ba249f20$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> While I'm rambling, there is still a condition that probably needs to be
> addressed:  if the application event handler function disconnects the
> cm_id that is handling the event, the iw_cm workq thread gets stuck
> posting a IW_CM_EVENT_CLOSE to rdma_cm.  So the iw_cm workq thread is
> stuck in cm_close_handler() calling cm_id_priv->id.cm_handler() which is
> cma_iw_handler() which is blocked in cma_disable_callback() because the
> application is currently running its event handler for this cm_id.  This
> block is released when the application returns from its event handler
> function.
> 
> But maybe cma_iw_handler() should queue the event if it cannot deliver it,
> vs blocking the iw_cm workq thread?
> 

Answering myself:  queueing the event seems to be a no-go because the rdma_cm
can return non-zero to the iw_cm to indicate it should destroy the iw_cm_id.
This cannot be done correctly if the event is queued/deferred.





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
