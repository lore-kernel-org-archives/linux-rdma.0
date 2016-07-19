From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [QUESTION] Is an ib_sbft kernel module needed to be made? (For
 booting using SRP)
Date: Tue, 19 Jul 2016 12:18:39 +0300
Message-ID: <20160719091838.GI20674@leon.nu>
References: <CA+X5Wn4aYpxAKO5aCQS+T1MH1MMedd+ukBecZGSbg02QdX1YSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X0cz4bGbQuRbxrVl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+X5Wn4aYpxAKO5aCQS+T1MH1MMedd+ukBecZGSbg02QdX1YSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--X0cz4bGbQuRbxrVl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 18, 2016 at 10:13:15PM -0400, james harvey wrote:
> I'm looking to boot using SRP.  I've spent a lot of time looking, and
> am not seeing that anyone has actually done this.  Really surprises
> me, actually.
>=20
> iPXE is able to make the SRP connection, load the kernel and
> initramfs, and leaves behind a SRP boot firmware table as described at
> http://ipxe.org/srp/sbft
>=20
> But, I don't see anything that finds, reads, or uses it.  So then then
> remote drive is no longer seen.
>=20
> I see iSCSI handles this problem through the kernel module iscsi_ibft
> which gives a sysfs interface to iSCSI's BFT structure.
>=20
> I'm somewhat interested in developing the ib_sbft kernel module, if
> I'm not missing an existing alternative to allow SRP booting.  I
> expect I could work from the iscsi_ibft kernel module source to be
> able to accomplish this, making the necessary changes based on the
> sBFT documentation and iPXE's sBFT-creating source.
>=20
> Is anyone else who has done kernel development interested in taking
> that on, or is it something I should start working on?
>=20

Is this ability needed? Do you have real life scenario for this?

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--X0cz4bGbQuRbxrVl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXjfBuAAoJEORje4g2clin/pUP/2k3qsXzP62lJ2z7WgUX690u
b70PYUAwu6Yk8aQYSfIFiIQiAK6qcgzUDOEloAYU7+aTGtc6J9lz0cBzv+ttVou7
+hrpqtAGjm65wnpCtyq+d6AfXxQI+PFM3vCdVGUj45Wym0LL2C+XWwmpXLRxm0nx
hhtuexn3PLOUdbwzo+BSvVgq6VCaUO6albrzCtJMyA16Cgib0eOL0z0y1zMhZ/K/
pg2wGyTWZkinT6/USofNg2hCIyYDMpHpDzKDLNbXNxRfzc/vVj1o0ixCJt64Dj5c
s4aT729bu1u4NRlmYRAtAUB+aR25apE0G8fO1JcwzyQBxFrzMZSIBbiHhY30D2TR
klX3herFzZkN2DE0sdF8Kl36EFAMZei2dDSc+iVEap623cYjXsdjR1uswPGKGx3m
ZKNR+nP9R9re0CTgHIOdwDlW8p6paSlnDaHHLA3OsnfYChwgwN1QGvyetcYr3QED
LJvRBtZ6DGd5ZO1aJd5mneRVetRzNgWfM0wsTkmgP4mV7EDzGSDwVZo4VnasHC0j
ED1sI/e36WkjdSz9fa49LST11UTAIX90BgvnoV34pyarxyUQe1UqcCrDCch4RSSc
ALgGlYUTbPgZs3aKWpw9+os5RyJyalbJAnQFGVrQZ8yDZ8E5Q3GyPkiaFxZUbU+7
+ZvkwPAdePSpjRq0Jc6x
=wCPV
-----END PGP SIGNATURE-----

--X0cz4bGbQuRbxrVl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
