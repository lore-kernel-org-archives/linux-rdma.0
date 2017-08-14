From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Flush warning
Date: Mon, 14 Aug 2017 17:01:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB17595A@ORSMSX109.amr.corp.intel.com>
References: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com>
 <9bc142de-b8ba-acb6-5ea1-2ccdbb578655@grimberg.me>
 <003401d30f91$c7e2a3f0$57a7ebd0$@opengridcomputing.com>
 <00ff01d3112b$94142350$bc3c69f0$@opengridcomputing.com>
 <20170809162749.GA4069@obsidianresearch.com>
 <011601d3112d$fa305b70$ee911250$@opengridcomputing.com>
 <20170813064651.GR24282@mtr-leonro.local>
 <90ada4f5-d6a1-2b93-5164-c593955c20cf@grimberg.me>
 <20170813103359.GW24282@mtr-leonro.local>
 <3d9cca62-4612-53dc-776c-3aeb2df58365@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3d9cca62-4612-53dc-776c-3aeb2df58365-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >>> The workqueue which frees the memory and doesn't allocate memory
> >>> during execution is supposed to be marked as WQ_MEM_RECLAIM. This
> >>> flag will cause to priority increase for such workqueue during low
> memory conditions.
> >>
> >> Which to my understanding means that CM workqueue should not use it
> >> as on each CM connect, by definition the ULP allocates memory (qp,
> cq etc).
> >
> > From my understanding too.
> > That workqueue was introduced in 2005, in a977049dacde ("[PATCH] IB:
> > Add the kernel CM implementation"), it is not clear if it was
> > intentionally.
> >
> > Hal,
> > do you remember the rationale there?
> 
> Sean is best to respond to this.

I believe the work queue was to avoid potential deadlocks that could arise from using the MAD work queue.  The original submission did not mark the work queue with WQ_MEM_RECLAIM.  I do not know when that change was added.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
