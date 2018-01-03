From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Wed, 3 Jan 2018 14:35:25 +0200
Message-ID: <CAJ3xEMjL4XoUT95ThqzAnyobStSNL9_y7GamGHjE-fePzn6k=w@mail.gmail.com>
References: <20180102141933.24353-1-leon@kernel.org> <20180102141933.24353-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102141933.24353-5-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 2, 2018 at 4:19 PM, Leon Romanovsky wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The QP type IB_QPT_DRIVER doesn't describe the transport or the service
> that the QP provides but those are known only to the hardware driver.
> The actual type of the QP is stored in the hardware driver context (i.e.
> mlx5_qp) under the field qp_sub_type.
>
> Take the real QP type and any extra data that is required to create the QP
> from the driver channel and modify the QP initial attributes before continuing
> with create_qp().
>
> Downstream patches from this series will add support for both DCI and
> DCT driver QPs.

LGTM, you addressed the review comments and now we're in very good shape
w.r.t the whole series.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
