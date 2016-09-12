From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/hns: Add & initialize "node_guid"
 parameter for RDMA CM
Date: Mon, 12 Sep 2016 15:36:23 +0300
Message-ID: <20160912123623.GH8812@leon.nu>
References: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
 <1472765845-118972-4-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TBNym+cBXeFsS4Vs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472765845-118972-4-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TBNym+cBXeFsS4Vs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 02, 2016 at 05:37:18AM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> According to the Infiniband spec, NodeGUID uniquely identifies a
> node. This must be initialized to some unique value. This patch
> adds the support to the HNS RoCE driver to fetch the NodeGUID
> value from DT or ACPI and then use this value to initialize the
> node_guid parameter of IB device. This value shall be used by
> RDMA CM.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h |    1 +
>  drivers/infiniband/hw/hns/hns_roce_main.c   |    7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index ea73580..e943b98 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -74,6 +74,7 @@
>  #define MR_TYPE_DMA				0x03
>
>  #define PKEY_ID					0xffff
> +#define GUID_LEN				8
>  #define NODE_DESC_SIZE				64
>
>  #define SERV_TYPE_RC				0
> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
> index 4e93120..ec27f0c 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> @@ -812,6 +812,13 @@ static int hns_roce_get_cfg(struct hns_roce_dev *hr_dev)
>  	if (IS_ERR(hr_dev->reg_base))
>  		return PTR_ERR(hr_dev->reg_base);
>
> +	/* read the node_guid of IB device from the DT or ACPI */
> +	ret = device_property_read_u8_array(dev, "node-guid",
> +					    (u8 *)&hr_dev->ib_dev.node_guid,
> +					    GUID_LEN);
> +	if (ret)
> +		dev_err(dev, "couldn't get node_guid from DT or ACPI!\n");

Is it error? If yes, you need to implement proper error folding. If not,
this error shouldn't be error.

> +
>  	/* get the RoCE associated ethernet ports or netdevices */
>  	for (i = 0; i < HNS_ROCE_MAX_PORTS; i++) {
>  		if (dev_of_node(dev)) {
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TBNym+cBXeFsS4Vs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1qFHAAoJEORje4g2clinspsP/30wPqDe16/AIpFBTFR0YTMv
tWlg3+b0rlFNh2XoM5WVxOhJ7jvN9OGUzoLLwzgOKpTAsFqVQ2V5h3w81pLoL0vm
KyPCTYMLxkWFfY76geWbmOCi2Tsc3sKBRjo4z+BLaDmv6kINGoCtS9XbMvyfciYO
HBSHbUTX9pTQ8+xpCZCIpKEnRVjtNw4sfGSC6yzNSd8cp8mD9otawsBKRbLkFx8z
dHt8xXTauQgE98npuYzNK4n4zYjyafyqCIn7qXfzcsx3X2MxPybUpYOOD5iPuO3Z
Hi/rXh9SzqrYhqqqkN+xAxbs99w3iWVvDj+Y+ujScbArByW3fF5GX6lNkNmCNXuQ
ATkEWcaAbI5XFjc8dLG9s+lVNhWiA57/7DfDXC9AM0HX2xgTgudRmwHbiDyaisdj
iCiLVvrdUERolF89nsXLd1m8jJLG6QLtPVrITHPhmeaff5I0dx4cPBF74nq5KFQ6
gE0+fgKTAQ8QdheZtmVqYrpun+GlgaE1dyl2zlljrSZViXv7sxdV4EMfDqQHbTup
O4iBpUHvvvJpObH8L2JcygQiZAytlpCdxsNADmGnyjdroiWJFLV/mNRxDhmGiqX/
4Of9HYrccKrGhoQRmIn2RNibVrGal2Pm/DwH7quuVloyYIoWzl6sbIujNZOq3g4M
ahOWyLRgiL9v4PC4GxtL
=bxBG
-----END PGP SIGNATURE-----

--TBNym+cBXeFsS4Vs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
