From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Wed, 22 Jul 2015 09:50:12 -0700
Message-ID: <20150722165012.GC6443@infradead.org>
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

> +/**
> + * ib_map_mr_sg() - Populates MR with a dma mapped SG list
> + * @mr:            memory region
> + * @sg:            dma mapped scatterlist
> + * @sg_nents:      number of entries in sg
> + * @access:        access permissions

I know moving the access flags here was my idea originally, but I seem
convinced by your argument that it might fit in better with the posting
helper.  Or did someone else come up with a better argument that mine
for moving it here?

> +int ib_map_mr_sg(struct ib_mr *mr,
> +		 struct scatterlist *sg,
> +		 unsigned short sg_nents,
> +		 unsigned int access)
> +{
> +	int rc;
> +
> +	if (!mr->device->map_mr_sg)
> +		return -ENOSYS;
> +
> +	rc = mr->device->map_mr_sg(mr, sg, sg_nents);

Do we really need a driver callout here?  It seems like we should
just do the map here, and then either have a flag for the mlx5 indirect
mapping, or if you want to keep the abstraction add the method at that
point but make it optional, so that all the other drivers don't need the
boilerplate code.

Also it seems like this returns 0/-error.  How do callers like SRP
see that it only did a partial mapping and it needs another MR?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
