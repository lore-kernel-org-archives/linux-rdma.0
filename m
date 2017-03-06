From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Mon, 6 Mar 2017 11:07:23 -0700
Message-ID: <20170306180723.GD11805@obsidianresearch.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488809204-30428-5-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 06, 2017 at 04:06:43PM +0200, Yishai Hadas wrote:
> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch drops the need to extend the verbs layer each time with
> some non generic fields when creating a CQ. It adds an option to set
> some opaque vendor data in some generic way which can fit any vendor.
> 
> The solution introduced for creating a CQ but expects to fit for
> other IB objects as of QP, SRQ, etc.
> 
> It comes as a pre-patch for supplying some private mlx5 fields in
> downstream patches.
> 
> The solution:
> 1) Introduce a new comp_mask bit (i.e. IBV_CQ_INIT_ATTR_MASK_VENDOR_DATA)
>    and a matching void* vendor data field.
> 
> 2) Vendor should expose its header file for direct access with
>    relevant private structures.
> 
> 3) Application should supply the input based on vendor-defined structure.
> 
> 4) Upon getting the private data the vendor will cast to its internal
>    structure and use the data as part of CQ creation.

I'm not sure I like this, why not create a mlx5dv_create_cq?

struct ibv_cq_ex *mlx5dv_create_cq_ex(struct mlx5dv_context *context,
                                   struct ibv_cq_init_attr_ex *cq_attr,
				   struct mlx5_.... *vendor_data)

Seems much more type safe to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
