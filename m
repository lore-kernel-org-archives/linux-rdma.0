From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Tue, 10 May 2016 07:58:01 +0300
Message-ID: <20160510045801.GV29160@leon.nu>
References: <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com>
 <20160504181135.GA15355@obsidianresearch.com>
 <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
 <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04A390@ORSMSX109.amr.corp.intel.com>
 <20160509200507.GA23911@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sr8SBrQ3fbgntwtR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160509200507.GA23911-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--sr8SBrQ3fbgntwtR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2016 at 02:05:07PM -0600, Jason Gunthorpe wrote:
> On Mon, May 09, 2016 at 07:11:23PM +0000, Hefty, Sean wrote:
> > > > An IBTA process? How would that be relevant here?
> > >=20
> > > What do you mean? IBTA is the only multi-vendor body left working on
> > > standardizing the hardware specification for verbs.
> > >=20
> > > These various recent patches are adding new hardware features to
> > > verbs.
> > >=20
> > > If you want hardware knowledgeable people to help, then you need to go
> > > to the forums they are active in.
> > >=20
> > > This isn't just a software exercise.
> >=20
> > Previous changes to the uABI (for example, XRC) were not accepted
> > until they were standardized by the IBTA.  An exception that I'm
> > aware of are the flow specs.
>=20
> We need to decide as a community what we want to do here, because this
> uncertain process is getting tiring for everyone.
>=20
> The Collab Summit discussions ended with a general consensus that some
> things would go to the driver-specific channel, while hardware
> behavior related to the common uAPI would go through at least a
> multi-vendor sign off process - like IBTA.

Jason,
We did ALL and much more from the discussed for RSS patches and at the end,
we saw half a word from the maintainer about the future plans for its accep=
tance.

>=20
> We didn't talk about how to expose them to apps in userspace once they
> were exposed through the kernel.
>=20
> It is pretty obvious the current 'process' isn't working.

There is no meaning of "process" without people and their execution, and ri=
ght
now, I don't see any execution of it in the linux RDMA community (fixes
and ULP changes are not merged for a while).

--sr8SBrQ3fbgntwtR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMWpZAAoJEORje4g2clinX2oQAICCpifiFfWlZiqMPkjZ4YWL
8ZExAzWX4NbOCRKViFs+LDfwyRtm6Ozd5QwQcF1JB/O/qoM1ZV8PS+olOOZufao5
sgWqBiOFWzXvium3OtjAxlgTvzINiwiCMe5oA3SibMSl/wrM8HTu6ac4cDnsqRp0
09iOOFKn04asL86wcI2XeZoP5LAMOzDS+E/6Uyc6diVvRczGdGi3XkdaijGj+y6U
48qJLClhnXYknD3LF0imNCmBAEP8+kg9b20dVQZNavr5nQB4ruWgDaasLOAS/2ve
HaE44MR2xXg5O90LznFZi5ygqIVEx837eFLu6vEDyMH5AztUpl64atXzFJILcW+N
b4Q0JDESnBSuh6ZbvnPen2Vd+vzH65WHMXR6TS3IibJrASZuGdD5rH6mSyXsz7Ur
aPjsQyKd48+mX6qAs/L8Touui/7gzDHsK1NPDxM+OpHcWywrXQyFXNKEwmizNTm2
6BjxcWVIRmWKoNhLIRml1rnPnFJOo6JMF5FcYZqU0H7WCj3khlmq4a57Z4f3W85K
N0pFukema6B42wlMgPHT77Wv3p0XoTOh+xMLT+V7SCX5lcC6BgnMid/Sbp09ewD9
bIOoWaAviCNRbINGHirvzHoxeIz4GWJYRKkxFoweiqoRYMBIdoWxZaoRhpu+2TjX
a/1MiUd+KopOLRmia1S9
=Z86B
-----END PGP SIGNATURE-----

--sr8SBrQ3fbgntwtR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
