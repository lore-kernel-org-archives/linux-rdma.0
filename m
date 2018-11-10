From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] infiniband/hw/hns/hns_roce_hw_v2.c: Use dma_zalloc_coherent
Date: Sat, 10 Nov 2018 11:57:24 +0530
Message-ID: <CAFqt6zY5PUB-=1PeNKHiWmgbrR=3EfqcYsWOVH5TLeJnQf0JBg@mail.gmail.com>
References: <5be59bf8.1c69fb81.a231.dcd6@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5be59bf8.1c69fb81.a231.dcd6@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: oulijun@huawei.com, xavier.huwei@huawei.com, Doug Ledford <dledford@redhat.com>, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 9, 2018 at 8:08 PM Sabyasachi Gupta
<sabyasachi.linux@gmail.com> wrote:
>
> Replaced dma_alloc_coherent + memset with dma_zalloc_coherent

There are few other places in this file where same is applicable.
Can we get those changes in same patch ?
>
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index a4c62ae..c9966ec 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -4972,13 +4972,12 @@ static int hns_roce_mhop_alloc_eq(struct hns_roce_dev *hr_dev,
>                                 eqe_alloc = i * (buf_chk_sz / eq->eqe_size);
>                                 size = (eq->entries - eqe_alloc) * eq->eqe_size;
>                         }
> -                       eq->buf[i] = dma_alloc_coherent(dev, size,
> +                       eq->buf[i] = dma_zalloc_coherent(dev, size,
>                                                         &(eq->buf_dma[i]),
>                                                         GFP_KERNEL);
>                         if (!eq->buf[i])
>                                 goto err_dma_alloc_buf;
>
> -                       memset(eq->buf[i], 0, size);
>                         *(eq->bt_l0 + i) = eq->buf_dma[i];
>
>                         eq_buf_cnt++;
> --
> 2.7.4
>
