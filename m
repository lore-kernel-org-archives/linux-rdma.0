From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: NFSoRDMA Fails for max_sge Less Than 18
Date: Wed, 11 Jan 2017 15:48:19 -0600
Message-ID: <043d01d26c54$6c2fcb90$448f62b0$@opengridcomputing.com>
References: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com> <FE817A76-28A7-4AEC-AF1E-01DE15790E43@oracle.com> <027101d26c2c$c94467f0$5bcd37d0$@opengridcomputing.com> <28B0D906-7BDB-4B87-94E9-6BE263BFBFF7@oracle.com> <20170111211123.GD28917@obsidianresearch.com> <042601d26c4f$c7190e90$554b2bb0$@opengridcomputing.com> <20170111213416.GA30681@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111213416.GA30681-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "'Amrani, Ram'" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Elior, Ariel'" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Kalderon, Michal'" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Hariprasad S' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Wed, Jan 11, 2017 at 03:15:04PM -0600, Steve Wise wrote:
> 
> > > That would be good, it could bounce buffer, build temporary MRs,
> > > or repeat RDMA WRITE/READ as appropriate..
> >
> > We're talking SEND opcodes where the ULP transfers data in the SEND that
> > includes the command request or reply instead of having the target/server
side
> > issue RDMA opcodes.
> 
> Yes, I know, handling READ/WRITE also would be the 'full generality'
> of a core API in this area.
> 
> > > The ULP really is not the right place to put this trade off logic
> > > since it will be very device specific..
> >
> > A temporary REG_MR would do the trick...assuming it can contain the SGE
depth
> as
> > well.  But issuing multiple SEND operations involves ULP protocol headers so
> > that couldn't be done by a core service...
> 
> Right, for SEND the core API would need to pack the given SG list into
> whatever the device limit is, using bounce buffers if necessary.
>
> For NFS, since the data is coming out of the page cache, a MR should
> be always be buildable for the data? That means 1 send sge for the
> header and 1 for the MR?
>

Yes, but the REG_MR has limits on how many pages can be registered, so it could
be 1 for the header and n MRs.  And if n causes the send_wr max_sge to be
exceeded something else would have to be done.   Maybe bounce buffers could be
used?  I'm not sure how though.  And maybe the API just fails in this case and
the ULP will have to _not_ send this as inline?
 
> Basically the core API would be a packing API - input a SG list and a
> MR pool and you get back another SG list that fits within the device
> limits and can be used in a WR.
> 
> The core figures out how to optimally compute the packed SG list.
>

Are you volunteering? :)  Or should we sign up Christoph? :):)



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
