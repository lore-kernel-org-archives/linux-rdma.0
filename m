From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo
 query
Date: Thu, 11 Aug 2016 08:07:33 +0300
Message-ID: <20160811050733.GA4063@leon.nu>
References: <1470755838-14117-1-git-send-email-ira.weiny@intel.com>
 <20160809175801.GD23921@leon.nu>
 <20160810053549.GA32695@phlsvsds.ph.intel.com>
 <20160810055138.GH23921@leon.nu>
 <1470856029.9289.11.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470856029.9289.11.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hariharan, Easwar" <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2016 at 07:07:12PM +0000, Dalessandro, Dennis wrote:
> On Wed, 2016-08-10 at 08:51 +0300, Leon Romanovsky wrote:
> > On Wed, Aug 10, 2016 at 01:35:50AM -0400, ira.weiny wrote:
> > > On Tue, Aug 09, 2016 at 08:58:01PM +0300, Leon Romanovsky wrote:
> > > > On Tue, Aug 09, 2016 at 11:17:18AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> > > > wrote:
> > > > > From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > >=20
> > > > > The monitor values from bytes 22 through 81 of the QSFP memory
> > > > > space
> > > > > (SFF 8636) are dynamic and serving them out of the QSFP memory
> > > > > cache
> > > > > maintained by the driver provides stale data to the CableInfo
> > > > > SMA query.
> > > > > This patch refreshes the dynamic values from the QSFP memory on
> > > > > request
> > > > > and overwrites the stale data from the cache for the overlap
> > > > > between the
> > > > > requested range and the monitor range.
> > > > >=20
> > > > >=20
> > > >=20
> > > > Ira,
> > > > On all your patches, you have double line between commit message
> > > > and
> > > > tags.
> > >=20
> > > Does this cause a problem?
> >=20
> > Problem - no, inconvenience - yes.
> > It doesn't look pretty in git history.
>=20
> We'll catch it next time? Not worth resubmitting I don't think.

Sure, no problems.

>=20
> -Denny

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXrAgVAAoJEORje4g2clin+vIP/RTDDkBMZikU9aA3kxeVtRdd
JVOPvTlIfgWzc+zlM/TGz4Ti98Sh4/S+589Ax4rf6UReqckylU+1tH07zCOTAAbi
UOQP7A7grAHwRAnkYu6874Zrnt5K7HNV1M04oWYdULC5g22brGshP39OY3gQYmOT
EffhCyjrpUe70ZMC21IpnsVQJvlXLAAWIAfLMF7ALPEgK8hn5FZ/LlhzBkZ2lLWi
0e1e73apo7U4h7OFT48HViF1OohrZdWj3OdEoldI4oSQI6c4kMfhkJfyWWwSswtr
Mu4TY2/mtt1u53woBG0mm7QfaGgFHm5sn+NAHqlu8Vs43fiYWmCFn4ikOhtfXWUe
2NxFsxf30+d9xpvZ2ww4TS4GAgBNHPHYkYl6+wnm2C0Bm3trSFWG41sQxHyNn4l7
UT6OzxLATLAuFK8KjKGGSmnsZx7WUR6pp5c6tLWrEt6cgGdxOSb8XlqD68VDtWP9
9LoGEHsV3vl9x74i2y79H9a1tZBJmugjNnUWf+Svk1jEKi43N7tlUNjJOhRdVqth
gKUcDoR2aTISguqJ/3UQV9grCFlPkJhuymFHG/bYNCOBwrq/2B5w6bs93BhxO/RF
IPQCzTYVQy5X7787Df37iVC8OEn491GHziUVKMuMfMcaqS7LFPfdsvPLjf8SSFJB
aVGxFWK4RWEQhg2fRF0F
=GT5G
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
