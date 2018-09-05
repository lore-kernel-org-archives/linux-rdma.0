From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Wed, 5 Sep 2018 16:50:35 +0300
Message-ID: <20180905135035.GT2977@mtr-leonro.mtl.com>
References: <20180903161316.25121-1-ar@cs.msu.ru>
 <20180903161316.25121-4-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KSyhVCl2eeZHT0Rn"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903161316.25121-4-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--KSyhVCl2eeZHT0Rn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 03, 2018 at 07:13:16PM +0300, Arseny Maslennikov wrote:
> Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 38 +++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 30f840f874b3..7386e5bde3d3 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -2386,6 +2386,42 @@ int ipoib_add_pkey_attr(struct net_device *dev)
>  	return device_create_file(&dev->dev, &dev_attr_pkey);
>  }
>
> +/*
> + * We erroneously exposed the iface's port number in the dev_id
> + * sysfs field long after dev_port was introduced for that purpose[1],
> + * and we need to stop everyone from relying on that.
> + * Let's overload the shower routine for the dev_id file here
> + * to gently bring the issue up.
> + *
> + * [1] https://www.spinics.net/lists/netdev/msg272123.html
> + */
> +static ssize_t dev_id_show(struct device *dev,
> +			   struct device_attribute *attr, char *buf)
> +{
> +	struct net_device *ndev = to_net_dev(dev);
> +	ssize_t ret = -EINVAL;
> +
> +	if (ndev->dev_id == ndev->dev_port) {
> +		netdev_info_once(ndev,
> +			"\"%s\" wants to know my dev_id. "
> +			"Should it look at dev_port instead?\n",
> +			current->comm);
> +		netdev_info_once(ndev,
> +			"See Documentation/ABI/testing/sysfs-class-net for more info.\n");
> +	}
> +
> +	ret = sprintf(buf, "%#x\n", ndev->dev_id);
> +
> +	return ret;
> +}
> +static DEVICE_ATTR_RO(dev_id);
> +

I don't see this field among exposed by IPoIB, why should we expose it now?

> +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> +{
> +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> +	return device_create_file(&dev->dev, &dev_attr_dev_id);

Why isn't enough to rely on netdev code?

> +}
> +
>  static struct net_device *ipoib_add_port(const char *format,
>  					 struct ib_device *hca, u8 port)
>  {
> @@ -2427,6 +2463,8 @@ static struct net_device *ipoib_add_port(const char *format,
>  	 */
>  	ndev->priv_destructor = ipoib_intf_free;
>
> +	if (ipoib_intercept_dev_id_attr(ndev))
> +		goto sysfs_failed;
>  	if (ipoib_cm_add_mode_attr(ndev))
>  		goto sysfs_failed;
>  	if (ipoib_add_pkey_attr(ndev))
> --
> 2.19.0.rc1
>

--KSyhVCl2eeZHT0Rn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbj98rAAoJEORje4g2clinUp0QAMzfhd9jNu4AJW1Hdc3xRVUk
wEnDRBibqwmmIiBc5IwBO2hJs4++zAIpwgjyvn83wGFJHKAChPUClmOqi3bEDa+A
gA+AmYTMcc9OdSw5Vx84kW52HGplqWcffKYsWVy+QKxCu4zAA+RyHmdevfDVL6N/
7gtF1H2Trgg1PBWwDb9/Rx5GnHPP34t3iv4sQlsuAfdZdqYwCm2X6JM/YGtWIf80
zcQRly/A1Y9ruFGx26n+fCZVi49O5oZFwTAJx4c/teig60ewjxdoR1WNA3Bm+WiG
aKN/2+mdez1VYxbhZcTI53f0NOa8NmgAElFciSGuDT8vq++Zh1zTiMS6pd8muclY
PmT+PmHaYfrfLv6+Te6BDC9e85GuBSZ9tS0Z7UKq1heMtOXFpbiQET2rHq0mJ/uT
PMEMMt1QNaJhSdgBvpFiidmbaOXGPdj2TkXFVA4QpeNaZbpB6Ny72sTLHqYKoNIo
4dVLEsggo2qD/QDi/F7dOm1ZV6VW9wTznFYHT3Y0HWY1yY3PXuPe4g8o6Wk1pEZX
ZWrmjBsr8IbUW3wMbECWhB2Puty2wrOIwjoPksA3pPKKemhEYiN9ySOvi3pNt2S/
PlVj3N27JvG3tyAIVaSJ8cUlhyHzXSW6c9MlyTKT0BlYHHrc94r2SkhatNldEW4q
Fs64D62ICu5hr7SMGDUa
=IJym
-----END PGP SIGNATURE-----

--KSyhVCl2eeZHT0Rn--
