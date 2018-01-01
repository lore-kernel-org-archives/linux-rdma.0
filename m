From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Mon, 1 Jan 2018 12:39:51 +0200
Message-ID: <CAJ3xEMiOAC6si4MXdJQNwA+gKNcL5Lc1WtaYV3EYk2cTOR81cw@mail.gmail.com>
References: <20171227171540.1646-1-leon@kernel.org> <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com>
 <20171227220227.GL31310@mellanox.com> <30a35dd5-3046-d7bb-e61f-7d18501fd06c@dev.mellanox.co.il>
 <CAJ3xEMhPZfyTZ1Hr8Mwq9xeqV6UKkkVfXNDrx625qoWzAHr6qg@mail.gmail.com>
 <1e827f07-f8a1-ffa3-7c8b-e90b1107e843@dev.mellanox.co.il> <20171231195015.GA10159@mellanox.com>
 <CAG9sBKPjhqXTKzvCGp=LXtHEAUXgQa8L4w=OaPKizJsnDQCuuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPjhqXTKzvCGp=LXtHEAUXgQa8L4w=OaPKizJsnDQCuuA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 1, 2018 at 12:14 PM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> static int set_mlx_qp_type(struct mlx5_ib_dev *dev,
>>                            struct ib_qp_init_attr *init_attr,
>>                            struct mlx5_ib_create_qp *ucmd,
>>                            struct ib_udata *udata)
>> {
>>         enum { MLX_QP_FLAGS = MLX5_QP_FLAG_TYPE_DCT | MLX5_QP_FLAG_TYPE_DCI };
>>         int err;
>>
>>         if (!udata)
>>                 return -EINVAL;
>>
>>         if (udata->inlen < sizeof(*ucmd)) {
>>                 mlx5_ib_dbg(dev, "create_qp user command is smaller than expected\n");
>>                 return -EINVAL;
>>         }
>>         err = ib_copy_from_udata(ucmd, udata, sizeof(*ucmd));
>>         if (err)
>>                 return err;
>>
>>         if ((ucmd->flags & MLX_QP_FLAGS) == MLX5_QP_FLAG_TYPE_DCI)
>>                 init_attr->qp_type = MLX5_IB_QPT_DCI;
>>         else if ((ucmd->flags & MLX_QP_FLAGS) == MLX5_QP_FLAG_TYPE_DCT)
>>                 init_attr->qp_type = MLX5_IB_QPT_DCT;
>>         else {
>>                 mlx5_ib_dbg(dev, "Invalid QP flags\n");
>>                 return -EINVAL;
>>         }
>>
>>         if (!MLX5_CAP_GEN(dev->mdev, dct)) {
>>                 mlx5_ib_dbg(dev, "DC transport is not supported\n");
>>                 return -EOPNOTSUPP;
>>         }
>>
>>         return 0;
>> }
> I like this :) Will take it in.

LGTM (the new suit and that we are wearing it)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
