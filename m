From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Allow creation of a Multi-Packet RQ
 using direct verbs
Date: Tue, 21 Nov 2017 10:20:19 -0700
Message-ID: <20171121172019.GE18272@ziepe.ca>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
 <1511119268-5934-3-git-send-email-yishaih@mellanox.com>
 <20171120190434.GG29075@ziepe.ca>
 <f164e1c4-e3b2-8778-448e-1fb0da6e6dc1@dev.mellanox.co.il>
 <20171121155304.GA18272@ziepe.ca>
 <63dd046b-ac6d-3ff2-0dc5-82d29bac9393@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <63dd046b-ac6d-3ff2-0dc5-82d29bac9393-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 07:17:00PM +0200, Yishai Hadas wrote:

> >Will bitwise invert a 32 bit value then 0 extend it to 64 bits, which
> >is not the intention.
> 
> Are you are referring to a case that the user will turn on a bit in the
> comp_mask over the 32 bits and won't get an error ? Look at
> MLX5DV_CQ_INIT_ATTR_MASK_RESERVED usage it has the same potential issue.

Yes, I'm not surprised, this is possibly systemically broken. We
should add the helper and deploy it everywhere we are doing this style
of check.

> >if (!check_comp_mask(mlx5wq_attr->comp_mask,
> >      MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ))
> >        return -EINVAL;
> >I also dislike the unnecessary extra enum..
> 
> I prefer staying with the above enum (i.e. DV_CREATE_WQ_SUPPORTED_COMP_MASK)
> to hold the supported bits as done in mlx5 for QP & CQ. (see
> MLX5_CREATE_QP_SUP_COMP_MASK). In that way the code around check_comp_mask()
> won't be changed when extra bits will be added.

Well, it is up to you, but I dislike this because it sprinkles the
logic around too much. Seeing clearly a line 'check_comp_mask' at the
top of the function that lists all the supported bits makes it very
easy to understand and review.

If there was more than one user of DV_CREATE_WQ_SUPPORTED_COMP_MASK I
could understand having it, but since there isn't, it is just ugly
noise.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
