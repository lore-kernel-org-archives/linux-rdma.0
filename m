From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 16 Jul 2015 08:50:00 -0400
Message-ID: <55A7A878.1090704@redhat.com>
References: <55A56640.2000206@redhat.com> <CA+55aFzdE94JcGT3aF0+rp-ym6UdMCAcQD2LSCBeedv9dLRfhQ@mail.gmail.com> <20150716075542.GA9093@infradead.org> <55A7A6CD.4080900@redhat.com> <20150716124507.GA5943@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tusev2AAseaojpXeOBSEJ0k6hIeNF2aGG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150716124507.GA5943-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tusev2AAseaojpXeOBSEJ0k6hIeNF2aGG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/16/2015 08:45 AM, Christoph Hellwig wrote:
> Hi Doug,
>=20
> the point is that there is no driver that even set the is_switch
> flag in-tree and I can't find a publicly available one elsewhere
> either.

Try looking on Mellanox.com for their source code.  I know they use
upstream linux kernels as the base for their switch OS and in their
switch-X driver it should set this flag.

However, this is a point that I don't really care about, but I inherited
(and I know other people care about).  This code has supported switches
via out-of-tree drivers since as long as I know.  That was an early
decision that Roland made.  Removing this code is more than just
removing this code, it is reversing that decision.

> So it's plain and simple dead code.  I'll send a patch to kill this
> untestable code off once I find a little spare time.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--tusev2AAseaojpXeOBSEJ0k6hIeNF2aGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVp6h4AAoJELgmozMOVy/disYP/2JDphh/KK1Hp5pCBvuKRp8Z
l5j/9srzwAgk1MUmnv7dcp2vBwsz7nabXjsUtyEk6UEzHvNkguGgGIPY/B5bgt/J
034SSR6VkLAHQ7RhdhCz/E8ungEDHSNlAtge/L3M033bzK/56viTW0wlGeUuXeSI
o2Z0krQPHlCgPRH0DL/RBC5T0f258uSSz4FxDOqUmYWOyYUIxsVI9l4EkTXR7Dwn
MLsnkdSKyh4l1+MkAZPt0G5sQO6axBzCcMXchES91JiyAveINIqxrRRtAq4/RJcV
yJyOCtTalOxolX4Nzl6UKtSFVSWBg1nr9JwUNKqohx0PtvVKsHp9XWxNt2F6dXEe
IrkxZY/frp3mjiMpF9wRijAdBYHF5fo3v5gClnQ/GyCmswHNGi1zjCaV+ZNe9UWO
Rdp0E7/H8AOPa1TCqxSJNqcvKA55ey6GUbOJ4v2N7cHM+Zgemu1V0DSVCEt76MAl
CUP4VZekpK5sUieTHCci3Ny1B9wPUCEjInYFDvGvUA5Lau647+g02jtKEmHX0L/P
FreNpD7zbuBmZq8DohB7qkHEk5A4wbsjZkANXuCX89BZmRjuRZK9vx6LRCJEsokV
AiKM+scx71ZmgOHu4icab42aHtoxb5lF2ZRa/kGtKB50MWQe1IoKD575PzK2P6Q/
1Wwt56l2Kz3nSuivxxLN
=gsCt
-----END PGP SIGNATURE-----

--tusev2AAseaojpXeOBSEJ0k6hIeNF2aGG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
