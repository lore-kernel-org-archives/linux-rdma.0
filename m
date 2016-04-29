From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Thu, 28 Apr 2016 18:01:46 -0600
Message-ID: <20160429000146.GB2782@obsidianresearch.com>
References: <1460410360-13104-3-git-send-email-hch@lst.de>
 <20160419031425.GB27515@rhel.amr.corp.intel.com>
 <20160419173032.GD20844@obsidianresearch.com>
 <57167D9F.9060808@grimberg.me>
 <20160419192430.GB27028@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB047108@ORSMSX109.amr.corp.intel.com>
 <20160428200759.GA32110@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0471EC@ORSMSX109.amr.corp.intel.com>
 <20160428220945.GA1542@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E22EC858F@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E22EC858F-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 11:25:35PM +0000, Weiny, Ira wrote:

> Mellanox how hard will it be to change your drivers to that model?
> I'm not even sure how the detection of Link Layer works any more.

Hmm, I vaugely remember looking into this and thinking the mlx drivers
already did this?

It may even be that IB and rocee can do APM and could perhaps be part
of the same struct ib_device without breaking the world. I actually
have no idea.

> But all that is different from the qib/hfi case where we have 1 port
> with 2 protocols on it.  If we are going to add PSM into the core
> then I think it is _semantically_ appropriate for users to be able
> to query for the protocols supported on a port and get back more
> than 1.

That doesn't make sense, the issue here is that we have a variety of
verbs 'flavours'. PSM is not a verbs flavour.

*If* PSM gets a kAPI (nobody is talking about doing this?) *and* gains
multiple incompatible flavours (such as OPA and IB?) then it will need
a unique set of cap tests and restrictions on which physical ports can
be used together.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
