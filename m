From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Tue, 22 Dec 2015 14:13:27 +0100
Message-ID: <20151222131326.GA25267@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de> <1448214409-7729-11-git-send-email-hch@lst.de> <56791542.6020604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56791542.6020604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 22, 2015 at 11:17:54AM +0200, Sagi Grimberg wrote:
> What makes me worried here is that the IB/RoCE specification really
> defines different keys for local and remote access. I'm less concerned
> about our consumers but more about our providers. We keep seeing new
> providers come along and its not impossible that a specific HW will
> *rely* on this distinction. In such a case we'd need to revert this
> patch altogether in that very moment.
>
> I think we're better off working on proper abstractions to help ULPs
> get it right (and simple!), without risking future devices support.

With the new API in the next patch ULPs simply can't request an lkey
and a rkey at the same time, so for kernel use it's not a problmblem at
all.  That leaves my favourite nightmare: uverbs, which of course
allows for everything under the sun, just because we can.  I guess
the right answer to that problem is to first split the data structures
for kernel and user MRs, which we probably should have done much
earlier.  Not just because of this but also because of other issues
like all the fields your FR API changs added to ib_mr that aren't needed
for user MRs, or becaue the user MR structure should reallbe be merged with
struct ib_umem.

>
> Sagi.
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
