From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 25/25] IB/mlx4: Workaround for mlx4_alloc_priv_pages()
 array allocator
Date: Wed, 22 Jun 2016 17:09:13 +0300
Message-ID: <20160622140913.GG9762@leon.nu>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
 <20160620161200.10809.45762.stgit@manet.1015granger.net>
 <576A9AE6.4070500@grimberg.me>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1c6L/cjZjI9d0Eq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <576A9AE6.4070500-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--L1c6L/cjZjI9d0Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 05:04:22PM +0300, Sagi Grimberg wrote:
>=20
> >+	/* This is overkill, but hardware requires that the
> >+	 * PBL array begins at a properly aligned address and
> >+	 * never occupies the last 8 bytes of a page.
> >+	 */
> >+	mr->pages =3D (__be64 *)get_zeroed_page(GFP_KERNEL);
> >+	if (!mr->pages)
> >  		return -ENOMEM;
>=20
> Again, I'm not convinced that this is a better choice then allocating
> the exact needed size as dma coherent, but given that the dma coherent
> allocations are always page aligned I wander if it's not the same
> effect...
>=20
> In any event, we can move forward with this for now:
>=20
> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Thanks Sagi,

As an update, we don't have reliable answer regarding mlx5 yet, if
similar limitation exists there too.

--L1c6L/cjZjI9d0Eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXapwJAAoJEORje4g2clin3lsQALlfrLPmJ7wSs7p58NOi65Ba
jtZh05DzgTDGXeABf2th8b6kT6SZ1g5L317A6AypbJPORuOOKWwJXo/rCRYbzrGD
+RLTZQZz3Z9m3i+YOWQwcixJwNpPSJ3YsAtZS7mamiPXG/rXT9MdJy0JJxtMBEoo
shx0+VGSrqRn4aNecDtpVaSGIClLKKpg4ec75k0YCsDOFHYbMIFUq4dnPuLIxuiO
hRmZ/EvtnZXkjGQxA+m9rJ7helpU5bHQ3YGPV8gm21rjw4R5AbGyuv6MCNGakCmR
wCfreSNvoz3MeEpPhvRzNcSMK+uedDxmbZMBHTWVx1hM8I3A/5qIbRF0EbjXjyaY
dKWvej08sR8ozUq4VfxXtMXjUqNXP9NpYHxgU8TzWhBJryDp+sF6GNIRf7ncm5NC
xNkUhFBCckjezgqpKhUxbcAoPonQKXNo9dkw7fFTm3UqI4C+43xpOazFO8w4KGA5
A+ayhXCVSNtVbBmOEownCl97os/VHIISnpKZ86OA7bxrbwzPF1nlxO0WiiHNmWKT
wm2cMzu3eCLaT8cJUYpqt6PswKvEonKfYp0B4oswc1HauM320A6yq0NMKdi138tB
DCZZc5Ica6eRqwef3CLXQZ7i4o8Dr6RILGfT/b+q1jdmikynKNRmNwlato6HIhce
OWQk0ULbTERqXAckiprB
=T/Vn
-----END PGP SIGNATURE-----

--L1c6L/cjZjI9d0Eq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
