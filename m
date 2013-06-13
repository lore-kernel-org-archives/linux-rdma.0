From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 4/4] IB/core: Add RoCE IP based addressing
 extensions towards user space
Date: Thu, 13 Jun 2013 11:09:39 -0600
Message-ID: <20130613170939.GB21570@obsidianresearch.com>
References: <1371135704-5712-1-git-send-email-ogerlitz@mellanox.com>
 <1371135704-5712-5-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371135704-5712-5-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 13, 2013 at 06:01:44PM +0300, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add support for RoCE (IBoE) IP based addressing extensions towards
> user space.
> 
> Extend INIT_QP_ATTR and QUERY_ROUTE ucma commands.
> 
> Extend MODIFY_QP and CREATE_AH uverbs commands.

This is a really big patch Or, there is lots going on here, hard to
review :(

The rdma cm stuff should probably be split out of this, and Sean
should look at it of course.

In fact, since the user ABI is so important, every ABI change should
be a distinct patch, with a good change log, stating the intended
goals of the change and ABI visible changes it makes.

The changelog above is terrible for a huge patch that makes changes to
the userspace API.

> diff --git a/include/uapi/rdma/ib_user_sa.h b/include/uapi/rdma/ib_user_sa.h
> index cfc7c9b..367d66a 100644
> +++ b/include/uapi/rdma/ib_user_sa.h
> @@ -48,7 +48,13 @@ enum {
>  struct ib_path_rec_data {
>  	__u32	flags;
>  	__u32	reserved;
> -	__u32	path_rec[16];
> +	__u32	path_rec[20];
> +};
> +
> +enum ibv_kern_path_rec_attr_mask {
> +	IB_USER_PATH_REC_ATTR_DMAC = 1ULL << 0,
> +	IB_USER_PATH_REC_ATTR_SMAC = 1ULL << 1,
> +	IB_USER_PATH_REC_ATTR_VID  = 1ULL << 2
>  };

So, how is userspace supposed to know what these values are? The
current system where the MAC address is in the GID seemed
understandable, assuming you discover the MAC out of band some how...

> +struct ib_uverbs_modify_qp_ex {
> +	__u32 comp_mask;
> +	struct ib_uverbs_qp_dest dest;
> +	struct ib_uverbs_qp_dest alt_dest;
[...]
> +	struct ib_uverbs_qp_dest_ex dest_ex;
> +	struct ib_uverbs_qp_dest_ex alt_dest_ex;

Yuk.. The 'ex' structures don't have to be byte compatible, they just
have to have a known transform, dest should be the full extended dest,
not split into two..

> +struct rdma_ucm_query_route_resp_ex {
> +	__u64 node_guid;
> +	struct ib_user_path_rec_ex ib_route[2];
> +	struct sockaddr_in6 src_addr;
> +	struct sockaddr_in6 dst_addr;
> +	__u32 num_paths;
> +	__u8 port_num;
> +	__u8 reserved[3];
> +};

Should these be sockaddr_storage? How does this intersect with Sean's
AF_GID work?

JAson
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
