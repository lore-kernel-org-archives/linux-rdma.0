From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: qedr: add null check before pointer
 dereference
Date: Tue, 23 May 2017 10:13:49 +0300
Message-ID: <20170523071349.GF17751@mtr-leonro.local>
References: <20170522183015.GA22310@embeddedgus>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170522183015.GA22310@embeddedgus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2017 at 01:30:15PM -0500, Gustavo A. R. Silva wrote:
> Add null check before dereferencing pointer sgid_attr.ndev
> inside function rdma_vlan_dev_vlan_id().
>
> Addresses-Coverity-ID: 1373979
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> ---
>  drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

+ Ram,

Ram, IB part of qedr driver doesn't exist in MAINTAINERS file.

>
> diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
> index 3d7705c..d86dbe8 100644
> --- a/drivers/infiniband/hw/qedr/qedr_cm.c
> +++ b/drivers/infiniband/hw/qedr/qedr_cm.c
> @@ -270,11 +270,13 @@ static inline int qedr_gsi_build_header(struct qedr_dev *dev,
>  		return rc;
>  	}
>
> -	vlan_id = rdma_vlan_dev_vlan_id(sgid_attr.ndev);
> -	if (vlan_id < VLAN_CFI_MASK)
> -		has_vlan = true;
> -	if (sgid_attr.ndev)
> +	if (sgid_attr.ndev) {
> +		vlan_id = rdma_vlan_dev_vlan_id(sgid_attr.ndev);
> +		if (vlan_id < VLAN_CFI_MASK)
> +			has_vlan = true;
> +
>  		dev_put(sgid_attr.ndev);
> +	}

I do agree that it is better than kernel panic trying to access NULL
pointer, but I'm not sure that retaining default vlan_id = 0 is correct
solution here.

>
>  	if (!memcmp(&sgid, &zgid, sizeof(sgid))) {
>  		DP_ERR(dev, "gsi post send: GID not found GID index %d\n",
> --
> 2.5.0
>

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkj4SwACgkQ5GN7iDZy
WKc3jQ//boVwBX8ZCnt2udvU9YTNPq1814nQm2hRJ+P7VhAGdOoC+Gheo/JAOjvY
yEZUO0fSAAtWBnC0ll2jx2gs17J0AgwUqDGrB6lKm3MVLGlp12VlAB7qWtCO8/hO
RASaYwvQzNeF7RdTJblFNwgjKUpiKrWRHS9Cg4AQUPFdMe1WFMG+9IZK5ViaF7u/
Wu3la6EjU5qogn2bO90VErQfTHVuTg0+vm8sxvgzY9cEdaj7ZrMjmgiUI3ks0pRd
0ff/ZSBQ6jazgcV5n3RL3Da53Km4KJZwKP4pw9z7Z93I7SLkYo6KVk5tkamIM/e1
Hu+BF770/4iaeGcpP9brJ6ZR+0D5ypsrvQNl+fuPmV+PttYNOvztVUDRgSwPGxwP
4Mub6OgWv9mVC41gYXp6ipRaJfs9hCtyVClc5x3GUvdDb7IAhaWiU9zxKDTXgkdC
6loE31uqTF0qQ74jGgVmkvI32WJ6nPLFgRq+or4r5wj+PjG4kpDwSMPXudeH1LHV
hqGcQh2+pMy7sB9ETvxp0IRfHGFOE7WaUKPkpoOOv9ecM4HdvPhiaBMTkxhI4soR
JShh3Z0T58kSZenfz7XqDTc3f9HH93FIBzMUiCHOssZNd1K/svtgzoI5IkAREwJn
aTwlNObw1ucs9x76n+Q3v/oquAhKNh0YVTcEHzYCuLI2VTB5lXs=
=cpP+
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
