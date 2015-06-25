From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 14:25:49 -0500
Message-ID: <006901d0af7c$be6c04a0$3b440de0$@opengridcomputing.com>
References: <20150625153754.13272.432.stgit@build.ogc.int> <20150625153922.13272.41789.stgit@build.ogc.int> <20150625182505.GA15337@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FF9D60@ORSMSX109.amr.corp.intel.com> <005a01d0af75$70c9eb60$525dc220$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373A8FF9D96@ORSMSX109.amr.corp.intel.com> <20150625191220.GA15726@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FF9DF9@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF9DF9-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Roi Dayan' <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> Sent: Thursday, June 25, 2015 2:20 PM
> To: Jason Gunthorpe
> Cc: Steve Wise; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Roi Dayan
> Subject: RE: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
> 
> > What about moving to something more specific? Encode the allowed verbs
> > in the access flag?
> 
> This makes more sense to me.  Something like: SEND, RECV, INIT READ, INIT WRITE, READ TARGET, WRITE TARGET, etc.  We're close to
> this, but it's not clear, for example, what flags are needed for a receive buffer.  None?  LOCAL_WRITE?

Make sense to me too.

To stage the changes we could introduce a new function that returns the needed ib_access_flags value given the desired opcodes.
Then have a series that changes all the existing ULPs to make use of this new function.  

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
