From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 11 May 2016 21:37:11 +0300
Message-ID: <20160511183711.GA11827@leon.nu>
References: <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu>
 <20160509195734.GA22669@obsidianresearch.com>
 <20160510044107.GU29160@leon.nu>
 <20160510170739.GA2879@obsidianresearch.com>
 <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org>
 <20160511020429.GA32766@obsidianresearch.com>
 <20160511043134.GE900@leon.nu>
 <20160511173608.GB18517@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160511173608.GB18517-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 11, 2016 at 11:36:08AM -0600, Jason Gunthorpe wrote:
> On Wed, May 11, 2016 at 07:31:34AM +0300, Leon Romanovsky wrote:
> > On Tue, May 10, 2016 at 08:04:29PM -0600, Jason Gunthorpe wrote:
> > > Look at the patches. The LSO patch is so bad Sean and Steve couldn't
> > > even figure out what the heck the HW feature does. I know what it
> > > does, but I can't tell you the fine details of the actual required
> > > hardware behavior.
> >=20
> > These people are very busy and you can't expect from them to know
> > everything, If someone doesn't know/understand, he will ask, exactly
> > as they, you and me are doing all the time.
> >=20
> > Just to remind you, that YOUR's patch [1] didn't meet YOUR own quality
> > criteria and can be called bad one, just because very respectful people
> > asked their questions which very expected to be answered in the patch
> > itself, but they don't [2].
>=20
> Oh come on, can you please get serious about this? Stubbornly taking a
> baseless and totally obstinate position is not working with the
> community.
>=20
> A security patch, which is deliberately a little obtuse to avoid
> telling the world how to write an exploit, is not at all the same as
> describing a complex new uAPI feature that is expected to be
> implementable by other parties.
>=20
> I can't believe you'd even try to use that as an excuse.

It is not an excuse and never supposed to be.

My position is very concrete on this topic: post code on ML, start
discussion, adjust the code and merge it.

It works for all other code posted on various linux kernel ML and
I don't see why it can't work for RDMA too.

And again, there is openness and readiness of all participants in this
ML to answer feedback and post adjusted code.

>=20
> Jason

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXM3vXAAoJEORje4g2cliniZgQAL1DtcqxekwsGS/EJ/bDmzk0
ckmT/a14ucFlQ7isMVtvJG6GVOc+OmzSug5UC0XrdULxN3BjyHN3xGIzqTcdVJpZ
25HPnfbJSEisia+R4NLEk59lswElwiT6IHhV9seJGcVfaMXAgFK+k1TqcjxFs60I
pnDxdSeiMaQYYE2F6FPNWIHJj8hw0k+9miQSAVfCWmolgDV/PIdWc/28xHCz68vV
HMGbJtGpP4csZjkKlypDOPCZv2BlQEYdaP8QUOILslVrYvnwv48JbfyO45kro4Xh
ygZjxAnKLpXgwUrhpZVarodP1Gy/ym9ionGcufBRSX+zqAzFBPYm2ns4DKeVonfW
+W+9ynTkCwvTeig+F4VKzaBHHYdmgDZQiFWU6JrttHTZGT+B4IkJ0/WHCLIGp++q
NbjCX+3qNYmBZkA2hxpY4y563SquLCU8DLwp94hQDTskuEpcQT3YFBN9S83mRbOd
oBpKEdOBwqKn6qwiSasRDyKdrNsuyr9GsiClT1qrwAKCf5czb3TC9qhhqln/YwKD
iokieQRmoJQfUjIz7o116vpZD2VPlDp/AfUuCrVpgx5PezPIYYkqQdVUc2iHex3B
sLCoZKIueiEYGQIDqtpxSxZOF+VNctKPBLzL/Wjqi6wGI+8GLrQIWr6Ds49uq28u
5+kUf1/1OLA5nXh+M5+f
=PmyB
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
