From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 10 Jun 2015 15:59:38 -0400
Message-ID: <1433966378.71666.44.camel@redhat.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
	 <1433615915-24591-15-git-send-email-ira.weiny@intel.com>
	 <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>
	 <1433961446.71666.26.camel@redhat.com>
	 <20150610185653.GA28153@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-cBX9jZ9JR83oeg8uffC8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150610185653.GA28153-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-cBX9jZ9JR83oeg8uffC8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 12:56 -0600, Jason Gunthorpe wrote:
> On Wed, Jun 10, 2015 at 02:37:26PM -0400, Doug Ledford wrote:
> > On Wed, 2015-06-10 at 06:30 +0000, Liran Liss wrote:
> > > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >=20
> > > Hi Ira,
> > >=20
> > > OPA cannot impersonate IB; OPA node and link types have to be
> > > designated as such.  In terms of MAD processing flows, both
> > > explicit (as in the handle_opa_smi() call below) and implicit code
> > > paths (which share IB flows - there are several cases) must make
> > > this distinction.
> >=20
> > As far as in the kernel is concerned, the individual capability bits
> > are much more important.  I would actually like to do away with the
> > node_type variable from struct ib_device eventually.  As for user
> > space,
>=20
> All SMI code has different behavior if it is running on a switch or
> HCA, so testing for 'switchyness' is very appropriate here.

Sure...

> cap_is_switch_smi would be a nice refinement to let us drop nodetype.

Exactly, we need a bit added to the immutable data bits, and a new cap_
helper, and then nodetype is ready to be retired.  Add a bit, drop a
u8 ;-)

> I don't have a problem with sharing the IBA constant names for MAD
> structures (like RDMA_NODE_IB_SWITCH) between IB and OPA code. They
> already share the structure layouts/etc.
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-cBX9jZ9JR83oeg8uffC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeJcqAAoJELgmozMOVy/dTesP/j6ttiZYdKSLYpzm+OLC8DRM
eAlmmjXVNR6avo6s/oIlftLn9ZOebxt21pxaGr97iHBY1gQ5LN5uXA8Z+ahaurWL
dz3aG/ljMbfp/3QnsoFlzyT9MBj6V9cUQSxGtHtDoAIi9NR2T6tWlDa4WSz1IcLi
vq7ZGPrAYaR/Ehqxb2/OIOV2hVFEmRut4turs+ZGpGYvkT5fwCTlcLeFUL7lyogZ
vDWqCv01n6N4ojeb5HAmURePsC4Qkesj4RpwkOz9prdbzYFQ8kfFutNpjyZJAl/5
46/8lljxmOHFuA3bFV+3MOZHMw7SB1YhZHD2FiL4MxVTz4an4FcFuI0FBi2OPiYp
arhKrGFW3KkP1BY7dFkn2H/xvpv1vsGZI9BmJ4+ZbukDJ0J5C0LMA2LK+SX+Q4Vu
7mirzlPCTsVhHPGYYN8NIf5JylpjZt0okbzPS3E2x437zE54KznAdTwmOz29sdvk
nkOWl/wl4TT8fjZYj1wUsZNmWp/zcYdh4lp5iG8xCO3ejg701JDgmx7VvrPND1X6
txg9sAHFXCScRG66Lre07pYAWq7Gax98oQMLKRXJT4PHrYhnLlyjWVnLIdofQktU
GbBl6LAYZIv6C0Fh5RhdJR+kg3xZ+aUXMor1ePZ3+mfCsO3u+40+NQ5LE7jBo7ud
jAGIPx8jkA/+LX/NwNZF
=IzFN
-----END PGP SIGNATURE-----

--=-cBX9jZ9JR83oeg8uffC8--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
