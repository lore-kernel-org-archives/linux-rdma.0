From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/hns: Refactor eq code for hip06
Date: Tue, 14 Nov 2017 11:11:46 +0200
Message-ID: <20171114091146.GT18825@mtr-leonro.local>
References: <1510651577-20794-1-git-send-email-liuyixian@huawei.com>
 <1510651577-20794-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="In+4dZ/2sY1gGzQy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510651577-20794-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--In+4dZ/2sY1gGzQy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 05:26:16PM +0800, Yixian Liu wrote:
> Considering the compatibility of supporting hip08's eq
> process and possible changes of data structure, this patch
> refactors the eq code structure of hip06.
>
> We move all the eq process code for hip06 from hns_roce_eq.c
> into hns_roce_hw_v1.c, and also for hns_roce_eq.h. With
> these changes, it will be convenient to add the eq support
> for later hardware version.
>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/Makefile          |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_cmd.c    |   1 +
>  drivers/infiniband/hw/hns/hns_roce_cq.c     |  19 +-
>  drivers/infiniband/hw/hns/hns_roce_device.h |  57 ++-
>  drivers/infiniband/hw/hns/hns_roce_eq.c     | 759 ----------------------------
>  drivers/infiniband/hw/hns/hns_roce_eq.h     | 134 -----
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 740 ++++++++++++++++++++++++++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |  44 +-
>  drivers/infiniband/hw/hns/hns_roce_main.c   |  16 +-
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |   1 +
>  10 files changed, 843 insertions(+), 930 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.c
>  delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.h
>
> diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/hns/Makefile
> index ff426a6..97bf2cd 100644
> --- a/drivers/infiniband/hw/hns/Makefile
> +++ b/drivers/infiniband/hw/hns/Makefile
> @@ -5,7 +5,7 @@
>  ccflags-y :=  -Idrivers/net/ethernet/hisilicon/hns3
>
>  obj-$(CONFIG_INFINIBAND_HNS) += hns-roce.o
> -hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_eq.o hns_roce_pd.o \
> +hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
>  	hns_roce_ah.o hns_roce_hem.o hns_roce_mr.o hns_roce_qp.o \
>  	hns_roce_cq.o hns_roce_alloc.o
>  obj-$(CONFIG_INFINIBAND_HNS_HIP06) += hns-roce-hw-v1.o
> diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
> index 1085cb2..9ebe839 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
> @@ -103,6 +103,7 @@ void hns_roce_cmd_event(struct hns_roce_dev *hr_dev, u16 token, u8 status,
>  	context->out_param = out_param;
>  	complete(&context->done);
>  }
> +EXPORT_SYMBOL_GPL(hns_roce_cmd_event);

Are you sure that you need these symbols to be exported (used in other modules)?

Thanks

--In+4dZ/2sY1gGzQy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloKs1IACgkQ5GN7iDZy
WKdqSw/+ND9byRFPWZs02RzP7uFQAo4xXp1ISGCUzP0TebJ2EZgS4HZAcou/HxLx
t7H9yPJty/MIaVkXMetPS0TrITj+aR6OsACtPmNdHOmT+M8KTj/HmLT0KGgQdd9M
sbYguW6Kd/aIgVsFwRco+FWs36oYzc+o/d9lC9M/nRUhGo762dqa9mrLHtH8G2b5
DFVpL8gZ3rNAfIX8VDUJ6wkEbfdrlnB4gH09YiuMtg7QM7/SNdhsTJlJgLrhLAv5
yJadJhXlI4YqWjuw9Wwyut5wEoGFnvcxiD3TeCH4MGUsJzU6bMdwefviME+mjBZp
hBG8qvogQ0b9IOM0yG6eVRfWq6ohHD8W19AuG7phDpDtpEjHyV+eRBJccj23ibXe
Cz+OeG3W4ZxDfOLJ+RVXn1G538nysi+5E8mqkKJ5xDowhtZJZbsAsk8V8w4zIamn
XL1xTLvIXVL6+BS8SpVwAvRfjZNWjP7T4gR2m8Z5mo/mmC294BBvIbWXg/BlDxOs
bfQKlZrun8oFagjHq6ELhmqMC/7erepv4azQK2sv6zB0R1aMLAGcoqa7LaA/Mgn6
pSmnTRyyqRkFcykLkcOSJ8pKyqHaeV+BHj8DE3Ov45qbYCkh8hEVnJY7E8PvkKMB
knGMShUDE6CMkAkTqWk+jF/CzCou6C3A20y0Rim/OunO8zvV62U=
=q1T+
-----END PGP SIGNATURE-----

--In+4dZ/2sY1gGzQy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
