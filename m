From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 2/5] RDMA/hns: Modify uar allocation algorithm
 to avoid bitmap exhaust
Date: Wed, 23 May 2018 09:05:15 +0300
Message-ID: <20180523060515.GD2933@mtr-leonro.mtl.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-3-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526544173-106587-3-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2018 at 04:02:50PM +0800, Wei Hu (Xavier) wrote:
> This patch modified uar allocation algorithm in hns_roce_uar_alloc
> function to avoid bitmap exhaust.
>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
>  drivers/infiniband/hw/hns/hns_roce_pd.c     | 10 ++++++----
>  2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index 53c2f1b..412297d4 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -214,6 +214,7 @@ enum {
>  struct hns_roce_uar {
>  	u64		pfn;
>  	unsigned long	index;
> +	unsigned long	logic_idx;
>  };
>
>  struct hns_roce_ucontext {
> diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
> index 4b41e04..b9f2c87 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_pd.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
> @@ -107,13 +107,15 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
>  	int ret = 0;
>
>  	/* Using bitmap to manager UAR index */
> -	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->index);
> +	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->logic_idx);
>  	if (ret == -1)
>  		return -ENOMEM;
>
> -	if (uar->index > 0)
> -		uar->index = (uar->index - 1) %
> +	if (uar->logic_idx > 0 && hr_dev->caps.phy_num_uars > 1)
> +		uar->index = (uar->logic_idx - 1) %
>  			     (hr_dev->caps.phy_num_uars - 1) + 1;
> +	else
> +		uar->index = 0;
>

Sorry, but maybe I didn't understand this change fully, but logic_idx is
not initialized at all and one of two (needs to check your uar
allocation): the logic_idx is always zero -> index will be zero too,
or logic_idx is random variable -> index will be random too.

What did you want to do?


>  	if (!dev_is_pci(hr_dev->dev)) {
>  		res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
> @@ -132,7 +134,7 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
>
>  void hns_roce_uar_free(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
>  {
> -	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->index,
> +	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->logic_idx,
>  			     BITMAP_NO_RR);
>  }
>
> --
> 1.9.1
>

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbBQSaAAoJEORje4g2clinQIAQAMm/t78Hspnvvh0m8Fme9RSo
IAbCHOqgiXnEnA/ptRcoPT8jpIjSrFNt7ZWXA3g9As5j9x8SPxyIOrO6lYUDr7zc
+5zrdgEMR7+j3371cR2C02S5n4O9uZ9ataLdV79M4e62infM+VXD2mvO9jjksxTC
Pb1SEII520jdJ1d6fYinBOAE83Ysxqwim6n9xdI+76QPGrDMZwWAHPO4L7iMHfZJ
wTnq/mh2rQYqghLNADJJRfSpKn5hh5tca8LdUe7o893feHr2AQr55w9dFvEF2YhZ
RxaSPgk1hGCWaBCdaUY+Jck0DoBbkVo/AToiwGzIiYvBNHQB2rCuCJD/xRsuDb1r
THqZfyELMd1QnXGbvn+Wmg6ookZrPCfiT+O8KqCJ7x52kBoXLa7lmhzbEkYBedQP
etc8exjWZWQfvl9qdZbrEPyKwj1wYi7XIXJZXkLRLEqT26tGOOHuprHEduiIr4iw
WgkIp/JT77cLHEFg2++2TFfms0Nc8nkB+x5sAhE1AonCODn856fm486PaN3OZtPl
TO0H4ayepqiG6XZPdzjc8YIe9XJvcVJRIwNhMeHuLsCGeREQafKuDo++KWNUIxWU
yPQCAdRs2V3/3McJHd9H6xEPcgd2aJs4eJWDBWPuN9pWPHlkpijRdwewa/yy8ogO
KSi+l0Q1FNWfoNGteT9g
=XUXO
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
