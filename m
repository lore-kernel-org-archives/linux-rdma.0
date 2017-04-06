From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Qemu-devel] [PATCH RFC] hw/pvrdma: Proposal of a new pvrdma
 device
Date: Thu, 6 Apr 2017 14:54:16 -0600
Message-ID: <20170406205416.GB27155@obsidianresearch.com>
References: <1490872341-9959-1-git-send-email-marcel@redhat.com>
 <20170330141314.GM20443@mtr-leonro.local>
 <5e952524-7c2d-b4da-4bd7-6437830a40d8@redhat.com>
 <f7f3fc0e-0a75-2fdc-b3c2-6c3d34ff2978@redhat.com>
 <20170403062314.GO20443@mtr-leonro.local>
 <aa400244-426a-ea62-0ccf-ac5adb76fdd1@redhat.com>
 <20170404173349.GY20443@mtr-leonro.local>
 <20170406194552.GB2170@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170406194552.GB2170@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 06, 2017 at 10:45:54PM +0300, Yuval Shaia wrote:

> > Just add my 2 cents. You didn't answer on my question about other possible
> > implementations. It can be SoftRoCE loopback optimizations, special ULP,
> > RDMA transport, virtual driver with multiple VFs and single PF.
> 
> Please see my response to Jason's comments - eventually, when a support for
> VM to external host communication will be added - kdbr will become ULP as
> well.

So, is KDBR only to be used on the HV side? Ie it never shows up in the VM?

That is even weirder, we certainly do not want to see a kernel RDMA
ULP for any of this - the entire point of RDMA is to let user space
implement their protocols without needing a unique kernel component!!

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
