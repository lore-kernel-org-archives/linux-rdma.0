From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 6/7] mlx5: Add direct verbs man pages
Date: Mon, 13 Feb 2017 09:54:45 -0700
Message-ID: <20170213165445.GC25430@obsidianresearch.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-7-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486909012-15064-7-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 12, 2017 at 04:16:51PM +0200, Yishai Hadas wrote:

> +.\" -*- nroff -*-
> +.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md

Please use the MIT variant for all new files

> +.fi
> +.SH "RETURN VALUE"
> +0 on success.

'or the value of errno on failure (which indicates the failure reason)'

and in other places.

> +.BI "int mlx5dv_query_device(struct ibv_context *ctx_in,
> +.BI "                        struct mlx5dv_context *attrs_out);

This isn't going to work with comp_mask, at a minimum you need to add
a size_t attrs_len argument.

I recommend against adding new complex queries like this - they don't
work well from an ABI perspective and not being performance critical
do not require this comp_max madness

Eg just use:

int mlx5dv_query_cq_format(struct ibv_context *ctx_in)

We still need man pages for all the inline functions :|

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
