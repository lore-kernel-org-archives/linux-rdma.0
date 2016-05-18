From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Wed, 18 May 2016 13:58:41 -0400
Message-ID: <fe88d9cc-3d03-030d-c4c9-360ef0ce7067@redhat.com>
References: <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <VI1PR05MB13915036338162B126E55CC2D2480@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <eea7049c-5a27-1498-8e8b-674d69468fbb@redhat.com>
 <VI1PR05MB13910C6D09E0B6B9D477B1EAD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <d54c2884-c2e9-8952-75f8-43147943640c@redhat.com>
 <VI1PR05MB1391C3E551DDAEA3ABFE71FFD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <0558d12b-2646-63b4-89f8-9bf4aba689db@redhat.com>
 <20160518171536.GB15170@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7ijVnKSjsicPw1Ql43kWWGwnwCfNq6TeC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160518171536.GB15170-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7ijVnKSjsicPw1Ql43kWWGwnwCfNq6TeC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 01:15 PM, Jason Gunthorpe wrote:
> On Wed, May 18, 2016 at 10:51:02AM -0400, Doug Ledford wrote:
>> moves it into the ib_core and also keep the new ib_netlink stuff in
>> ib_core.  So, fewer modules, not more.
>=20
> What about getting rid of ib_sa as well so we can avoid that dynamic
> netlink registration patch too?

That's fine too.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7ijVnKSjsicPw1Ql43kWWGwnwCfNq6TeC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPK1RAAoJELgmozMOVy/de44QAJdtsz6BbPSN+uBz0gZRNCCO
qn93BMynG3GNGa9M9JME4cIIT3i5fwx8uMCrOW/MNXzy5MgKzAhaJy2Sb7gDX/f9
SfnmmlUY7QujzAUhAYLC5rubQpsHmZzpp1LPdMoGwSEXydG5KnACNQVeWmKLJmwm
IZ0vSO1e46qjm76ScuTKIcRXa4F7gOMwLI1GKuJvOk05Dma1EyrWLwTF4rib7pTv
T2xxDh+OHtQieWtNEY25z7sIpWHVJOWHF+JObSMfvsNoBqJZoLAyjOGLIfL0jWzf
UsFYtFJL1PLLSqA9jOargsVLiJwUKT0O+Be7ABRvrpWSvv9z406/Mh+TWwABvBAC
U4mLBMrkm0+z9GCaagHeHZIkECGAHV+3tib01yiNRrUNebMRMXgcRFnqg/3glhlh
W93pXFQdzyu+i/PZcAsiNkGjWaibZj1y4ZK+hvRTIko0D2QBrbSX8mEiXSlYeq6W
5RzvzLtbwUHMx6AF4g9lfLtyJwCCcp6sMxOtz/K5p+nJ4ZdG7mXPewfcy6lQ/JvO
4rjM8insLSikYf9s445TEXkto9Rmw/sc2khrIkEgnaEIeOjrRMHk5PxHlMl6HxTF
/8sX9eKD6fv2YEgoRc0kcNzyoLyzwzwyidsFUYVwGCe5+bVXN85s6LJic4gghyeX
zhZ9Ia/eChdanfpnQ1+4
=B6BP
-----END PGP SIGNATURE-----

--7ijVnKSjsicPw1Ql43kWWGwnwCfNq6TeC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
