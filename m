From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Tue, 19 Jul 2016 20:25:49 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com> <1468941812-32286-6-git-send-email-matanb@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468941812-32286-6-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Jul 2016, Matan Barak wrote:

> diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
> index 5c1117a..f6927fc 100644
> --- a/include/uapi/rdma/rdma_user_ioctl.h
> +++ b/include/uapi/rdma/rdma_user_ioctl.h
> @@ -42,6 +42,29 @@
>   */
>  #define IB_IOCTL_MAGIC			RDMA_IOCTL_MAGIC
>
> +#define RDMA_VERBS_IOCTL \
> +	_IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
> +
> +#define RDMA_DIRECT_IOCTL \
> +	_IOWR(RDMA_IOCTL_MAGIC, 2, struct ib_uverbs_ioctl_hdr)
> +
> +struct ib_uverbs_attr {
> +	__u16 attr_id;		/* command specific type attribute */
> +	__u16 len;		/* NA for idr */
> +	__u32 reserved;
> +	 __u64 ptr_idr;		/* ptr typeo command/idr handle */
> +};
> +
> +struct ib_uverbs_ioctl_hdr {
> +	__u16 length;
> +	__u16 flags;
> +	__u16 object_type;
> +	__u16 driver_id;

driver id??? I would have expected that the driver to be used is
already selected through the file handle as passed to the ioctl.

Having the ability to issue ioctls to multiple drivers via a
single file handle is unusual and will likely trigger security concerns.
In particular various access mechanisms rely on policing access through
file handles.

I guess we have a good reason for doing so? If so then please document
that somewhere. Or did I not see that?


+	 __u16 action; > +	__u16 num_attrs;
> +	struct ib_uverbs_attr  attrs[0];
> +};
> +
>  /* Legacy part
>   * !!!! NOTE: It uses the same command index as VERBS
>   */
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
