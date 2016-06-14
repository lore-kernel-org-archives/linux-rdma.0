From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Tue, 14 Jun 2016 16:15:52 +0300
Message-ID: <20160614131552.GP5408@leon.nu>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com>
 <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848@sandisk.com>
 <20160613140747.GL5408@leon.nu>
 <946373818.41993264.1465827597452.JavaMail.zimbra@redhat.com>
 <887623939.42004497.1465831339845.JavaMail.zimbra@redhat.com>
 <450384210.42057823.1465857004662.JavaMail.zimbra@redhat.com>
 <1964187258.42093298.1465869387551.JavaMail.zimbra@redhat.com>
 <11e680c4-84b3-1cd6-133c-36f71bd853d0@sandisk.com>
 <20160614120833.GO5408@leon.nu>
 <fe7c9713-2864-7b6c-53ec-f5d1364d65d8@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3SAtXwgGp429mN7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fe7c9713-2864-7b6c-53ec-f5d1364d65d8-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--R3SAtXwgGp429mN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 14, 2016 at 02:25:15PM +0200, Bart Van Assche wrote:
> On 06/14/2016 02:08 PM, Leon Romanovsky wrote:
> >On Tue, Jun 14, 2016 at 11:24:28AM +0200, Bart Van Assche wrote:
> >>On 06/14/2016 03:56 AM, Laurence Oberman wrote:
> >>>Tracing [ ... ]
> >>
> >>Can you try to set the kernel command line parameter swiotlb to a value=
 that
> >>is a multiple of its default (64MB), reboot and see whether that helps?=
 See
> >>also Documentation/kernel-parameters.txt in the kernel tree.
> >
> >Do you think that 64MB is not enough for this scenario?
>=20
> Hello Leon,
>=20
> Does this mean that you think that the "swiotlb buffer is full" messages
> reported by Laurence could be caused by something else than hitting the
> swiotlb limit?

I don't have enough knowledge in that area to answer if message "swiotlb
buffer is full" is correctly explain current situation and I will be
glad to get input from you about it.

Thanks.

>=20
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--R3SAtXwgGp429mN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXYAOIAAoJEORje4g2clinJhEP/2qwW0io101gIQEr4Em6MehG
VEKtjN7XlvSCrJiuTVTIAjmeu6HDCSPDIk7gbVAPvm29p56W6u/3kZGOdq753Xhi
8O/EjpJeZ6Rglil4WabKL3O0BmtUxKQZlMS8XwRNWwVqkByHQuGlvX+rReK/UWQ5
oB86vOfLHP+j62VaZ7yVjbYpNT1Hh78cmYzIN0IrrR18ImuVdKZ6SIL5EDaXRkPb
+Se3C/upu53arSCZsYcldCKulciJmXoBolWNaQdPtlOSrxne3+2RRTPAUf11H5Qk
MejFYCnLz1NvFeuX/4kUDKyhCCNkyfiQ1LTsevPbUQaNR7sC7NGbrgAnNbK05jzr
rrAgJCESJGDoOHR09FPhZywFymn7YLX6tXN3LD6EGX4EGXoUO3Q2aJ99m3c15kD/
GQc32vaU5Uysq2IbBZJRJIeE+4W0FJO1gvQpJ55qtNdM4di0NSGazH7aRcS/gprt
oE2bx/tMwYX9ZrbtPYBgcm7NUPGWSwk0xcx7jGYKi4oNNuMO9rg/DMGvgLqe59Fz
HPYJeKYDANHIOFSi6HmD91MhaRpGEMV5GjYhlwkbIvzRMYRvE19VPz7WEEDEhzTs
BFOoG4+tJyWHUCZx3FdfgEtGhziu3Q4n4E2ourzh8xLFWAnLVbEDOFAtPeAAxIqx
4da9ze8h/vp1n0cFiA2q
=xOuq
-----END PGP SIGNATURE-----

--R3SAtXwgGp429mN7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
