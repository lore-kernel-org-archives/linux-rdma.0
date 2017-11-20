From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Allow creation of a Multi-Packet RQ
 using direct verbs
Date: Mon, 20 Nov 2017 12:04:34 -0700
Message-ID: <20171120190434.GG29075@ziepe.ca>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
 <1511119268-5934-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511119268-5934-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 19, 2017 at 09:21:08PM +0200, Yishai Hadas wrote:
> +	if (mlx5wq_attr) {
> +		if (mlx5wq_attr->comp_mask & ~(MLX5DV_WQ_INIT_ATTR_MASK_RESERVED - 1))
> +			return -EINVAL;

Please no. Check that only the bits this function actually supports
are set and get rid of _RESERVED.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
