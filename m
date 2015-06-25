From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 13:29:34 -0600
Message-ID: <20150625192934.GB15726@obsidianresearch.com>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153922.13272.41789.stgit@build.ogc.int>
 <20150625182505.GA15337@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9D60@ORSMSX109.amr.corp.intel.com>
 <005a01d0af75$70c9eb60$525dc220$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9D96@ORSMSX109.amr.corp.intel.com>
 <20150625191220.GA15726@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9DF9@ORSMSX109.amr.corp.intel.com>
 <006901d0af7c$be6c04a0$3b440de0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <006901d0af7c$be6c04a0$3b440de0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Roi Dayan' <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 02:25:49PM -0500, Steve Wise wrote:

> To stage the changes we could introduce a new function that returns
> the needed ib_access_flags value given the desired opcodes.  Then
> have a series that changes all the existing ULPs to make use of this
> new function.

I wouldn't be afraid to add a new create_mr entry point that does the
right thing, we can unexport/delete the old one when all kernel users
are gone. Trivially the core can just have a default that translates
based on iwarp/!iwarp for now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
