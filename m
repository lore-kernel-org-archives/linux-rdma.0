From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Tue, 28 Jun 2016 20:05:49 +0300
Message-ID: <20160628170549.GE3584@leon.nu>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qOrJKOH36bD5yhNe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160628162028.GA27518-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2016 at 10:20:28AM -0600, Jason Gunthorpe wrote:
> On Tue, Jun 28, 2016 at 08:02:46AM +0300, Leon Romanovsky wrote:
> > On Mon, Jun 27, 2016 at 12:17:58PM -0600, Jason Gunthorpe wrote:
> > > Doug and I have both stated we don't want to see so many
> > > single-provider APIs and churn in libibverbs. This was designed to be
> > > a generic API that all providers can implement.
> > >=20
> > > The responsibility falls on you to make sure that it works
> > > universally. Compat is one option.
> > >=20
> > > This is also why it is necessary to get the other provider authors to
> > > say this works on their hardware, because they *all* ultimately have
> > > to implement it.
> > >=20
> > > I don't think many people realize this yet.
> > >=20
> >=20
> > Jason,
> > You are over-estimating the number of other providers who are
> > interesting in libibverbs in 2014-2016.
>=20
> I don't think that is a reasonable metric, verbs is stable, I don't
> expect companies to be constantly churning it.
>=20
> And that certainly doesn't mean we should abandon their providers when
> building new APIs.
>=20
> However, if that is your position then propose a patch so libibverbs
> with the new polling API will not load old providers that do not
> support it, and they can be deprecated. If their authors don't object,
> like you predict, then great.
>=20
> But at the end of the day, the message to users must be to use the
> new polling API, the old one is deprecated, and apps should never
> include fallback code because the new API always works.

Please put aside Yishai's patches, I'm not taking about them.

We are talking about the total number of other vendors who will
be ready to implement new features exposed in libibverbs.

Git log perfectly supports my claim that this number is extremely low.

>=20
> Jason

--qOrJKOH36bD5yhNe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXcq5tAAoJEORje4g2clinaAUP/2alNAoyFX5KoauDdnKvfnyv
KYq2fyNUiB72A+T2x9NCJMD0+KOJbpldxmPGdNuiycOsnF8LAhNgwlAseSr6yiYb
gyvriFSL4HH6/iqhDPDUUwvtVon659mPnY5Mev+sj9OOLg/CZNjPHSqbW9iPFMEM
jZdIjqVg5WQf/JS8htrD5jS4N6SGzWESwE/JFlvfNMbNH+kd83DcYyi1rOd33oNz
aX3Ow8NtiBHNo5KIja6gYOl6LAI1tYpMg+18rk7slxONmDIDhMD6yX0lZfjkQNxu
fmSvYkWNxYPtgV4CRy9fyzm+I3S0D67xA9LzJYazIgzy3VwuxzLwa77Gzfwfb0/S
BzvuAe1sth23FzSUEwbFfMMaNRxLhY86tsQaktN232EUEHthMsMSEWZ63cue3Oc4
jtwiMdSqQy7JJ8T8To12mi5794Grd8ONKgolmxMFu/XfKVCe2m7uI291jRWRiRh8
5Kgl2Im+1Pm/XQGzrWKGjfbWxuLc6Wjk995gZU9gq8vzI17bTjsNb1/Y9GlorNbo
fQroj3uHCwTAvtiRoUB1SYlH7tlzYTp2mgLvjWP30OUbGGwt1amd9A4GjUWvtTIU
/bYDZVn8Qv7RY2SS5XXwFCKGr0hePnuLfCgTz+Bk4s5Wlwux9BDQC6AlD8x2Xroy
0LnS/KbnEfX6mFC7xN0d
=aWU2
-----END PGP SIGNATURE-----

--qOrJKOH36bD5yhNe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
