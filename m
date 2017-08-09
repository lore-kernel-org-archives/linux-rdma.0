From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Flush warning
Date: Wed, 9 Aug 2017 11:38:49 -0500
Message-ID: <011601d3112d$fa305b70$ee911250$@opengridcomputing.com>
References: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com> <9bc142de-b8ba-acb6-5ea1-2ccdbb578655@grimberg.me> <003401d30f91$c7e2a3f0$57a7ebd0$@opengridcomputing.com> <00ff01d3112b$94142350$bc3c69f0$@opengridcomputing.com> <20170809162749.GA4069@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809162749.GA4069-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Wed, Aug 09, 2017 at 11:21:38AM -0500, Steve Wise wrote:
> 
> > > I don't know.  I read the workqueue doc on WQ_MEM_RECLAIM, but I don't
> know
> > > how
> > > to tell if iw_cm needs this or not.  Can you give me an example of a
workqueue
> > > that _does_ need WQ_MEM_RECLAIM?  I _think_ it means your workqueue is
> > > required
> > > to run something that would get triggered by the oom OS code, but I don't
know
> > > if that would include rdma CMs or not...
> >
> > Many of the workqueues in infiniband/core use WQ_MEM_RECLAIM: cma, iwcm,
> mad,
> > multicast, sa_query, and ucma.
> >
> > Hey Sean, do you have any insight into whether the CMA modules really need
> > WQ_MEM_RECLAIM for their workqueues?
> >
> > Does anyone else know?
> 
> Consider that the ib_core can be used to back storage. Ie consider a
> situation where iSER/NFS/SRP needs to reconnect to respond to kernel
> paging/reclaim.
> 
> On the surface it seems reasonable to me that these are on a reclaim
> path?
> 
> Jason

hmm.  That seems reasonable.  Then I would think the nvme_rdma would also need
to be using a reclaim workqueue.

Sagi, Do you think I should add a private workqueue with WQ_MEM_RECLAIM to
nvme_rdma vs using the system_wq?  nvme/target probably needs one also...

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
