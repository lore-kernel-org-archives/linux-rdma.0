From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Send last streaming mode message for loopback
 connections
Date: Thu, 25 Aug 2016 11:16:29 -0400
Message-ID: <e781df3a-cab2-393d-aa52-a96276a89d2b@redhat.com>
References: <1472065157-56936-1-git-send-email-shiraz.saleem@intel.com>
 <20160825034600.GB594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="w7U90d4aTNRvuKikfQE7KlPFbuP9bWW57"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160825034600.GB594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w7U90d4aTNRvuKikfQE7KlPFbuP9bWW57
Content-Type: multipart/mixed; boundary="DJrWbENis4iFbHHUjcOtm4LH0mU9K2S3X"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <e781df3a-cab2-393d-aa52-a96276a89d2b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Send last streaming mode message for loopback
 connections
References: <1472065157-56936-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20160825034600.GB594-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160825034600.GB594-2ukJVAZIZ/Y@public.gmane.org>

--DJrWbENis4iFbHHUjcOtm4LH0mU9K2S3X
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/24/2016 11:46 PM, Leon Romanovsky wrote:
> On Wed, Aug 24, 2016 at 01:59:17PM -0500, Shiraz Saleem wrote:
>> From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Send a zero length last streaming mode message for loopback
>> connections to synchronize between accepting QP and connecting QP.
>> This avoids data transfer to start on the accepting QP before
>> the connecting QP is in RTS. Also remove function i40iw_loopback_nop()=

>> as it is no longer used.
>>
>> Fixes: f27b4746f378 ("i40iw: add connection management code")
>>
>=20
> Hi Shiraz,
> It will be great if avoid the empty line between Fixes and tags for fut=
ure submissions.
> Thanks

That's a matter of opinion.  I actually prefer the extra line myself.
Anyway, applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--DJrWbENis4iFbHHUjcOtm4LH0mU9K2S3X--

--w7U90d4aTNRvuKikfQE7KlPFbuP9bWW57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvwvNAAoJELgmozMOVy/dJ7UP/0Cccr8Psq1baEEjJbpvEDVq
cZCxwFbE6d2MRqsChsM/C8LOcaaIkA1ozG6reeFQvlCBpPmc0SfI7kHVgM6czNSQ
TcMyAUPrIuhykm4x/r3tVdQo7BgLC0z+lO87FPkKtnuUD4YNM8Jh6MocLig86s67
1BaMchCLXaqEETHguKHyHdVE2bnJ/eNKEulBxCh6/fF4g9abwBTrmtHYOoaYjDmS
Rm2HykTXVc9LRlQXLafO4mwgiirDbiR6yYT3EnjF8F6Jly5Oap0ITxCd14xLnNBI
7H87reUaIJjDbbiUx7DUArUlxyAXaZDBqSeov4dJc16Qg92X1JBrD+0BwVtfLhwU
swTiTs0MqAUX54uVVHiBo2CZ9rYveeXeg6DltLiooAVMfND+Iiwfu0oWuEdH2K4T
uRbx0EDFBi7aQXuye6t8Ohc0wsTXWbKI5O3JQpIDPoRF1hPFotKsZsgCrWxbo9p5
dbHJ5Ll6fo5zw23qRCz+s6tydbMG8ESxxmGdJECRlfy93BS7s1aQMW03/U3WAAH6
ea60XcOCUFlXtWaosP4yqBEamzL6cBpw/qMK2zfN23lwnQl6O+WNUvGR5iai9TDI
XnYNPTo6CHq8Vn58XjR40Ktuvej6dG0zZhrugERJgc9khSqvPQWLk5Dl0EOoEpE0
L7HhP1fh6F9rqUxyQB9g
=4NFq
-----END PGP SIGNATURE-----

--w7U90d4aTNRvuKikfQE7KlPFbuP9bWW57--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
