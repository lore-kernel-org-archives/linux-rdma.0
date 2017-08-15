From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Flush warning
Date: Tue, 15 Aug 2017 08:42:39 -0500
Message-ID: <001101d315cc$5c7cc9b0$15765d10$@opengridcomputing.com>
References: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com> <9bc142de-b8ba-acb6-5ea1-2ccdbb578655@grimberg.me> <003401d30f91$c7e2a3f0$57a7ebd0$@opengridcomputing.com> <00ff01d3112b$94142350$bc3c69f0$@opengridcomputing.com> <20170809162749.GA4069@obsidianresearch.com> <011601d3112d$fa305b70$ee911250$@opengridcomputing.com> <20170813064651.GR24282@mtr-leonro.local> <90ada4f5-d6a1-2b93-5164-c593955c20cf@grimberg.me> <20170813103359.GW24282@mtr-leonro.local> <3d9cca62-4612-53dc-776c-3aeb2df58365@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373AB17595A@ORSMSX109.amr.corp.intel.com> <00be01d31521$cb237900$616a6b00$@opengridcomputing.com> <64134765-9a10-d014-3ac4-b0f747d6c670@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <64134765-9a10-d014-3ac4-b0f747d6c670-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Hal Rosenstock' <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> 
> > By the way, the queue I'm actually having the problem with is in the iwcm, not
> > the ibcm.  I think we should remove WQ_MEM_RECLAIM from all the CM queues
> > because I agree now that ulps potentially can/will allocate memory in the
> > contect of these workqueues...
> 
> Agreed, want to take it Steve or should I?

Please do take it.  That would help.  Thanks!

Steve


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
