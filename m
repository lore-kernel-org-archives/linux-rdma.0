From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V6 9/9] isert: Support iWARP transports using FRMRs
Date: Fri, 24 Jul 2015 16:38:35 -0600
Message-ID: <20150724223835.GA29064@obsidianresearch.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161904.25617.85015.stgit@build2.ogc.int>
 <20150724165721.GC25480@obsidianresearch.com>
 <00ce01d0c641$493ea300$dbbbe900$@opengridcomputing.com>
 <20150724192411.GC26225@obsidianresearch.com>
 <00db01d0c64b$01f40300$05dc0900$@opengridcomputing.com>
 <00ee01d0c65d$a1e03cf0$e5a0b6d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00ee01d0c65d$a1e03cf0$e5a0b6d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2015 at 05:11:04PM -0500, Steve Wise wrote:

> By the way, just to be clear: If you use a FRWR, you by definition
> only have one SGE entry as the result of the registration.  So
> regardless of what a device/protocol can do with the destination SGE
> of an RDMA READ operation, if you use FRWR to register the
> destination region, you need only 1 SGE in the RDMA READ WR.

FRWR's have horrible restrictions on the scatterlist. To realize
arbitrary scatterlists requires multiple MRs, and thus multiple SGE
entries.

The warning is for a reader who might be familiar with IB and think
iWarp simply needs to have a MR wrapped around the memory and assume
gaps/etc can be supported through a s/g list, like IB can.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
