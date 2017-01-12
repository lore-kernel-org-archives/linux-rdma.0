From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Thu, 12 Jan 2017 16:58:28 -0500
Message-ID: <1484258308.123135.41.camel@redhat.com>
References: <20161228124728.26619-1-leon@kernel.org>
         <20161228124728.26619-2-leon@kernel.org>
         <1484246776.123135.19.camel@redhat.com>
         <20170112193508.GO20392@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-G/ksafZydDOux4F7le34"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112193508.GO20392-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-G/ksafZydDOux4F7le34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-12 at 21:35 +0200, Leon Romanovsky wrote:
>=C2=A0
> First of all, thank you for fixing wording, for me it is the hardest
> part of every commit.

No worries.

> Second, I have a different view from you on the issue. User
> configured
> some value, which is not correct for IPoIB. In ideal world (without
> legacy),
> we were supposed to return error to him with proper message,

If you set an impossible MTU on an ethernet adapter, you get a return
of EINVAL. =C2=A0But it doesn't mess with the kernel log at all, it's *just=
*
EINVAL to the calling program.

>  but in our
> case (legacy applications) we can't (we tried and it broke some
> legacy
> ifcongfig, if I remember well).

ifconfig is what I used to test what Ethernet does, so it should be
well and truly used to EINVAL as a return.

>  So it leaves us with one available
> option is to warn user about improper value.

Even if you want to alert the user, there is no need to warn. =C2=A0Warn is
reserved for something that is a serious error or condition, this is an
EINVAL of something that is, at best, a performance issue. =C2=A0Unless pat=
h
MTU support is broken, failing to set a larger MTU will not ever hinder
actual operation. =C2=A0So we should never be dumping out KERN_WARN message=
s
into the kernel log that will ping up on any root login session as well
as clutter the kernel dmesg output.

> User should know that he supplied wrong parameter.

User can still find out, they just won't get proactive pings on all
root sessions, instead they will have to look in the dmesg output
because they are trying to figure out why their command didn't work.

> >=20
> >=20
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > =C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
> > =C2=A0 =C2=A0
> > Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57
> > 2FDD
>=20
>=20
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-G/ksafZydDOux4F7le34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd/wEAAoJELgmozMOVy/drOwP+wdIf5mZULxEsrOKSJTsKAoL
JGwR5lLTPxa5J93sCn1OtY/WUwnFVkwngLjhua0sv0ceiIaOz4+tESkFWvIMRJ0k
H/KaIWQFOVPJPR91X2ruqfTCnQbR18saPZuXnw+qj/1RRz7x8kgYgWkvUAKHWGue
549X7uwUToqEtyejjVvQnVZEW3xIBzNuKTqzlKCiES7OWNoFcMQqbwboCyMKsBoz
C3+BXNSTpN/3vM2n4TLDKK0OJoq82tXLCABVW1JEbsN9ndvpvAkipmczVbjrbh8x
8XE4juI51vpRteZXeeNWMWYay7oNjTnGznnUm5kvqUg51NsO5bQrMWl/4jEAgLaG
sSADxzefOJ1eQdP942sWtlzQaGmujgusOKjPBm3ZkBXR2EcFc/WYuWvDVKwPKC/s
Jn9NmxySC/suzpQ5T3AdoFYRdqY9nVPYBHDGEBFYMlN+8s3hvqU2dvm8/9J016aH
7/hZmMcDnEbe7QwhShopEC83Drx77HOpIxdufpzbJGyhOjefLTlj58vYOsgQtRZK
INHf2vqnUmUZWMN9M8Vbj+y6L2IHipoxNGvef007dgwDujUC5+sdH8iSI3xlWNv7
KrTs8M2gVsaSUfXSaradKRUXvRAR7hHF74nFeZ8QzZQee+J3aexNjxr/cX4XGlL4
jzzIdjtICpCzx9CigzLd
=tc4x
-----END PGP SIGNATURE-----

--=-G/ksafZydDOux4F7le34--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
