From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 15/17] RDMA/ocrdma: Support for Skyhawk
 statistics
Date: Fri, 14 Feb 2014 06:16:37 +0000
Message-ID: <8db16c88-7b7f-4fd0-94f5-bc3268d6ae58@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
 <91cc4eb6-5895-486d-b6b9-8a97b79dfc71@CMEXHTCAS2.ad.emulex.com>
 <CAJZOPZK-w98t0=K4AUceKPCbwjd75BBjG325YgbQ-iV-ETosPg@mail.gmail.com>
 <CAJZOPZ+ajdDtehBJnwUGA5mgMM2aDn1JsY=0Pas3Se-WfZYs4A@mail.gmail.com>
 <424c56ee-b168-48e2-a298-f30a326ee8d0@CMEXHTCAS1.ad.emulex.com>
 <20140208191633.GA24320@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140208191633.GA24320-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello all,

We would like to keep this patch for debugging purpose and we will submit another patch which will be compliant with IB-stack sysfs infrastructure once this set of patch are into the mainstream.
If any ABI for debugfs is changed, we will follow the changes.

-Regards
 Devesh
-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
Sent: Sunday, February 09, 2014 12:47 AM
To: Devesh Sharma
Cc: Or Gerlitz; linux-rdma; Roland Dreier; Selvin Xavier
Subject: Re: [PATCH for-next 15/17] RDMA/ocrdma: Support for Skyhawk statistics

On Sat, Feb 08, 2014 at 04:26:37AM +0000, Devesh Sharma wrote:

> We are having some 200 Odds vendor specific stats to be displayed. 
> With sysfs infrastructure for IB devices we found that each stat will 
> correspond to one file in sysfs tree therefore it will constitute a 
> large number of files in ocrdma tree per port, situation will worsen 
> if SRIOV and Multichannel comes into picture, On the other hand, with 
> debugfs it is possible to have one file displaying multiple stats 
> thus, drastically reducing the number of sysfs file entries.

This really is what netlink is for.

Remember, debugfs is not a stable ABI area, it could change at any moment, You must not ship tools to end users that process these stats if they come out through debugfs - it is not a way to bypass the kernel API rules. It is just something for developers to use.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
