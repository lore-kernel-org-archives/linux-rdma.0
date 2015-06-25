From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 13:12:20 -0600
Message-ID: <20150625191220.GA15726@obsidianresearch.com>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153922.13272.41789.stgit@build.ogc.int>
 <20150625182505.GA15337@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9D60@ORSMSX109.amr.corp.intel.com>
 <005a01d0af75$70c9eb60$525dc220$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9D96@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF9D96-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 06:45:56PM +0000, Hefty, Sean wrote:
> > How would you envision doing this?  At the time a MR is registered the
> > device driver doesn't know if the application will be doing
> > RDMA reads or not on that MR.
> 
> I was thinking of checking for REMOTE_READ, but that doesn't work on the initiator side.
> 
> I guess you could a READ_DEST(SOURCE? TARGET?) flag to indicate that
> the MR will be used on the initiating side of the RDMA read
> operation.

Yes, that does make more sense...

What about moving to something more specific? Encode the allowed verbs
in the access flag?

I don't understand why iWarp HW choose to ignore the verbs spec and
not use IB_ACCESS_LOCAL_WRITE to cover RDMA READ responses...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
