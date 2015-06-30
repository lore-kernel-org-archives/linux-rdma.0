From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 12:03:44 +0300
Message-ID: <55925B70.1070409@mellanox.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
 <20150629213618.4188.50574.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150629213618.4188.50574.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/30/2015 12:36 AM, Steve Wise wrote:
> The semantics for MR access flags are not consistent across RDMA
> protocols.  So rather than have applications try and glean what they
> need, have them pass in the intended roles and attributes for the MR to
> be allocated and let the RDMA core select the appropriate access flags
> given the roles, attributes, and device capabilities.

wait, we have NFSoRDMA (net/sunrpc/xprtrdma/*) in the kernel for years 
and it works on top of both IB/RoCE and iWARP.I know they have there 5-6 
memory registration methods.. but if we stick to their mode that uses 
fast registration ala your upstream commit 0f7ec3 "RDMA/core: Add memory 
management extensions support"  -- what's missing or how come it work 
w/o the enhancement suggested here?Added Chuck.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
