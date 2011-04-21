From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Thu, 21 Apr 2011 11:35:57 -0700
Message-ID: <BANLkTikUOv3mtgb3x_vbbk845_36fu1QhA@mail.gmail.com>
References: <1303404264.2243.19.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303404264.2243.19.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 21, 2011 at 9:44 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> I have a problem with rdma_create_qp() when I set
> qp_init_attr.cap.max_send_wr to something higher than 16351:
> it returns -1 and errno is set to ENOMEM "Cannot allocate memory".
>
> strace doesn't show anything related to memory, but the last write()
> syscall returns EINVAL "Invalid Argument".
>
> I'm using a Mellanox ConnectX MT26428 (v2.6.100 / a0) HCA, under Debian
> 6.0 (kernel 2.6.32-5, librdmacm 1.0.10-1, libibverbs 1.1.3-2, libmlx4
> 1.0-1).
>
> According to ibv_query_device() informations,
> ibv_device_attr.max_qp_wr is 16384 (and ibv_device_attr.max_qp_wr is
> 16383). So one might think that 16383 outstanding WR should be OK.

Getting exactly the right value for max_qp_wr is kind of tricky because
of complicated allocation rules.  I guess this is just a mlx4 bug in
reporting not quite the right value from ibv_query_device().
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
