From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Flush warning
Date: Mon, 7 Aug 2017 10:28:12 -0500
Message-ID: <003401d30f91$c7e2a3f0$57a7ebd0$@opengridcomputing.com>
References: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com> <9bc142de-b8ba-acb6-5ea1-2ccdbb578655@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9bc142de-b8ba-acb6-5ea1-2ccdbb578655-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > The WARNING seems to be due to nvmet_rdma_queue_connect() calling
> > flush_scheduled_work() while in the upcall from the RDMA_CM.  It I running
on
> > the iw_cm event workqueue, which is created with WQ_MEM_RECLAIM set.  I'm
> not
> > sure what this WARNING is telling me.  Does the iw_cm workqueue NOT need
> > WQ_MEM_RECLAIM set?  Or is there some other issue with the nvmet/rdma
> code doing
> > work flushing in the iw_cm workq context?
> 
> This flush is designed to prevent nvmet-rdma from having too much
> inflight resources in case of a high pace of controller teardown and
> establishment (like you trigger in your test).
> 
> queue teardowns are run on system_wq, does iw_cm needs memory
> reclamation protection?

I don't know.  I read the workqueue doc on WQ_MEM_RECLAIM, but I don't know who
to tell if iw_cm needs this or not.  Can you give me an example of a workqueue
that _does_ need WQ_MEM_RECLAIM?  I _think_ it means your workqueue is required
to run something that would get triggered by the oom OS code, but I don't know
if that would include rdma CMs or not...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
