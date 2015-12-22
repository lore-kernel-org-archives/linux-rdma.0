From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Tue, 22 Dec 2015 14:09:39 -0700
Message-ID: <20151222210939.GA8212@obsidianresearch.com>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
 <1448214409-7729-11-git-send-email-hch@lst.de>
 <56791542.6020604@dev.mellanox.co.il>
 <20151222131326.GA25267@lst.de>
 <56795514.9090704@dev.mellanox.co.il>
 <20151222135927.GA26311@lst.de>
 <56798126.9000003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56798126.9000003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 22, 2015 at 06:58:14PM +0200, Sagi Grimberg wrote:
> 
> >The ULP decides if this MR is going to be used as a lkey or rkey
> >by passing IB_REG_LKEY or IB_REG_RKEY.  The HCA driver will then
> >fill mr->key by the lkey or rkey based on that and everything will
> >work fine.
> 
> But the ULP *can* register a memory buffer with local and remote
> access permissions.

Not in the new API.

If a ULP ever comes along that does need that then they can start with
two MRs and then eventually upgrade the kapi to have some kind of
efficient bidir MR mode.

What we've seen on the list lately is that every single ULP seems to
have technical problems running the stack properly. We need to get off
this idea that the spec has to govern the kapi - that didn't lead us
any place nice.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
