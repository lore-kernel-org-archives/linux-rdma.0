From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 09:46:04 -0500
Message-ID: <002c01d0b343$7dad3b30$7907b190$@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213618.4188.50574.stgit@build.ogc.int> <55925B70.1070409@mellanox.com> <001e01d0b341$1eefe9f0$5ccfbdd0$@opengridcomputing.com> <23E050C1-2A41-4E99-9539-15B07545CA44@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23E050C1-2A41-4E99-9539-15B07545CA44-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
> Sent: Tuesday, June 30, 2015 9:42 AM
> To: Steve Wise
> Cc: Or Gerlitz; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
> 
> 
> On Jun 30, 2015, at 10:29 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
> >
> >
> >> -----Original Message-----
> >> From: Or Gerlitz [mailto:ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> >> Sent: Tuesday, June 30, 2015 4:04 AM
> >> To: Steve Wise; Chuck Lever
> >> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org;
> >> infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> >> Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
> >>
> >> On 6/30/2015 12:36 AM, Steve Wise wrote:
> >>> The semantics for MR access flags are not consistent across RDMA
> >>> protocols.  So rather than have applications try and glean what they
> >>> need, have them pass in the intended roles and attributes for the MR to
> >>> be allocated and let the RDMA core select the appropriate access flags
> >>> given the roles, attributes, and device capabilities.
> >>
> >> wait, we have NFSoRDMA (net/sunrpc/xprtrdma/*) in the kernel for years
> >> and it works on top of both IB/RoCE and iWARP.I know they have there 5-6
> >> memory registration methods.. but if we stick to their mode that uses
> >> fast registration ala your upstream commit 0f7ec3 "RDMA/core: Add memory
> >> management extensions support"  -- what's missing or how come it work
> >> w/o the enhancement suggested here?Added Chuck.
> >
> > NFSRDMA currently checks the transport type to decide how to set the access flags for memory registration.  With the new
services
> exported in this series, we can change/simplify NFSRDMA to not have to know the transport type.
> 
> I was planning to look at this more closely soon, but if you
> have patches I'd happily consider them, or you can just point
> me to what needs to be changed and I can put it together for 4.3.
>

Thanks.  I suggest you hold off on NFSRDMA changes until we get closure on the new core services.  Once it stabilizes, I'll ping ya.
(and I'll CC you on subsequent versions of this).

Stevo


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
