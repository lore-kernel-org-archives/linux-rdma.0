From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 03/12] IB/hfi1: Fix an Oops on pci device force remove
Date: Tue, 25 Oct 2016 12:03:45 -0600
Message-ID: <20161025180345.GA16794@obsidianresearch.com>
References: <20161017160731.GA5679@obsidianresearch.com>
 <20161025155754.4950.23412.stgit@scvm10.sc.intel.com>
 <20161025164851.GA28096@obsidianresearch.com>
 <7f4cbe0c-0c83-48b2-9901-4a5e27b306b4@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7f4cbe0c-0c83-48b2-9901-4a5e27b306b4-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2016 at 10:38:55AM -0700, Tadeusz Struk wrote:
> On 10/25/2016 09:48 AM, Jason Gunthorpe wrote:
> > nit: This isn't similar to uverbs or other IB core interfaces - they
> > all allow unbind while the FD remains open, this forces the FD to
> > become closed - which means hot plug will not be supported by hfi1.
> > 
> 
> That's correct, the reason, as I said before, is that PIO processes
> don't go via FD, but talk directly to MMIO PCI regions.

Most of the IB drivers do this - Mellanox implemented a forced
remapping of the user space VMA on unplug to deal with it, you can use
that technique in HFI1 too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
