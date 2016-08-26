From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Fri, 26 Aug 2016 22:29:57 +0300
Message-ID: <20160826192957.GG594@leon.nu>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
 <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 26, 2016 at 02:01:55PM -0400, Doug Ledford wrote:
> On 8/26/2016 9:35 AM, Doug Ledford wrote:
> > On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
> >> The 2nd parameter of 'find_first_bit' is the number of bits to search.
> >> In this case, we are passing 'sizeof(unsigned long)' which is likely to
> >> be 4 or 8.
> >
> > If the size can be 4 or 8, then using 64 universally is not correct.
> > Why not use sizeof() * 8 (or << 3)?
>
> Better yet, why not put this patch in the kernel first:
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d96a6118d26a..a8838c87668e 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -52,6 +52,8 @@
>
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> __must_be_array(arr))
>
> +#define bitsizeof(x)   (sizeof((x)) << 3)
> +
>  #define u64_to_user_ptr(x) (           \
>  {                                      \
>         typecheck(u64, x);              \
>
> then start going around replacing all these hard coded numbers with the
> use of bitsizeof().  It can be applied not just to the find_first*bit()
> routines, but to a bunch of other routines too.  Just look at
> include/linux/bitmap.h and any that have nbits as an argument are
> candidates.

There is BITS_PER_LONG define for that. There is actual use of it in mlx5 for
the similar code pieces.

>
>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG Key ID: 0E572FDD
>




--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwJi1AAoJEORje4g2clincZAP/0IZANwKzth4vm/z2+ESCJoW
XExgB4gOD/2C5+pKK+pN+pPVQ/H9hOM0WgposCfWhKgKbkubM+Q8Vh1IuV0j4YII
zuki+eyki2jKup8vsd+8ldpXXoNiGlWYjkXQf4QhYrNtRlzRbJLzIoU8r0pjSQx8
QOc7wp9BjZKMeeK1RlbAcPK0KqrkaPbqOhCxlm0b9Yl0Thn5kMHdX0nj3RjKdgJF
3KC6U8QZ2lBgYoR9DaOJK/292MkzsJDdHU5CAtAYdKDl1cQWE4LutpEaMVDsVb+3
5L4RgtffHmoak5m2tu1lAAmZaSMe+0GfAWl227Q4UtrJ19XRMM/feOLrStISTORU
jnql9Pm8EHQRh+pKWDlq/VnCldyAEascVkGNbUOWcZPedxz4n4B4eywhkTW+afHN
4uNO+6Ul+cKXjWzG5gP1wvvuwZCkIHyXct1VL4+W8NMDRfc8ETYdVcIhRe24A270
KRPW9x8yM9Da8V3P3Vrk7R1M2M3mureCUreRNqIeQORpxW5dk8dJ5BZ32ltbSUTi
8KSMSyRB6oao9H03Q4yETIZOE0uHHf5gTfpIwAYe+uKN+2KBSRuO1o1qmjMXK21t
3sENv+cPoYwz4k1vQbVcdTYxsjat8GdltDLjt3HPV7QFC7HS2MUOWzs5JTutsOYh
k3r5BSJz62S1NnDC+ZRI
=Yt+2
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
