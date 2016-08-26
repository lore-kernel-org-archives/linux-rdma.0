From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Fri, 26 Aug 2016 14:01:55 -0400
Message-ID: <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="drk5EFA0mrFinOWFkvUl6vqeS04Jw7s2G"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--drk5EFA0mrFinOWFkvUl6vqeS04Jw7s2G
Content-Type: multipart/mixed; boundary="ebJruRaJ823Mfx6cs9OOcWhbWuKcHfJe7"
From: Doug Ledford <dledford@redhat.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
 sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
In-Reply-To: <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>

--ebJruRaJ823Mfx6cs9OOcWhbWuKcHfJe7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/26/2016 9:35 AM, Doug Ledford wrote:
> On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
>> The 2nd parameter of 'find_first_bit' is the number of bits to search.=

>> In this case, we are passing 'sizeof(unsigned long)' which is likely t=
o
>> be 4 or 8.
>=20
> If the size can be 4 or 8, then using 64 universally is not correct.
> Why not use sizeof() * 8 (or << 3)?

Better yet, why not put this patch in the kernel first:

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d96a6118d26a..a8838c87668e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -52,6 +52,8 @@

 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
__must_be_array(arr))

+#define bitsizeof(x)   (sizeof((x)) << 3)
+
 #define u64_to_user_ptr(x) (           \
 {                                      \
        typecheck(u64, x);              \

then start going around replacing all these hard coded numbers with the
use of bitsizeof().  It can be applied not just to the find_first*bit()
routines, but to a bunch of other routines too.  Just look at
include/linux/bitmap.h and any that have nbits as an argument are
candidates.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--ebJruRaJ823Mfx6cs9OOcWhbWuKcHfJe7--

--drk5EFA0mrFinOWFkvUl6vqeS04Jw7s2G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXwIQTAAoJELgmozMOVy/dqTYQAJHv5tUhZtZOsSziCJwGpIpD
eUDwg0bLGPRwOfTJML3JnizywSoDGwG2kHLp1nGHUbQcIeQ6lnn0bWfhkAvkcPpK
HXAZpInBG5WcKAvHtZDWVr87bbN6t1X1O29aV8CJSJgf+Aw+juxQ0kkpVnV3YRKp
SKtDM+bbD22R6WQJxmMIFAGdP+hjjr0ZspiYadrUvGmXSpvs8F250dBdtCn8fEuL
P5w+YpwL3YJMBCLjsRt6JcyMOi6rL83lxnt/ByGY/dT8owDBMv95yaGGFGJg0B6q
4ZhqGHhTJ7vrKf+gIOL2kMkgCdBzt2Xghtce5SeHebFSMe4mU/8jEgwXRUZtPgMa
VqRlKYxDfUHkRVZYrZrdBM0WyEB9ZoqJhKmr+hxzUSKDh8jrlb4cMfWknO4nKP6X
lMSjdwUEWLuW2CSKFVwBYu5kw9abol7p/BJwv6gAvlYBIftHAckrloTInGMIMxnu
HWD38vvIU7jOQo4DgJ8LAgPGD8hbhtIdXWvXDVGzPof0JB3xxrHAZk7B2R+As7zg
KxPv6xxEiKfIa0iWcknwH30CIqU0oFl45+m0Pykry4VwRpO1uyZfFpMvnDH/aHxv
b0TkY1pexkkvMM7CV/4smpl9Cj8I0aqqHbWNYYER278FWM3t5obBCp47LiIUvUG8
S7356P0EC+3AKcDuEUrn
=gSrx
-----END PGP SIGNATURE-----

--drk5EFA0mrFinOWFkvUl6vqeS04Jw7s2G--
