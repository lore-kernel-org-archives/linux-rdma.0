From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mlx4: Test port number before querying type.
Date: Tue, 3 Jul 2018 09:21:11 +0300
Message-ID: <20180703062111.GC3014@mtr-leonro.mtl.com>
References: <20180702210234.107361-1-tarick@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5dNcufZ4prhark0F"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180702210234.107361-1-tarick@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tarick Bedeir <tarick@google.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, edumazet@google.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--5dNcufZ4prhark0F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2018 at 02:02:34PM -0700, Tarick Bedeir wrote:
> rdma_ah_find_type() can reach into ib_device->port_immutable with a
> potentially out-of-bounds port number, so check that the port number is
> valid first.
>
> Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
> Signed-off-by: Tarick Bedeir <tarick@google.com>
> ---
>  drivers/infiniband/hw/mlx4/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index f045491f2c14..4f1dabecf9a5 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -4034,9 +4034,9 @@ static void to_rdma_ah_attr(struct mlx4_ib_dev *ibdev,
>  	u8 port_num = path->sched_queue & 0x40 ? 2 : 1;
>
>  	memset(ah_attr, 0, sizeof(*ah_attr));
> -	ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, port_num);
>  	if (port_num == 0 || port_num > dev->caps.num_ports)

Did you get any warning from any checker about out-of-bounds access?

According to the line above, port_num can be 2 or 1 which are valid ports for mlx4
and the check above doesn't do much.

>  		return;
> +	ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, port_num);
>
>  	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE)
>  		rdma_ah_set_sl(ah_attr, ((path->sched_queue >> 3) & 0x7) |
> --
> 2.18.0.399.gad0ab374a1-goog
>

--5dNcufZ4prhark0F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbOxXXAAoJEORje4g2clinN2MQAJtwK6k9TMWgpNCT/oqmaGSs
d9z4rXf+s5dv4nbpy8b8bdBsDnT/Z+nDOt0tMhOmcdQN6WZL4fiixLBiEn6uQ0q3
sY1zbxQrcB7l22WX4eIiGHc/kFMCx/SWqd5tCNRMS7Tt79QJ/yqcilv06MBWjDAW
Ii7wmIWDjhsz5DvXzvAhDweqGDKa4AyDI6kEflL8iGfQR+vaZ1xEVDXcXd0fF6gD
cwwecW15wi0lXi+Y3fA4766Vgapfrdbkf94DEhdbuRtMjYDiTmxizHwIpSkyLgA6
+L8guzRUU8kizUvrFnjgq54eUvM6QashIWBgUCn7of4xLndWRU6G5REFPy3YpfBw
az9MK1MufpW/s/opnoQsB9K3tF1+rZQxfL0ZTbhN5wwx+hb2YkUxrLcQZqYZvfWh
wt8LojJxvQs2pVcosxhc5Hn0gCKCMPODmZBS7Et5JZierarucCnIRiOxonHF5uky
CcovlIU2CDsYXHELCq8DJOTA095K08fNYwEuT7Ylksa3j0QKAfdUtbLYbTpAcHjz
NAa9oahiNLS/lmYFS2djQVdlE1MgXxQv6G1XJIICgTT52d1zTFoAgMBWgGalpNOJ
gQJQR8fg7G0VOc4BC7pszXjVx+uYJSV+9S+oyNdlohtz8DbiR8EFkL3wpAuAx27Z
qC/BgfnYDAXDvdtzqt/7
=Y39f
-----END PGP SIGNATURE-----

--5dNcufZ4prhark0F--
