From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Tue, 7 Jun 2016 19:23:32 +0300
Message-ID: <20160607162332.GH3663@leon.nu>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-7-git-send-email-leon@kernel.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a@redhat.com>
 <20160607071621.GB3663@leon.nu>
 <97ef54ca-d3c4-f294-4bb7-4422ae25dde4@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wj9ZLJVQDRFjGSdK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <97ef54ca-d3c4-f294-4bb7-4422ae25dde4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--wj9ZLJVQDRFjGSdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 07, 2016 at 09:43:29AM -0400, Doug Ledford wrote:
> On 6/7/2016 3:16 AM, Leon Romanovsky wrote:
> > On Mon, Jun 06, 2016 at 07:53:43PM -0400, Doug Ledford wrote:
> >> On 6/4/2016 8:15 AM, Leon Romanovsky wrote:
> >>> From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>
> >>> In a attribute group struct, attrs should point to a NULL
> >>> terminated list. Which means we need to allocate one more
> >>> slot in the array.
> >>
> >> This patch is both right and wrong.  You're right with the intent (that
> >> there should be a total of 2 extra entries in the array size, one for
> >> the NULL termination and one for the lifespan entry), but wrong with t=
he
> >> mechanics (unless I've missed something).  We already have two extra
> >> entries because sizeof(*hsag) includes our first counter, so just
> >> num_counters is actually enough to NULL terminate the list, and + 1
> >> gives us lifespan plus a NULL terminate spot.  The comment could be
> >> cleaned up to make this more clear though, so I'll do that.
> >=20
> > Thanks Doug.
> >=20
>=20
> I was wrong with this BTW (I tested to make sure).  Even though the
> struct includes the name for the array, because it's 0 length, it
> reserves 0 space.  I thought it would reserve one u64.  In any case, I
> ended up writing a fix of my own since I had already marked your patch
> as not needed in patchworks.  I listed Mark as the reporter in that patch.

Since I know that you are testing the patches, and your "I'll do that."
was enough for me.

Thanks.

>=20




--wj9ZLJVQDRFjGSdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVvUEAAoJEORje4g2clinNbMP/j2PttUJFM6BSfZsvWh8DhEr
Gz9LnTxEd+dM7il3uvVJVtWPU/pqDwInddl086ldCJNqKsLzF/deH7UrUZHOQ3J/
o2UtKkWSHlikOXEwKLd+8XcLcE3Ob0E5tIVu+PDxDIT2OjwoK+VQEoPlaBjkMS8s
FMedo8SuuN8NV48NYbJ9EYJRVFxT56b7msHNGF1e+P7+OoVfLDMIanmy+Qd5bchY
cTawyBCUYWpxPVl062KZGPDcKwi9Sgv4DWghP0qo+FQQeoCV2tCakmFD9xr+hnS6
cIjoxiDpMUvxnup30Pk2Vp5nSN1fLPzNCaldtKMKkRy7k9/zkao6z1XuoYNz9Cuw
uabaAEenvT2UuGEcKizJiVg/r8UorgJ+lenAypcPHIdKlrxiH4r6t9gekERHPIGY
gNzl9rkM6fRQKG7MqnVQ5tFkmykpOJh1kwkBTRMuvkeWBaPQSi9fFQV1xW1wZXlA
KEADJmV4oUygSsniHu2w49Df5k549K+cX9KxeBpC5rYD74ewzxSkQca1Kjvh2+4C
866CNMcvVFmMu6mhVaWVKdAHspvuCO6KF0isjwK0MQTN0Jc8jc71ZER3KAm6K7Ys
PmpVU3sPZvR+jUdbnJn5nFF62lXWPF6VfjopfwweYi7lYGemrOTZyHPF1hs11ird
DJsn6GiS1C5A1Xkwl6Lx
=NEmE
-----END PGP SIGNATURE-----

--wj9ZLJVQDRFjGSdK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
