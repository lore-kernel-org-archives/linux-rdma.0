From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 14:44:59 -0500
Message-ID: <007001d0af7f$6bc38ef0$434aacd0$@opengridcomputing.com>
References: <20150625153754.13272.432.stgit@build.ogc.int> <20150625153922.13272.41789.stgit@build.ogc.int> <20150625182505.GA15337@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FF9D60@ORSMSX109.amr.corp.intel.com> <005a01d0af75$70c9eb60$525dc220$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373A8FF9D96@ORSMSX109.amr.corp.intel.com> <20150625191220.GA15726@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FF9DF9@ORSMSX109.amr.corp.intel.com> <006901d0af7c$be6c04a0$3b440de0$@opengridcomputing.com> <20150625192934.GB15726@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625192934.GB15726-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Roi Dayan' <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Thursday, June 25, 2015 2:30 PM
> To: Steve Wise
> Cc: 'Hefty, Sean'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; 'Roi Dayan'
> Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
> 
> On Thu, Jun 25, 2015 at 02:25:49PM -0500, Steve Wise wrote:
> 
> > To stage the changes we could introduce a new function that returns
> > the needed ib_access_flags value given the desired opcodes.  Then
> > have a series that changes all the existing ULPs to make use of this
> > new function.
> 
> I wouldn't be afraid to add a new create_mr entry point that does the
> right thing, we can unexport/delete the old one when all kernel users
> are gone. Trivially the core can just have a default that translates
> based on iwarp/!iwarp for now.
> 

Ignoring user MRs at this point, I think we would need a new entry point for creating dma mrs ala ib_get_dma_mr().

How defining MR "roles":

/**
 * ib_mr_role - possible roles a MR will be used for
 *
 * This allows a transport independent RDMA application to
 * create MRs that are usable for all the desired roles w/o
 * having to understand which access rights are needed.
 */
enum ib_mr_role {
	IB_MRR_RECV		= 1,
	IB_MRR_SEND		 = (1<<1),
	IB_MRR_READ_SOURCE = (1<<2),
	IB_MRR_READ_SINK	= (1<<3),
	IB_MRR_WRITE_SOURCE = (1<<4),
	IB_MRR_WRITE_SINK	 = (1<<5),
	/* probably more roles */
};

Then new entry point that will call ib_get_dma_mr() with the ib_access_flags required to handle the roles for the given device
protocol.

ib_get_dma_role_mr(struct ib_pd *pd, int mr_role_flags)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
