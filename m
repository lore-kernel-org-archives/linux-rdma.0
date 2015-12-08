From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 05/10] IB/qib: Use rdmavt lid defines in qib
Date: Tue, 8 Dec 2015 16:54:40 -0700
Message-ID: <20151208235440.GB28017@obsidianresearch.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com>
 <20151207204911.11219.50129.stgit@phlsvslse11.ph.intel.com>
 <20151207205439.GA29576@obsidianresearch.com>
 <20151208192455.GB16976@phlsvsds.ph.intel.com>
 <20151208205511.GA14378@obsidianresearch.com>
 <20151208231941.GD14221@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208231941.GD14221-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ira. weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 06:19:41PM -0500, Dennis Dalessandro wrote:

> So what is the consensus here? Should we leave it alone for now and
> potentially go back and deal with this separately?  Just define the new one
> as LE and use it, even though it doesn't match the rest?  Something else
> entirely?

I'm okay if you stick with what you have, there are too many other
cases of byteswapped constants to get too excited I guess. :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
