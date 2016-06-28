From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Tue, 28 Jun 2016 08:02:46 +0300
Message-ID: <20160628050246.GB3584@leon.nu>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160627181758.GD23540-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2016 at 12:17:58PM -0600, Jason Gunthorpe wrote:
> Doug and I have both stated we don't want to see so many
> single-provider APIs and churn in libibverbs. This was designed to be
> a generic API that all providers can implement.
>=20
> The responsibility falls on you to make sure that it works
> universally. Compat is one option.
>=20
> This is also why it is necessary to get the other provider authors to
> say this works on their hardware, because they *all* ultimately have
> to implement it.
>=20
> I don't think many people realize this yet.
>=20

Jason,
You are over-estimating the number of other providers who are
interesting in libibverbs in 2014-2016.

According to git log [1] in these years, I see only one major
contributor to this library.

[1] https://git.kernel.org/cgit/libs/infiniband/libibverbs.git/log/

Thanks

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXcgT1AAoJEORje4g2clinjfEQAIv/zPpt2HFdwyS3PhHWAn9t
E06qDiWd2DYnso3r1Cqo7AyfxIfzkWgnJx4UAR8On6CaK2mt3wLbW+Z9lcFwhQlY
ViO/XyBxTc13ddYEoIyXDACp6vOk3arpesrt1ApSnQQ0/VW3dTUnfi2iSBOlwZLA
cBPSOiHmcjPkXRUgAMm7LDbo9M8Dvz/guOYDqC9F39TI8sOERWq3wvBMxTso7KFf
kz1QoUJBzteeqIVhwwHBWpyA2nbr87XtkjSCXoqWsMo9xsTDomEBSb2kSkI/PakE
YBVPNEDcB8o850Ig3XX2MQL49HG8Q83062aBeDxqoxnvMn1pWgRsPX+sfmRHg7MR
vE4Gd/XKHeT+COV2lzynJ89EsiVudnaFz0y9ZRvgbpK9rmHy60Pvy6cqTs3AvyJb
Jd746RGgZG9JyLfJVNIo44YIzHY5eH2Z4wcndw6Rv2GlWUJIHGR8nL9FSn8XrEhI
pmz5wxEuQn02FSYPiAcKEeAqaHjOrvKvchwdKGhQssnD0gNFkVMMtSKm/MN4pii9
k5oq5VRabfCHB22yrQrLpogXlgcT1QpOGl4OyBwlEh8qsfDWk5yRYhhrLdZ9QtiG
Qcjr1ZJaC1Y+7vl+VoShGgAKzrYlYHXa0VaPX+vBXWXF/25jYzfb+UwxlcBAQtFl
svl+88nPBddbibLYoIRZ
=EX+0
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
