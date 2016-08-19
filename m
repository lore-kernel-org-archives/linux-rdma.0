From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH 22/22] IB/mlx4/alias_GUID: Remove deprecated
 create_singlethread_workqueue
Date: Fri, 19 Aug 2016 18:51:30 +0300
Message-ID: <20160819155130.GL18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
 <d3a5db9481e09376cc6200de187e451a582c6722.1471283718.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Bzq2cJcN05fcPrs+"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d3a5db9481e09376cc6200de187e451a582c6722.1471283718.git.bhaktipriya96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Chuck Lever <chuck.lever@oracle.com>, Mark Bloch <markb@mellanox.com>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Florian Westphal <fw@strlen.de>, Guy Shapiro <guysh@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Matan Barak <matanb@mellanox.com>, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--Bzq2cJcN05fcPrs+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2016 at 11:45:06PM +0530, Bhaktipriya Shridhar wrote:
> alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
> deprecated create_singlethread_workqueue(). This is the identity
> conversion.
>=20
> The workqueue "wq" queues work item that maps to alias_guid_work.
> It has been identity converted.
>=20
> WQ_MEM_RECLAIM has been set to ensure forward progress under
> memory pressure.
>=20
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

> ---
>  drivers/infiniband/hw/mlx4/alias_GUID.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband=
/hw/mlx4/alias_GUID.c
> index c74ef26..5e99390 100644
> --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
> +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
> @@ -881,7 +881,7 @@ int mlx4_ib_init_alias_guid_service(struct mlx4_ib_de=
v *dev)
>=20
>  		snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
>  		dev->sriov.alias_guid.ports_guid[i].wq =3D
> -			create_singlethread_workqueue(alias_wq_name);
> +			alloc_ordered_workqueue(alias_wq_name, WQ_MEM_RECLAIM);
>  		if (!dev->sriov.alias_guid.ports_guid[i].wq) {
>  			ret =3D -ENOMEM;
>  			goto err_thread;
> --
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Bzq2cJcN05fcPrs+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtysCAAoJEORje4g2clinTlEQALqI3AmNnh+/1pIYv4x6iSMo
LA3CR07XaOcHHux1orVjrFd3VRtAJRBq59APY79o/52MXtX+ol5xQbhYqhlr2d+v
P1a19Fw6uxqOtpCO6bwPBXx2FuDE5NeOND2jSvS90iGuEct+DJZjtz85Vb1FCsI9
lH/dSK+g6vi4WS1oPRzKTXCMypbofYP+T6iOtz7JwrWByHb55eu5JII/92l+uQ7f
qo9jPd9QFUzRoqbsI87p08SP3XBWhZg9kTnSXa7vjL8L9HKjOAk5V697f01ddgs+
hQtEb0WVyyZWS9W7mMjacIV8B4QM2G2bm4Yp/bNEW9Y5x5mGwMwHNga47dmEcZ4f
zZlxsX52Lq74tBAqUx9xqUqxChRBv2ah5Cv7KiRUpi7lExbHRWQaZl4lB+0nFXvd
gwq9S72i0aAAcNHyteIz5ziLRRSfS7tAsURHZvNlMKhmHhOKX6IuPLcLCDw8xiPi
ehoOe8QUfzhA4md6mtm4Y81dgR1jg/7NK0ODHrgq9EkewH/KV/q4dPubomrzMeAr
lE/ezsEByqnQtOfuUyTiiWx1TLbXInAWM/mIxTHoilEIOVzGUEpTypa6msBHphRK
OYtnqVYn+q8rpyL8ZKwIGWaeSi9VygRXXDKEC9O+ZWV9BX6eyCce8kxXqABBD2nX
O9m1z8l5S+dpcmKEs4I3
=Cchd
-----END PGP SIGNATURE-----

--Bzq2cJcN05fcPrs+--
