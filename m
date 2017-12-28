From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Thu, 28 Dec 2017 08:12:13 +0200
Message-ID: <CAJ3xEMi4oBLF-9bTySuk23k+FhMALY+LZ6qjJte4aueZ+inatA@mail.gmail.com>
References: <20171227171540.1646-1-leon@kernel.org> <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com> <20171227220227.GL31310@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227220227.GL31310-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 28, 2017 at 12:02 AM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Wed, Dec 27, 2017 at 11:16:09PM +0200, Or Gerlitz wrote:

>> you added these two flags in the ABI file, but you never use them in downstream
>> MLX5_QP_FLAG_TYPE_DCT
>> MLX5_QP_FLAG_TYPE_DCI
>> patches, something must be wrong here even according to your design

> Hm? they are used here:
>
> +       if (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI)
> +               init_attr->qp_type = MLX5_IB_QPT_DCI;
> +       else
> +               init_attr->qp_type = MLX5_IB_QPT_DCT;
>
> Which is a bad ABI design, check flags explicitly never use else.

Maybe, but when I said that in downstream it is assumed
user-space knows that for mlx5 DCI/DCT equals
IB_QPT_RESERVED3/4 I was wrong, it is derived from the flags.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
