From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Tue, 10 May 2016 07:41:07 +0300
Message-ID: <20160510044107.GU29160@leon.nu>
References: <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com>
 <20160504181135.GA15355@obsidianresearch.com>
 <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
 <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu>
 <20160509195734.GA22669@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AHVSF3we4xtO5oi5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160509195734.GA22669-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AHVSF3we4xtO5oi5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2016 at 01:57:34PM -0600, Jason Gunthorpe wrote:
> On Mon, May 09, 2016 at 10:16:13PM +0300, Leon Romanovsky wrote:
>=20
> > > If you want hardware knowledgeable people to help, then you need to go
> > > to the forums they are active in.
> >=20
> > It doesn't make sense to look after these people who have no interest in
> > linux RDMA at all.
>=20
> Linux RDMA is only one half of the coin - most of our uAPIs are
> backed by a hardware implementation, and thus defining a bad API
> directly limits future hardware designs. It is very foolish not to ask
> the people who are designing future hardware what they think.

Exactly, this is why it is posted on the open mailing list where
everyone has stage to express their opinion, including these mysterious
hardware architecture who cares about future design, but doesn't care about
its future support.

The intension for submitted new uAPI to be generic from the
beginning and authors are always open to adjust it to answer
reviews feedback.

--AHVSF3we4xtO5oi5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMWZjAAoJEORje4g2clindNEP/jxFo+saRHU2RjJSk6YJFF1i
Ip3SlZIB6cx0c4J77SfZvW1Mhg9e+2EOWxeae74oeFBu0/nUK3iK5SYPS9uXeW3P
RY06/D2wTY9YUMv8fc/k+gIQfCw60GM74XJ0KRvcQ7rHuUZLxspTHEztVS/NaTw2
7WYyZ2Lj4AnPqhr5VtrrIzxiCHrYyentK0Ix40acrf/XpdeOLixjOR43gU4+BfY0
DOs4MO9NA1l6z0v/6k5DgzvkWGzkjKonoweAVwEbhm7W7yvFGp3ekmNlZj4zSvpB
sHvCFfqAyUmtYZ+VxiZOb+PLChjegCSaF+1W0tVnJnT97r7FBQPrMItYwCDbUwsS
fUGFJCsft/p4p+NyN0ceeKiCdp6qWHlZpOeJ8EvFDm/bHqF60DYwqc/3ORanMTaZ
Nnzo4Fv/RVLOkLzgx89DTzVwODn1jiz4CzvTu6yTLhztRc9e3uzRaagAxZE70ih/
LXPp/5uAl+ybG4yaNQw0Jh9r9IHi9FkIN4WXnpCswluItjlG13pxzVVPsK1wOnYq
ZaprSHscwBFvBXtfuIujP1xPIcG286+IbudVtKkoZ53vpzjRoSpJNodmTRF/47Bc
F0XSoqQOrc/hp/mF5Me3pck0VSqPFdqu2sahb/nNscawdaS04Hq3qXegEgrKEMb6
eXP4ELus0HM1/xQ74YI1
=JnzE
-----END PGP SIGNATURE-----

--AHVSF3we4xtO5oi5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
