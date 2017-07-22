From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/17] lib/interval_tree: fast overlap detection
Date: Sat, 22 Jul 2017 13:52:28 -0400
Message-ID: <a1444ac4-623f-eded-83b3-76d76f2f54ce@redhat.com>
References: <20170719014603.19029-1-dave@stgolabs.net>
 <20170719014603.19029-12-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tPpekWmpr7kkH5gkk2Sjf3TieeABPMdiE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170719014603.19029-12-dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tPpekWmpr7kkH5gkk2Sjf3TieeABPMdiE
Content-Type: multipart/mixed; boundary="BuxHUqc5o9bBEhBLkCue9JHsfLBsXRnLu";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org,
 torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org,
 hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org,
 mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org,
 "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
Message-ID: <a1444ac4-623f-eded-83b3-76d76f2f54ce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/17] lib/interval_tree: fast overlap detection
References: <20170719014603.19029-1-dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
 <20170719014603.19029-12-dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
In-Reply-To: <20170719014603.19029-12-dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>

--BuxHUqc5o9bBEhBLkCue9JHsfLBsXRnLu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/18/2017 9:45 PM, Davidlohr Bueso wrote:
> Allow interval trees to quickly check for overlaps to avoid
> unnecesary tree lookups in interval_tree_iter_first().
>=20
> As of this patch, all interval tree flavors will require
> using a 'rb_root_cached' such that we can have the leftmost
> node easily available. While most users will make use of this
> feature, those with special functions (in addition to the generic
> insert, delete, search calls) will avoid using the cached
> option as they can do funky things with insertions -- for example,
> vma_interval_tree_insert_after().
>=20
> Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>
> Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Acked-by: Christian K=C3=B6nig <christian.koenig-5C7GfCeVMHo@public.gmane.org>
> Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Signed-off-by: Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>

Ack for the RDMA parts.

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--BuxHUqc5o9bBEhBLkCue9JHsfLBsXRnLu--

--tPpekWmpr7kkH5gkk2Sjf3TieeABPMdiE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc5DcAAoJELgmozMOVy/d4QcQAIVqBiz4a3fMzDQcal1TUMnD
Te3eTAxeQ3oEShJ1959ezAJnB1iIzPSBHySsB546dQ8ZJqFgqHOrWqfG9LqqagFP
9+zZj2e5Igv8ukEEs+U+1MUZ1XWpDRsGgxv9Q8H5piOhjsSU7TyP6h9hb/IdNcFj
4+1Q4xWG8wexsls14p3iUbgCnGy1df6oOSAtaQXyxVjHTutQ5cYNuEFX03HqvUVz
lxVNHlQDIUGe1Hz1NvEzdE1+4Hbp/RAQpEKlxg+/tVL+Ywxx7mJao18RDJKI7QOX
wLWskWuLzKzGspPBd1fQXrHMqdbrhZkq1KrKlEswPIXxmcielYbNOpvncI4SLFm+
fJkWBjdWOYkBMDyKx+q+PsH/xejsgiouGz2zDP5whTnunTMtBjJX5hfac4azXvF0
X02pMgqkgvz7Oz4QdjzEWXcpt4XM8JCU+12woC2ByfXFF26FaKd96Jr8SmoptKAU
Mqv++JEQaWFq+F97wRgt33H113U3EswKxMnqT7AJNew5/dPdgXJZ0HV+4PXFINAr
ynG3I2uurLHMTkbhUl5iPx801mG92XD6mlDlkm3rrRNo6u3tjdDk7vxQrcHWHK/R
TGDQ34tStoHQeAVPQ6uUk7AnlwYTrhs9cjyI5Ww/wMdrGmmhkaNXtjIAnCSBhu4D
asBFOy8pRpCt9azXAJ8i
=RKEy
-----END PGP SIGNATURE-----

--tPpekWmpr7kkH5gkk2Sjf3TieeABPMdiE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
