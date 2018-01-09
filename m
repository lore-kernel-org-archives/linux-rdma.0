From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 6/6] RDMA/hns: Set the guid for hip08 RoCE device
Date: Tue, 9 Jan 2018 16:45:24 +0200
Message-ID: <20180109144524.GJ6823@mtr-leonro.local>
References: <1515039563-73084-1-git-send-email-oulijun@huawei.com>
 <1515039563-73084-7-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515039563-73084-7-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 04, 2018 at 12:19:23PM +0800, Lijun Ou wrote:
> This patch assgin a guid(Global Unique identifer)
> value to the hip08 device.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 6b4474d..6a6f355 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -4658,6 +4658,22 @@ static void hns_roce_v2_cleanup_eq_table(struct hns_roce_dev *hr_dev)
>  	{0, }
>  };
>
> +static void hns_roce_get_guid(u8 *dev_addr, u8 *guid)
> +{
> +	u8 mac[ETH_ALEN];
> +
> +	/* MAC-48 to EUI-64 mapping */
> +	memcpy(mac, dev_addr, ETH_ALEN);
> +	guid[0] = mac[0] ^ 2;
> +	guid[1] = mac[1];
> +	guid[2] = mac[2];
> +	guid[3] = 0xff;
> +	guid[4] = 0xfe;
> +	guid[5] = mac[3];
> +	guid[6] = mac[4];
> +	guid[7] = mac[5];
> +}

Please take a look on the commit: 4d6f28591fe4
("{net,IB}/{rxe,usnic}: Utilize generic mac to eui32 function").

It presents the correct way to update guid.

Thanks


> +
>  static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
>  				  struct hnae3_handle *handle)
>  {
> @@ -4680,6 +4696,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
>  	hr_dev->iboe.netdevs[0] = handle->rinfo.netdev;
>  	hr_dev->iboe.phy_port[0] = 0;
>
> +	hns_roce_get_guid(hr_dev->iboe.netdevs[0]->dev_addr,
> +			  (u8 *)&hr_dev->ib_dev.node_guid);
> +
>  	for (i = 0; i < HNS_ROCE_V2_MAX_IRQ_NUM; i++)
>  		hr_dev->irq[i] = pci_irq_vector(handle->pdev,
>  						i + handle->rinfo.base_vector);
> --
> 1.9.1
>

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpU1YQACgkQ5GN7iDZy
WKdulg//eJVs0kf1rcncrWpRwmd2kW0m9nfDck2fXQ2jdpA2P3TPLktgHiGEb7Ol
9SUPiRDHRlwrn7MZhOmIIP1NsZW/YMhT/yx60sLWh3I1pXiwWpkvGgyEycLazUiC
oRpNkhDAnCV/vPx6UTL351Bg59OZmuncOS/JfMxEoHTQUkgDl54Efug3Ao5ji78z
10mtckwTtnhozNwnHGfkEAJNRdEXAf82Uy+61Zlmztu2xCwHshOF0SQhCjqHJFE7
f6iEspfO5vCeZnv4bzbR+PWMOiSOaS4wrX2a+qZ09dttzOTEDY77GKsqlN9S3sz9
2fRhm4P07KmiRoDLLj75fq9QcTyzjBAnzhy3BfteO1cp5KbbmkrzqsjEqS6lk1+0
CcUqA4G+3b9Ie+hi38Qb5AOYADqVFB92Xvv8yYOoFh80Dhmxzy+2yGQvR7g2nyIL
F+/PnRY51JJjotwHNcpCvE+0gfjmMSB/NmgDrdJX5VR4zb6GcL3mwPMcp410uedc
4raqGjjg6Bl/JQkjk7HbTIFywAmV7XVhutvPyR9fvdcgIsbY0m361PxYjAAxekzW
TFmdDAbPb4lDN4gN7hrZIiteUdn2t9l205S3ZWmF21jdSq6hQxe0Jgdiw73SddiN
vSQNmhGmUCw1eKxyNtAxneKr0pOmdq1eHEEoL8KcWCMtAqXPf2Q=
=B4cQ
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
