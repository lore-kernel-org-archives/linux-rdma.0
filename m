From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 26 Aug 2016 12:12:07 -0400
Message-ID: <3aee5577-9600-db32-db7f-4fb39afdc429@redhat.com>
References: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1@redhat.com>
 <20160826144415.GC594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lwPH4BDfEwfbTOx2XvhJSjxqafAURMOjp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160826144415.GC594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lwPH4BDfEwfbTOx2XvhJSjxqafAURMOjp
Content-Type: multipart/mixed; boundary="78L9fV53F0NO3NhSPJcJhk9JDCPSI2eJs"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <3aee5577-9600-db32-db7f-4fb39afdc429-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160826144415.GC594-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160826144415.GC594-2ukJVAZIZ/Y@public.gmane.org>

--78L9fV53F0NO3NhSPJcJhk9JDCPSI2eJs
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/26/2016 10:44 AM, Leon Romanovsky wrote:
> On Thu, Aug 25, 2016 at 03:29:12PM -0400, Doug Ledford wrote:
>=20
> Hi Doug,
>=20
> These two patches were supposed to be carried by us [1] and I explicitl=
y
> said that. Especially, the last patch in this series is wrong. Please
> revert it. The proper patch is [2] and it was supposed to be sent right=

> after our shared code.
>=20
>> Yuval Shaia (2):
>>       IB/mlx4: Make function use_tunnel_data return void
>>       IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
>=20
> [1] https://www.spinics.net/lists/linux-rdma/msg38580.html
> [2]
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/commit=
/?h=3Dtopic/mlx-fixes&id=3Dd5a1c56c3a49db6369b36aa04fbeabc7653ae107
>=20

I saw your request to carry it, but then never heard anything again from
you.  The fix that the original patch implements is still valid and was
something I wanted to get into 4.8, where as your patch is being held
for 4.9 and goes down a different path to solving the issue.  IMO, the
patch from Yuval is fine for 4.8, and if you want to apply yours to 4.9,
that's fine too.  I don't see a need to revert the existing patch.  From
what I can tell, the existing patch will work fine and do what Yuval
intended, it just won't do what you intend to do in 4.9.  Please correct
me if I'm wrong.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--78L9fV53F0NO3NhSPJcJhk9JDCPSI2eJs--

--lwPH4BDfEwfbTOx2XvhJSjxqafAURMOjp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXwGpXAAoJELgmozMOVy/dumkP+wTHMPr4ZIg+KLF4RirjEshc
4tukxdQziUIycVGIXtNA3wCeTCbck5VzcpUVSzMwoVko0cYwbEqMDl8xmciOVAuT
ttkrCUJ2hs6126KJSCMLasxGgjJVRV1PiyOhxWmQ1/A+/f5haRaSLHU2egA1vS+3
01qsz3/PvxuXO8oDUflgba3lq5+YtE7QdwJo7LdPDI3XbFYtSNls+dKtIBBWsGlO
vjZQ++F/eRR3bMKJPjcs8OK9FbGYFjuNyYPPa2IjrAvSWIPApOrckIkqhIWX1CQl
KOYLg2rp32hDYcJjBXlDHlehCN6+lWqXUJnGygNG+tAhcpj+DKhLYNPdjVuKmB4r
Gccs179fFXaBEdV58VbBn4q+fpQdJFJbB/cg8rQdGXETmZth2UftBvNiEg2Lg+Ik
qti+tcvt9cX9L2DFC0W6ozyUmB9CDLrzN0uPKrg43hwKe8VnRmo6FvhnIhleHwvI
X4cqLPN/jbdFs3h7jl9rxFDWY9UKOogQpO2viBoJUXpZFN3KdQY93QD7rgGkAWMY
nPkQQ0jJCQ2CwSK1Tsi72zQyEgjKuGAet3wew+feq/hpShQYKQ5tYo/3fURSswL3
2WXmi71h6nAMAdySoVL7Dp+2sk0vvoKC/aHITzhJFYk/RpbG0u1670d4d2+x0ZPl
3R4BWgKJRW5n2gxW2YV9
=/bLQ
-----END PGP SIGNATURE-----

--lwPH4BDfEwfbTOx2XvhJSjxqafAURMOjp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
