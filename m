From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Tue, 19 Apr 2016 14:41:47 -0500
Message-ID: <01a901d19a73$82ad7f60$88087e20$@opengridcomputing.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <1460410360-13104-3-git-send-email-hch@lst.de> <20160419031425.GB27515@rhel.amr.corp.intel.com> <20160419173032.GD20844@obsidianresearch.com> <57167D9F.9060808@grimberg.me> <20160419192430.GB27028@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160419192430.GB27028-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Tue, Apr 19, 2016 at 09:49:03PM +0300, Sagi Grimberg wrote:
> >
> > >>>The new RW API will need this.
> > >>>
> > >>>Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > >>>Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > >>>Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > >>
> > >>I'm not opposed to this change but traditionally QPs are bound to a
> > >>device not to a single port.
> > >
> > >Right, this was done because rdma_protocol_iwarp takes a port number.
> > >
> > >I think we discussed this once, the core code doesn't actually support
> > >different protocols on different ports, so the port_num argument to
> > >rdma_protocol_iwarp is redundant.
> > >
> > >This all starts to look really goofy when multi-port APM is used and
> > >the QP's port number changes dynamically at runtime. (I have some
> > >experimental patches that do that), I'd rather see all the port_num
> > >stuff in this series go away. :(
> >
> > HCH and I complained about this per-port distinction in several private
> > conversations. I'd really love to see it go away too.
> 
> I'm in support of eliminating them. One protocol per device.
>

Ditto.
 
> IB APM hard requires those semantics, and that reflects the reality of
> all the drivers today.
> 
> Nothing more is required than sending a patch, IHMO..
> 

I've been trying to sift through the original threads regarding
rdma_protocol_iwarp() and friends.  I couldn't find anybody advocating hard that
the protocol/transport type should be per port.
 
I think this thread has Doug stating it really should be per-device and static.
Doug, correct me if I'm wrong...

https://lkml.org/lkml/2015/4/10/612

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
