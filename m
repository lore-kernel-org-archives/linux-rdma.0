From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/ocrdma: remove unneeded tests
Date: Tue, 26 May 2015 08:45:10 -0400
Message-ID: <1432644310.28905.95.camel@redhat.com>
References: <1432238824-16953-1-git-send-email-laurent.navet@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-guVLw+MpmkEV8l6qHTEd"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432238824-16953-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Navet <laurent.navet@gmail.com>
Cc: selvin.xavier@emulex.com, devesh.sharma@emulex.com, mitesh.ahuja@emulex.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-guVLw+MpmkEV8l6qHTEd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 22:07 +0200, Laurent Navet wrote:
> The same code is executed regardless status value, so these tests can
> be removed.
> Fix Coverity CID 1271151 and 1268788

Thanks, applied for 4.2.

> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniban=
d/hw/ocrdma/ocrdma_hw.c
> index 0c9e959..e748090 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -1960,9 +1960,6 @@ static int ocrdma_mbx_reg_mr_cont(struct ocrdma_dev=
 *dev,
>  		    upper_32_bits(hwmr->pbl_table[i + pbl_offset].pa);
>  	}
>  	status =3D ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> -	if (status)
> -		goto mbx_err;
> -mbx_err:
>  	kfree(cmd);
>  	return status;
>  }
> @@ -3044,9 +3041,6 @@ static int ocrdma_mbx_modify_eqd(struct ocrdma_dev =
*dev, struct ocrdma_eq *eq,
>  				(eq[i].aic_obj.prev_eqd * 65)/100;
>  	}
>  	status =3D ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> -	if (status)
> -		goto mbx_err;
> -mbx_err:
>  	kfree(cmd);
>  	return status;
>  }


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD


--=-guVLw+MpmkEV8l6qHTEd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZGrWAAoJELgmozMOVy/dIJ0P/RT34ydpnG10RbTfcuB6b1H8
noFvm0lwnTttWI7yjSCTSUULTJL65zQDaK+U4+Wjn0NS1Livl1rZDR100oqtSy09
khUfxevl32cY6WPZbmmVPMThc7kP7pqKlkuKQY6jG4TLvaKd7lZQZZaVzFRb4rou
gfpSUrhdWXez5Nt3oRqJ88IkbXx2lyfS4tsKw+0ck6AkRZwWaKN2aNiGhXyr7g74
eJNy8pD6tn2WeDcNpVTGXUek/Bqa37Akmy1XRTvqX/5r3j4KL1nXYURzmlcDXpXD
alENIe+1L65RGpS1/Tr/Ay+Bf6Yopttd8t/onrHBf+vGVHApGR/70rd27+vrNl/L
faTsI01BrJp9ze6+Rx+ejVwCmN3QLDAehckyrWgd5Auq9tdyzr1fkVYVsv+KqOTA
Vxwgxd+sO/oQnwZ/sfwhiBiuasN6PuVbldafeKCn73zwwjyYPCrdtU6Gr5m+V5kk
tZYZxL76rnT7DgqPNYmp3qW/lQ1HNQ16hpPS9xrZJYVdVRJMspxf0LlEI9pxdFGF
KdGyxvhl3XG93nQRDkiK7KHGAftIMzR4SJ7/canFDCQHNljOU9Qe5ngTS5fv4JoU
sXnxAIFAUPfJeq+C5lmypZ+iQaSF8pYrSYw8w3mRNyFA4fp34iiD8GLTv3zswuLS
F8zw+dbmXkERDLfzNpPH
=oB3g
-----END PGP SIGNATURE-----

--=-guVLw+MpmkEV8l6qHTEd--
