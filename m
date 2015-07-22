From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Wed, 22 Jul 2015 12:02:03 -0600
Message-ID: <20150722180203.GI26909@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437548143-24893-29-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 09:55:28AM +0300, Sagi Grimberg wrote:
> +/**
> + * ib_map_mr_sg() - Populates MR with a dma mapped SG list
> + * @mr:            memory region
> + * @sg:            dma mapped scatterlist
> + * @sg_nents:      number of entries in sg
> + * @access:        access permissions

Again, related to my prior comments, please have two of these:

ib_map_mr_sg_rkey()
ib_map_mr_sg_lkey()

So we force ULPs to think about what they are doing properly, and we
get a chance to actually force lkey to be local use only for IB.

> +static inline void
> +ib_set_fastreg_wr(struct ib_mr *mr,
> +		  u32 key,

The key should come from MR. Once the above is split then it is
obvious which key to use.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
