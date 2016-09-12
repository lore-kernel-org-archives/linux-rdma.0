From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: RFC: CQ pools and implicit CQ resource allocation
Date: Mon, 12 Sep 2016 15:22:23 -0500
Message-ID: <022901d20d33$5eebf1a0$1cc3d4e0$@opengridcomputing.com>
References: <1473424587-13818-1-git-send-email-hch@lst.de> <d0c645eb-3674-2841-bdb7-8b9e6fd46473@grimberg.me> <00e001d20d03$ea891100$bf9b3300$@opengridcomputing.com> <6dd3ecbd-7109-95ff-9c86-dfea9e515538@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6dd3ecbd-7109-95ff-9c86-dfea9e515538-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org]
> Sent: Monday, September 12, 2016 3:08 PM
> To: Steve Wise; 'Christoph Hellwig'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: RFC: CQ pools and implicit CQ resource allocation
> 
> 
> >> One other note that I wanted to raise for the folks interested in this
> >> is that with the RDMA core owning the completion queue pools, different
> >> ULPs can easily share the same completion queue (given that it uses
> >> the same poll context). For example, nvme-rdma host, iser and srp
> >> initiators can end up using the same completion queues (if running
> >> simultaneously on the same machine).
> >>
> >> Up until now, I couldn't think of anything that can introduce a problem
> >> with that but maybe someone else will...
> >
> > It would be useful to provide details on how many CQs get created and of
what
> > size for an uber iSER/NVMF/SRP initiator/host and target.
> 
> Are you talking about some debugfs layout?
>

No, just a matrix showing how the CQs scale out when shared among these three
ULPs on a machine with X cores, for example.   Just to visualize if the number
of CQs and their sizes are reduced by this new series or increased...
 
> > One concern I have is that cxgb4 CQs require contiguous memory,  So a scheme
> > like CQ pooling might cause resource problems on large core systems.
> 
> Note that the CQ allocation will never exceed the device max_cqe cap.

If this series causes, say, 2X the amount of memory needed for CQs vs the
existing private CQ approach, then that impacts how many CQs can be allocated,
due to limits on the amount of memory that can be allocated system-wide via
dma_alloc_coherent(), which is what cxgb4 uses to allocate queue memory.

So I'm just voicing the concern this design can possibly reduce the overall
number of CQs available on a given system.  It is probably not a big deal
though, but I don't have a good visualization of how much more memory this
proposed series would incur...

Stevo

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
