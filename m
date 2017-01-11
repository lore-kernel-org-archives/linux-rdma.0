From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: NFSoRDMA Fails for max_sge Less Than 18
Date: Wed, 11 Jan 2017 15:15:04 -0600
Message-ID: <042601d26c4f$c7190e90$554b2bb0$@opengridcomputing.com>
References: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com> <FE817A76-28A7-4AEC-AF1E-01DE15790E43@oracle.com> <027101d26c2c$c94467f0$5bcd37d0$@opengridcomputing.com> <28B0D906-7BDB-4B87-94E9-6BE263BFBFF7@oracle.com> <20170111211123.GD28917@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111211123.GD28917-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "'Amrani, Ram'" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Elior, Ariel'" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Kalderon, Michal'" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Hariprasad S' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, Jan 11, 2017 at 02:40:37PM -0500, Chuck Lever wrote:
> 
> > It might be cool to have an API similar to rdma_rw that allows ULPs
> > to use a scatterlist for Send and Receive operations. It could hide
> > the driver and device maximum SGE values.
> 
> That would be good, it could bounce buffer, build temporary MRs,
> or repeat RDMA WRITE/READ as appropriate..
> 

We're talking SEND opcodes where the ULP transfers data in the SEND that
includes the command request or reply instead of having the target/server side
issue RDMA opcodes.

> The ULP really is not the right place to put this trade off logic
> since it will be very device specific..
> 

A temporary REG_MR would do the trick...assuming it can contain the SGE depth as
well.  But issuing multiple SEND operations involves ULP protocol headers so
that couldn't be done by a core service...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
