From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 00/21] IB/hfi1: First round of fixes for 4.7
Date: Mon, 18 Apr 2016 16:56:13 +0300
Message-ID: <20160418135613.GN6349@leon.nu>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
 <20160418070936.GK6349@leon.nu>
 <20160418120754.GC17987@phlsvsds.ph.intel.com>
 <20160418121944.GL6349@leon.nu>
 <20160418133842.GA7596@phlsvsds.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ztcJpsdPpsnnlAp8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418133842.GA7596-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ztcJpsdPpsnnlAp8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 18, 2016 at 09:38:43AM -0400, Dennis Dalessandro wrote:
> On Mon, Apr 18, 2016 at 03:19:44PM +0300, Leon Romanovsky wrote:
> >On Mon, Apr 18, 2016 at 08:07:55AM -0400, Dennis Dalessandro wrote:
> >>On Mon, Apr 18, 2016 at 10:09:36AM +0300, Leon Romanovsky wrote:
> >>>On Tue, Apr 12, 2016 at 10:49:52AM -0700, Dennis Dalessandro wrote:
> >>>>These patches do some clean ups and fix issues which may not be appro=
priate for
> >>>>an RC so we are targeting these for 4.7. The current patch series app=
lies on top
> >>>>of the "Important bug fixes for 4.6 RC" patch set submitted just prio=
r to this.
> >>>>
> >>>>Patches can be viewed in my GitHub repo at:
> >>>>https://github.com/ddalessa/kernel/tree/for-4.7.
> >>>
> >>>Please follow SubmittingPatches guide - submitting fixes section.
> >>>
> >>
> >>Can you please be more specific with what your complaint is here? Which
> >>section are you referring to? There is no "submitting fixes" section in=
 the
> >>document.
> >
> >
> >If your patch fixes a bug in a specific commit, e.g. you found an issue
> >using git-bisect, please use the 'Fixes:' tag with the first 12 characte=
rs of
> >the SHA-1 ID, and the one line summary.  For example:
> >
> > Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
> >
> >https://www.kernel.org/doc/Documentation/SubmittingPatches
>=20
> When there is a specific commit that broke something, sure. I think folks
> usually add that when appropriate, it's not always the case. "Fix" is a
> general term in a lot of patches. Could be day-0 bug, or the result of
> multiple commits coming together, etc.

Fixes line will help to the users and developers to get a sense if the
failure they see can be related to the code which they have (SHA-1).

Especially, it is valuable when it comes from the vendor who does
extensive testing and can perfectly explain what they are fixing.

>=20
> Regardless, is there a patch here in this series that you need more back
> story on?  Please let me know and I'll track it down.

Every commit which suppose to fix something.


>=20
> -Denny

--ztcJpsdPpsnnlAp8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFOd9AAoJEORje4g2clin4o8P/182BymLa57i9ufSXf96iioZ
j5iQ2wNGCYxJQxZm60H25pAxPeLAoI6T9CTFnM7OGpq99M/Z6StmGSRJ/mBk3flO
nw3JGzo+oRGNWG8ePAhX5rIsRr/RLJQPiZhvQQqOOEPAhRImMm0+sOKV/2kickjX
il8d7O6XsfYnYpx6ZmyS+Q+BJ7uHMKIHSEVNU6iA1ZEiC8E9yERR/stYmL4gY2Z2
HaSrVs6rextq2rRRSTnlLdTCPFShCSpRKLZnKxZv0MaYV6Lk76jW3u8b6l+VRf2J
Q0twV6uPPc9RBIJYmG5TE+Eq8dMrtXN7/UR7Ubgi0Q2TrXmvfKyMg9sC76Tjtccq
H96C2Vv0Zj5jKfy0GcRMdAN84B0nA4lv8TcwVPgyXeRFR9cVXkUmNRLcuYnybUER
VEUC5OnkuvE4cCQjuAD+0YL1vCxFhixXe2vsZlOqmVec8cB6s/g42nfVboN26+x/
kofPGzWFeEpvTqlM7OSIBO+yGoD5Jh9uSLSO9M3KcXMejRt8LDZ+Df1pFVKj+PCM
jdXMZGwxl2E3xHYo7bkfJJzBPoCcX3ib4jIjSQMT/vUctOwX8ArL5xTDwjZNDG8J
r9JTF+Lar8A3fTN4Mk0tbDy7pgrBKUNSryNNuUNqM2vKiQPMZxVmpxnNyaSoDn1u
bg006AU/j7xJYuFW/6re
=NHVy
-----END PGP SIGNATURE-----

--ztcJpsdPpsnnlAp8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
