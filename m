From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4: Add support for promiscuous mode in the new steering model.
Date: Wed, 4 May 2016 14:26:02 +0300
Message-ID: <CAJ3xEMivBfjyqZgqLjTdvY6hfoYu5=-rBiWUcn4RnCNO_V9c0g@mail.gmail.com>
References: <20160503123953.GA4653@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503123953.GA4653@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 3, 2016 at 3:39 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Yevgeny Petrilin,
>
> The patch b12d93d63c32: "mlx4: Add support for promiscuous mode in
> the new steering model." from Mar 22, 2011, leads to the following
> static checker warning:
>
>         drivers/net/ethernet/mellanox/mlx4/mcg.c:1191 mlx4_qp_attach_common()
>         error: uninitialized symbol 'index'.
>
> drivers/net/ethernet/mellanox/mlx4/mcg.c
>   1097  int mlx4_qp_attach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
>   1098                            int block_mcast_loopback, enum mlx4_protocol prot,
>                                                                                ^^^^
> prot comes from the caller.


[...]

Hi Dan,

Tariq from our driver group (copied) will be looking on that

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
