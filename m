From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Tue, 24 May 2016 11:14:35 -0600
Message-ID: <20160524171435.GB8037@obsidianresearch.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
 <20160519122622.22041.41686.stgit@scvm10.sc.intel.com>
 <20160521123404.GB25500@leon.nu>
 <20160521162301.GA16770@phlsvsds.ph.intel.com>
 <20160522120129.GC25500@leon.nu>
 <20160522140351.GA10696@phlsvsds.ph.intel.com>
 <20160522175715.GD25500@leon.nu>
 <20160523122207.GA16764@phlsvsds.ph.intel.com>
 <20160523130312.GG25500@leon.nu>
 <20160523141049.GE16764@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160523141049.GE16764-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 23, 2016 at 10:10:50AM -0400, Dennis Dalessandro wrote:

> ioctl over specific ioctls in the general sense. I know that's what folks
> seem to prefer from the calls, but perhaps we can get that down in writing
> here on the list.

The ioctl space is quite limited, based on # alone there is something
like 256 of them available within 0x1b. This is not enough for all the
calls that uverbs needs, so they must be multiplexed. Once we start
multiplexing we may as well multiplex everything.

It is desired in the kernel, in general, that ioctls are globally
unique. If hfi1 uses an ioctl number it becomes unavailable to other
parts of the kernel, including verbs. You also need to check you are
not re-using any of these ioctl numbers between other ib things like
umad/etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
