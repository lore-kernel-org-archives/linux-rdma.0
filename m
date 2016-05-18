From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Wed, 18 May 2016 10:51:02 -0400
Message-ID: <0558d12b-2646-63b4-89f8-9bf4aba689db@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <VI1PR05MB13915036338162B126E55CC2D2480@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <eea7049c-5a27-1498-8e8b-674d69468fbb@redhat.com>
 <VI1PR05MB13910C6D09E0B6B9D477B1EAD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <d54c2884-c2e9-8952-75f8-43147943640c@redhat.com>
 <VI1PR05MB1391C3E551DDAEA3ABFE71FFD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rXXUDx4tQsJ23vf46ntm5oRqgBmmCBGjS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB1391C3E551DDAEA3ABFE71FFD2490-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rXXUDx4tQsJ23vf46ntm5oRqgBmmCBGjS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 10:26 AM, Mark Bloch wrote:
>=20
>=20
>> -----Original Message-----
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>> Sent: Wednesday, May 18, 2016 5:17 PM
>> To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
>> resolution module into core
>>
> [snip]
>> Unless you went back to your original first patch set where ib_netlink=

>> was a separate module, then the load order could be ib_netlink ->
>> ib_addr -> ib_core and things would work.  Possibly.  Depends on wheth=
er
>> the ib_netlink module has anything in it that references symbols in ib=
_core.
> Yes, the first version did just that and worked, but then there were
> comments that we have too many modules and I shouldn't add another one.=

>=20
> V0 adds a new kernel module (ib_netlink.ko ) but leaves ib_core and ib_=
addr
> modules unchanged. I also have a version with Leon's patch
> that eliminates ib_addr.ko and doesn't add a new module.
>=20
> Would you like me to submit  a new version (with Leon's patch) or the r=
eview can continue with V0?

One of the things that has come about as a result of this conversation
is that EL6 is the only distro to provide the reload capability.  I have
the ability to make sure it gets updated to account for the module
change, so let's move forward with a version that removes ib_addr and
moves it into the ib_core and also keep the new ib_netlink stuff in
ib_core.  So, fewer modules, not more.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rXXUDx4tQsJ23vf46ntm5oRqgBmmCBGjS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPIFWAAoJELgmozMOVy/d1zUP/j/2Z3bb0eAeY+Egrx5sS05K
QgaDbh/Nda1iHRfuouFnOWPU0LyJdBlKM+eLsyyGRlLnIRDnpi8VcXB+X5zJxufJ
6Os4aiiTH6KmJ+gDPVN/hFJkro4t338l/LAGmZpgLyHEqu+6JCFL55S9TITRI+u3
XRbhnh58XgEXdxVicJGfYVZ0Vc1D9JcslpmgazQEsqbiWtl5rvo6UmiuArrOAYIn
qF2pycJp/3DnokuAvWnKNrLI3ssNoXRBJRz5ughNqSVmQnqYmSFyeehTaPnGx3AW
dfxIspKKDXvHZ4jnZOWMBfaoD6MA5rGXTChgEbwOnwJc1EH4GDz+F76MGuv6wHR3
TQCDNxC0ysAiqwXBZxaWtbHai1PyeEQnhNNNASzxJ4/FzdamwyjYD4zF07pWEJmg
4HTEOWiR0vyLSxac7zHpPZFYO7m6Qy+6pURhfrzNyCTKirCVXYEtL61Q85S01f+c
EsY9RVPN1l6OxlTdppkSzOdWOlyyi9u8DqxiuxSF3zuLxFHPwBXrc7h37qk+zyjU
A8MB962CwZt7IJ+muifuew8u6jG2mEFAKXGJ5+rIYMYtZvxVRs2v7cGZmxfkkK9Y
Y718qoPlbKUcXT9I3fa2h16l76T308M5nQW4DYkGJclJIV4hHRBTVFGZil8xBW5w
Qs5+Ty7YKLlps0uLYcuy
=ciJO
-----END PGP SIGNATURE-----

--rXXUDx4tQsJ23vf46ntm5oRqgBmmCBGjS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
