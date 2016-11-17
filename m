From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core release process questions
Date: Wed, 16 Nov 2016 22:14:44 -0700
Message-ID: <20161117051444.GA17784@obsidianresearch.com>
References: <13AA599688F47243B14FCFCCC2C803BB10AB79D5@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB10AB79D5-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 17, 2016 at 04:56:45AM +0000, Nikolova, Tatyana E wrote:

> We are submitting patches to the kernel space driver i40iw and to
> the user space plugin libi40iw, which is currently part of
> rdma-core. Some of the changes need to be coordinated so that they
> appear in both kernel space and user space in corresponding
> releases. We have some questions regarding the process about
> submitting patches to rdma-core which have dependencies on kernel
> patches.

Incompatible changes are very strongly discouraged, just don't do it.

> 4) Is each rdma-core release going to correspond to a specific kernel version?

No. All versions must work with all kernels.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
