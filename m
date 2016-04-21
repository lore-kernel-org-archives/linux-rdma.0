From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared Topic Branch For ABI Changes
Date: Thu, 21 Apr 2016 09:49:59 +0300
Message-ID: <20160421064959.GB12730@leon.nu>
References: <20160420055221.GT6349@leon.nu>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420055221.GT6349-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 08:52:21AM +0300, Leon Romanovsky wrote:
> Hi,
>=20
> Following the discussions at OFVWG (4/19/2016), I want to present
> shared repository and topic branch for ABI change proposed patches.
>=20
> Please post them on linux-rdma mailing list with clear indication that
> it is supposed for ABI related work.
>=20
> I would like to suggest to use [PATCH ABI xxx] notation, so it will be
> easy for me to take them and don't mix with general RDMA development.
>=20
> Kernel part git address:
>  * git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>  * https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/
>=20
> Branch name:
>  * topic/abi
>=20
> The supplementary user space (libibverbs) repository will be set a
> little bit later.

Libibverbs:
 * git://git.kernel.org/pub/scm/libs/leon/libibverbs.git
 * https://git.kernel.org/cgit/libs/leon/libibverbs.git/

Branch name:
 * topic/abi

>=20
> Thanks



--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGHgXAAoJEORje4g2clinlDwQAKC6fm7SfU6QEAz58bmSkRSp
leNsZpFnEL8zILCExRlsskduLB5hU9aWGsE0yJpvPyA2uluOmoA8EvsaUJAwUQk7
BGMKi6U1A3IRFkTMfQgY8LdfbYpvv9U4Zh2vyTqeHlpXS55gZTGPUGC9UEzPiF59
ZVzt4PRzYAWPAI9w8d8TErq69nT1157cVaOyZ+kO3AOv0CoPtAHdjobu5vwKLJ1P
wfnOCxC2Kfd3WiZ2yaLOMzTi6cPzcRy1xe2INKPK8XZAmblW6WtN2UMo3UkfgY+J
0smrtPsWW5bwqnTSzdrMxEuflbFyZwmVYm16Hal1RrgyAE69i1RCxkqt5CU1D7UT
eifwWsMXLCy15Zi3BQS4AdzCqMlB9vlJbz510Db45tf9Fhw9kBOvcb/CzlBugRZo
prqTdoJjPVFXzKSVmzT2/apA5XJUxt+vEhVIlNgELfbGIe9wJ7HcY+iYiqPF9Wkq
IeT4X9laRfWYcQWZyCeCazDAxVuqpO/pRZmqNphfdP89hQ3MjyuGu5+dtK0p5jZu
9of4gu2lcfuNZR+1aG+RFT1Wdc574Go0af43UlXvHv5546mvLKt7L++YYixWCsHw
iyGlt+5kwHTBLpEfZPQ1QCr441bRD7+fBh9jWV60D51tPz2zmApy5hOIv/9e2exz
d4vQDNHfPXHwJmNtcN/S
=5Ozp
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
