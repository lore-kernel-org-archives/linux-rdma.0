From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH for-next 02/10] IB/hns: Register add_gid and del_gid for
 GID Table management
Date: Mon, 12 Sep 2016 15:40:10 +0300
Message-ID: <20160912124010.GI8812@leon.nu>
References: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
 <1472765845-118972-3-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+ZmrHH5cGjskQnY1"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472765845-118972-3-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: dledford@redhat.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org


--+ZmrHH5cGjskQnY1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 02, 2016 at 05:37:17AM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun@huawei.com>
>
> This patch adds support of add_gid() and del_gid() function in the
> HNS RoCE driver for manipulation of the GID table associated with
> port. This shall be used be used by CM when connection is
> established.
>
> Signed-off-by: Lijun Ou <oulijun@huawei.com>
> Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_main.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
> index 39e69c3..4e93120 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> @@ -158,6 +158,19 @@ static void hns_roce_update_gids(struct hns_roce_dev *hr_dev, int port)
>  	ib_dispatch_event(&event);
>  }
>
> +static int hns_roce_add_gid(struct ib_device *device, u8 port_num,
> +			    unsigned int index, const union ib_gid *gid,
> +			    const struct ib_gid_attr *attr, void **context)
> +{
> +	return 0;
> +}
> +
> +static int hns_roce_del_gid(struct ib_device *device, u8 port_num,
> +			    unsigned int index, void **context)
> +{
> +	return 0;
> +}

This patch makes no sense to me. It is the same as not write this
functions at all.

> +
>  static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
>  			   unsigned long event)
>  {
> @@ -639,6 +652,8 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
>  	ib_dev->get_link_layer		= hns_roce_get_link_layer;
>  	ib_dev->get_netdev		= hns_roce_get_netdev;
>  	ib_dev->query_gid		= hns_roce_query_gid;
> +	ib_dev->add_gid			= hns_roce_add_gid;
> +	ib_dev->del_gid			= hns_roce_del_gid;
>  	ib_dev->query_pkey		= hns_roce_query_pkey;
>  	ib_dev->alloc_ucontext		= hns_roce_alloc_ucontext;
>  	ib_dev->dealloc_ucontext	= hns_roce_dealloc_ucontext;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+ZmrHH5cGjskQnY1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1qIqAAoJEORje4g2clin/xYP/j3JraqDPAswUHtqFwjMd+mm
sah6LeBCEMRj9EODFKWxiJ/DQKb05Iw9BwqU2A0j/PsSg5QSMKIOayHjTrmzobpI
G3o3pftlojfeHP/1OyjSQRsA3YZZdK+WECXviHu3GvIXXuYovKS7jXHVDpgmC5AX
iN0aujrtWHQoZPV2Q/+T4IBn1IltRVhBGkPVcUZNwYBpqJs5N9pdNDMsYKPtKnzz
rE2PXg7g5XH0u+101mY98RY59+K70O/balMMj1of8WDCvq9u4lrYBJg3KbN04MBu
XFeaOi6mDzY6X9IULCtk8dx0rQHIJtFjrutM0itbVn/HOtWnzec39PKh5N3eNIW2
WMadmSf81FuEbl0ZwaeNq2heVOs8lZkaiLMMtmU2tSAiHcE4OTsudL3ut+BiUMrb
JDFFoMuNjFL7YdOEXDXKkWbWWswjTdXwdrJBr4ogSabZO62fyTsUrJQmC7Rdu+7q
qE5by7mffs1kjUrAOTKggga14P/7ajVI7kyu4R2T5FnsQRyoy8UvmSqIxyovMKUT
ZjpKgPMAgpQCjYPjph3+AhoTB+M6bkCCrFvijhEiK/KhqQK9ihgA/ZZ1WCPX5yqL
ry4xdr6JONGXeXM1bJdvFhkAW3NOZDU3IGsSGVS/pnSaKARYSnEQ7YUoTGWm728x
kpn2hhD0S4bN2EqVLla9
=Y8G3
-----END PGP SIGNATURE-----

--+ZmrHH5cGjskQnY1--
