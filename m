From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 26/37] IB/rdmavt: Move memory registration into rdmavt
Date: Thu, 10 Dec 2015 07:25:44 -0800
Message-ID: <20151210152544.GA32222@infradead.org>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204451.8144.52356.stgit@phlsvslse11.ph.intel.com>
 <56698B2C.2010806@dev.mellanox.co.il>
 <20151210151455.GD11526@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151210151455.GD11526-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 10:14:56AM -0500, Dennis Dalessandro wrote:
> Why? Because, it exists in qib and hfi1.
> 
> However, it seems no one is actually using this in the kernel these days and
> the core support was removed in commit 1241d7bf. Yet the function pointer
> still exists in struct ib_device. Are there plans to remove this?

Yes, I've send a patch that remove it, and which only got positive
review so far.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
