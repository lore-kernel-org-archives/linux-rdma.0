From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 4/4] IB/core: RoCE GID management separate
 cleanup and release
Date: Sat, 15 Aug 2015 10:14:52 -0400
Message-ID: <55CF495C.6010708@redhat.com>
References: <1438881240-22790-1-git-send-email-matanb@mellanox.com>
 <1438881240-22790-5-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9oFj9htOiO4C4sImsicc6ss5dU5klCEIC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438881240-22790-5-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9oFj9htOiO4C4sImsicc6ss5dU5klCEIC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/06/2015 01:14 PM, Matan Barak wrote:
> Separate the cleanup and release IB cache functions.
> The cleanup function delete all GIDs and unregister the event channel,
> while the release function frees all memory. The cleanup function is
> called after all clients were removed (in the device un-registration
> process).
>=20
> The release function is called after the device was put.
> This is in order to avoid use-after-free errors if ther vendor
> driver's teardown code uses IB cache.
>=20
> Squash-into: 'IB/core: Add RoCE GID table management'
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I had originally used the v1 of this patch instead of v2.  In order to
make sure I didn't miss anything, I hand compared the final results of
the v1 patch to what this patch would have created if I had used it.  I
found a few things worth nothing, comments inline below.

> @@ -903,20 +924,28 @@ int ib_cache_setup_one(struct ib_device *device)
>  					  (rdma_end_port(device) -
>  					   rdma_start_port(device) + 1),
>  					  GFP_KERNEL);
> -	err =3D gid_table_setup_one(device);
> -
> -	if (!device->cache.pkey_cache || !device->cache.gid_cache ||
> +	if (!device->cache.pkey_cache ||
>  	    !device->cache.lmc_cache) {
>  		printk(KERN_WARNING "Couldn't allocate cache "
>  		       "for %s\n", device->name);
> -		err =3D -ENOMEM;
> -		goto err;
> +		/* pkey_cache is freed here because we later access it's
> +		 * elements.
> +		 */
> +		kfree(device->cache.pkey_cache);
> +		device->cache.pkey_cache =3D NULL;
> +		return -ENOMEM;

This function is unnecessarily convoluted IMO.  A simple change to using
kzalloc() for the pkey_cache alloc eliminates part of the issue.  As a
result, I fixed this function up to be different than either patch.
Please look over my results and make sure you agree with my changes.

>  	}
> =20
> -	for (p =3D 0; p <=3D rdma_end_port(device) - rdma_start_port(device);=
 ++p) {
> +	for (p =3D 0; p <=3D rdma_end_port(device) - rdma_start_port(device);=
 ++p)
>  		device->cache.pkey_cache[p] =3D NULL;

For instance this goes away entirely by using kzalloc().

The rest looked ok.  I have to fixup the ordering changes between sysfs
and cache to make the v1 patch match the v2 patch.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9oFj9htOiO4C4sImsicc6ss5dU5klCEIC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVz0lcAAoJELgmozMOVy/diooP/3KwivM0a+EUyn0FtTGqXotG
FD7nQaYlh080rQcvDuDaxPwertxDAf5Dm4GnGWxVdDhRNEzruELD1mblod9Hl9Lv
X6XrWbaAjXiCw4ZTf+zr7QsGKUX3NQnh4y2+LXv3H2gHLBpuztPzQKlq5z0usjgX
900tKEipwFl1Nfsvi3vbDzsxZLk8RfgaJxh5K4IIE6s/TDbT/F6R0XiwmjCSQDsE
Bb+XcvHxEkTLbK5En5KeYZM1Wzdlh9EHoV3k1R5lj89yD8LTeyiRWqrqLpqwCF2W
HFbeoGz2Q6gkTy2IRtPtkYOyAO7Cg1oOVsbRHhwLjoZ14Aq0mPc0BGIlOplsH0iA
aKiTGFLrYkwyhlM0/GlXZzsOTdQuNBCW7v7gQdL6QhBqBPG8vuenVirvBLp+uIKw
VsqFilkOKDyBgK+WTb3NK75yTlgfsGSSH8ZzgC6o24h1r5v9h84Go9gSWzU7IJ6O
Uji1tLvbyRESNho1JSD213MqrwCu8Awgt1wV2fZMPCHW0pEGnN8TxHmZpWMbz9SZ
MzQU0tQ4Y+kjzBmY4j6JH6iH68N+UHBvmjq51ejzsUWH+vGSZP1yIDKIjb64Afvp
VUkW1ve+Ho+hMVW7Ax7WrN/7nuSS3K+DmDGsfn+mePRxRLs18ocofmcnQjLeBKuK
MW37HG31vbOyQVGwKsMG
=trxZ
-----END PGP SIGNATURE-----

--9oFj9htOiO4C4sImsicc6ss5dU5klCEIC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
