From: Tarick Bedeir <tarick@google.com>
Subject: Re: [PATCH] IB/mlx4: Test port number before querying type.
Date: Tue, 3 Jul 2018 07:44:25 -0700
Message-ID: <CABwnudxZbGumr+XNjOsz5+_iZkZ9mn0zhk+UOmxDNynAQJfWtQ@mail.gmail.com>
References: <20180702210234.107361-1-tarick@google.com> <20180703062111.GC3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703062111.GC3014@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: leon@kernel.org
Cc: Yishai Hadas <yishaih@mellanox.com>, dledford@redhat.com, jgg@ziepe.ca, Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 2, 2018 at 11:21 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Jul 02, 2018 at 02:02:34PM -0700, Tarick Bedeir wrote:
> > rdma_ah_find_type() can reach into ib_device->port_immutable with a
> > potentially out-of-bounds port number, so check that the port number is
> > valid first.
> >
> > Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
> > Signed-off-by: Tarick Bedeir <tarick@google.com>
> > ---
> >  drivers/infiniband/hw/mlx4/qp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> > index f045491f2c14..4f1dabecf9a5 100644
> > --- a/drivers/infiniband/hw/mlx4/qp.c
> > +++ b/drivers/infiniband/hw/mlx4/qp.c
> > @@ -4034,9 +4034,9 @@ static void to_rdma_ah_attr(struct mlx4_ib_dev *ibdev,
> >       u8 port_num = path->sched_queue & 0x40 ? 2 : 1;
> >
> >       memset(ah_attr, 0, sizeof(*ah_attr));
> > -     ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, port_num);
> >       if (port_num == 0 || port_num > dev->caps.num_ports)
>
> Did you get any warning from any checker about out-of-bounds access?

Indeed, I observed a KASAN warning for an out-of-bounds read in
to_rdma_ah_attr().

> According to the line above, port_num can be 2 or 1 which are valid ports for mlx4
> and the check above doesn't do much.

There are mlx4 devices with only one port.

>
> >               return;
> > +     ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, port_num);
> >
> >       if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE)
> >               rdma_ah_set_sl(ah_attr, ((path->sched_queue >> 3) & 0x7) |
> > --
> > 2.18.0.399.gad0ab374a1-goog
> >
