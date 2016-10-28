From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC ABI V5 07/10] IB/core: Support getting IOCTL header/SGEs
 from kernel space
Date: Thu, 27 Oct 2016 23:59:43 -0700
Message-ID: <20161028065943.GA10418@infradead.org>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-8-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477579398-6875-8-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +	mm_segment_t currentfs = get_fs();
>  
>  	if (!ib_dev)
>  		return -EIO;
> @@ -240,8 +242,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>  		goto out;
>  	}
>  
> +	set_fs(oldfs);
>  	err = uverbs_handle_action(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
>  				   file, action, ctx->uverbs_attr_array);
> +	set_fs(currentfs);

Adding this magic in new code is not acceptable.  Any given API
must take either a kernel or a user pointer.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
