From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/3] iw_cm: free cm_id resources on the last deref
Date: Wed, 20 Jul 2016 08:51:03 -0500
Message-ID: <027401d1e28d$c15bcca0$441365e0$@opengridcomputing.com>
References: <cover.1468879135.git.swise@opengridcomputing.com> <93c3c47c16406ef00184011948424a9597e4c6b8.1468879135.git.swise@opengridcomputing.com> <578F3B92.2050803@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <578F3B92.2050803-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> 
> > Remove the complicated logic to free the cm_id resources in iw_cm event
> > handlers vs when an application thread destroys the device.  I'm not sure
> > why this code was written, but simply allowing the last deref to free
> > the memory is cleaner.  It also prevents a deadlock when applications
> > try to destroy cm_id's in their cm event handler function.
> 
> The description here is misleading. we can never destroy the cm_id
> inside the cm_id handler. Also, I don't think the deadlock was on cm_id
> removal but rather on the qp referenced by the cm_id. I think the change
> log can be improved.
>

I'll reword it. 
 
> The patch looks fine to me.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
