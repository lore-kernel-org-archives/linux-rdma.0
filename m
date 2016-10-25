From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 03/12] IB/hfi1: Fix an Oops on pci device force remove
Date: Tue, 25 Oct 2016 10:48:51 -0600
Message-ID: <20161025164851.GA28096@obsidianresearch.com>
References: <20161017160731.GA5679@obsidianresearch.com>
 <20161025155754.4950.23412.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161025155754.4950.23412.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2016 at 08:57:55AM -0700, Dennis Dalessandro wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch fixes an Oops on device unbind, when the device is used
> by a PSM user process. PSM processes access device resources which
> are freed on device removal. Similar protection exists in uverbs
> in ib_core for Verbs clients, but PSM doesn't use ib_uverbs hence
> a separate protection is required for PSM clients.

nit: This isn't similar to uverbs or other IB core interfaces - they
all allow unbind while the FD remains open, this forces the FD to
become closed - which means hot plug will not be supported by hfi1.

Otherwise this seems resonable.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
