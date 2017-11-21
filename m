From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Allow creation of a Multi-Packet RQ
 using direct verbs
Date: Tue, 21 Nov 2017 08:53:04 -0700
Message-ID: <20171121155304.GA18272@ziepe.ca>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
 <1511119268-5934-3-git-send-email-yishaih@mellanox.com>
 <20171120190434.GG29075@ziepe.ca>
 <f164e1c4-e3b2-8778-448e-1fb0da6e6dc1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f164e1c4-e3b2-8778-448e-1fb0da6e6dc1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 02:01:33PM +0200, Yishai Hadas wrote:
> On 11/20/2017 9:04 PM, Jason Gunthorpe wrote:
> >On Sun, Nov 19, 2017 at 09:21:08PM +0200, Yishai Hadas wrote:
> >>+	if (mlx5wq_attr) {
> >>+		if (mlx5wq_attr->comp_mask & ~(MLX5DV_WQ_INIT_ATTR_MASK_RESERVED - 1))
> >>+			return -EINVAL;
> >
> >Please no. Check that only the bits this function actually supports
> >are set and get rid of _RESERVED.
> >
> 
> OK, PR was updated accordingly:
> https://github.com/linux-rdma/rdma-core/pull/257

This new version is mixing bit widths:

+enum mlx5dv_wq_init_attr_mask {
+	MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ	= 1 << 0,
+};

+enum {
+	DV_CREATE_WQ_SUPPORTED_COMP_MASK = MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ
+};

+struct mlx5dv_wq_init_attr {
+	uint64_t				comp_mask;
[..]

So this expression:

+	if (mlx5wq_attr->comp_mask & ~DV_CREATE_WQ_SUPPORTED_COMP_MASK)


Will bitwise invert a 32 bit value then 0 extend it to 64 bits, which
is not the intention.

As I suggested earlier, I recommend helper functions for this in
driver.h:

static inline bool check_comp_mask(uint64_t input, uint64_t supported)
{
     return (input & ~supported) == 0;
}


if (!check_comp_mask(mlx5wq_attr->comp_mask,
     MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ))
       return -EINVAL;
       
I also dislike the unnecessary extra enum..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
