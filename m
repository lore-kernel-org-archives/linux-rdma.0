From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix a race condition in iboe_addr_get_sgid()
Date: Thu, 22 Dec 2016 11:40:08 -0500
Message-ID: <803b4ba0-09af-24d9-790c-7e496b1a65c9@redhat.com>
References: <75d773f7-d8f2-a77d-6c7a-4991d71f0c9f@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8blmUfxW17ILxrNG5caietH3cSwwSOK2U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75d773f7-d8f2-a77d-6c7a-4991d71f0c9f-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8blmUfxW17ILxrNG5caietH3cSwwSOK2U
Content-Type: multipart/mixed; boundary="TarxWjUAFRItdIm974MnsQp7Egspqll32";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <803b4ba0-09af-24d9-790c-7e496b1a65c9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix a race condition in iboe_addr_get_sgid()
References: <75d773f7-d8f2-a77d-6c7a-4991d71f0c9f-HInyCGIudOg@public.gmane.org>
In-Reply-To: <75d773f7-d8f2-a77d-6c7a-4991d71f0c9f-HInyCGIudOg@public.gmane.org>

--TarxWjUAFRItdIm974MnsQp7Egspqll32
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/19/2016 12:00 PM, Bart Van Assche wrote:
> From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>=20
> Code that dereferences the struct net_device ip_ptr member must be
> protected with an in_dev_get() / in_dev_put() pair. Hence insert
> calls to these functions.
>=20
> Fixes: commit 7b85627b9f02 ("IB/cma: IBoE (RoCE) IP-based GID addressin=
g")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--TarxWjUAFRItdIm974MnsQp7Egspqll32--

--8blmUfxW17ILxrNG5caietH3cSwwSOK2U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXAHoAAoJELgmozMOVy/dtzMP/1ZUMhNX33lJN7DwV+7ZPklj
7325xxzjl0Rf/eRPTH0FXM5TBWvHINanZEmSCNGqcNeQKbMxsp88bsDvVmLck31Z
BAqbFUizV2XF9ceUbJKjQofwxqZEGd5jOkcINsWODYK6aRHUACjTenNWa//tISTU
SulAEOpkQLBquzPiKbDQQu4ZF5qlSyG/FHK3AqymlEz3QF7OwQcwnwIEdaDKzU1c
E+eBR6pJACsIT499zZu0NhBm84+AmBngB67HVkFaXDfBmeTMZC1CXYrbqaBVNyWE
j64gAhccFPa9TqGx33y/KgV8NVf2ITNo9zqyrxCR/I+9ft+G6bMUFRteg/1dnfl2
5kmyXgggMaXNUqY6bPIRpP0MW8jXC6/JzYUg511/NGAAzHTbQgcMAbe22sXxfBAl
i3cWysuqbFZfyGwQ4KHrWvHEBouJ/pBRnfcNHADcHARdqMLAPl1X0cCCoOxiZCjN
iyc1/dDPfc1GW0VsmjI4MWAL4Amq/kzbyoYGJZ6zQR/r8r+gr8QvS9g8dJOZFes0
jaDni/XFC9nl+SuS1I46Mnwx9oafMXGnyv4M0zCGVzqX+l0FBqKgcTXsNt1c4f+3
Aa17/0mBi0XLD27zSaDlvzGvMPiAca9eEiEf7HYvgNh15ACywbP0LgXp4prdGUxe
Z1Y7a/Hr6m3vTDOI/fVh
=ji5j
-----END PGP SIGNATURE-----

--8blmUfxW17ILxrNG5caietH3cSwwSOK2U--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
