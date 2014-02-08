From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 15/17] RDMA/ocrdma: Support for Skyhawk
 statistics
Date: Sat, 8 Feb 2014 12:16:33 -0700
Message-ID: <20140208191633.GA24320@obsidianresearch.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
 <91cc4eb6-5895-486d-b6b9-8a97b79dfc71@CMEXHTCAS2.ad.emulex.com>
 <CAJZOPZK-w98t0=K4AUceKPCbwjd75BBjG325YgbQ-iV-ETosPg@mail.gmail.com>
 <CAJZOPZ+ajdDtehBJnwUGA5mgMM2aDn1JsY=0Pas3Se-WfZYs4A@mail.gmail.com>
 <424c56ee-b168-48e2-a298-f30a326ee8d0@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <424c56ee-b168-48e2-a298-f30a326ee8d0-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Feb 08, 2014 at 04:26:37AM +0000, Devesh Sharma wrote:

> We are having some 200 Odds vendor specific stats to be
> displayed. With sysfs infrastructure for IB devices we found that
> each stat will correspond to one file in sysfs tree therefore it
> will constitute a large number of files in ocrdma tree per port,
> situation will worsen if SRIOV and Multichannel comes into picture,
> On the other hand, with debugfs it is possible to have one file
> displaying multiple stats thus, drastically reducing the number of
> sysfs file entries.

This really is what netlink is for.

Remember, debugfs is not a stable ABI area, it could change at any
moment, You must not ship tools to end users that process these stats if
they come out through debugfs - it is not a way to bypass the kernel
API rules. It is just something for developers to use.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
