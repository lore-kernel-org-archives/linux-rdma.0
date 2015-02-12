From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/22] IB/ipoib: Fixups for multicast issues
Date: Wed, 11 Feb 2015 23:55:06 -0500
Message-ID: <1423716906.3424.74.camel@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
	 <54DC303C.2020207@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bv9jGeLoGkFFaDgZX+7I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DC303C.2020207-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-bv9jGeLoGkFFaDgZX+7I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-02-11 at 23:46 -0500, Or Gerlitz wrote:
> On 2/11/2015 8:43 PM, Doug Ledford wrote:
> > This patchset revives the 8 patches that were reverted from 3.19,
> > the 11 patches that fixed the problems with the first 8, the single
> > patch that was related to reaping of ah's and failure to dealloc
> > resources on shutdown, and then adds two new patches that would
> > have been enhancements and not bugfixes and hence weren't appropriate
> > to post in the 3.19 tussle.
> Doug, as asked few times... please provide public git tree where this=20
> series can be pulled from.

git://github.com/dledford/linux.git for-3.20

>  So no squashes for patches which actually=20
> represent a fix to a downstream patch within the series? any specific=20
> reason for that?

I tried, but the most appropriate squashes were things like patch 18 and
19 squashed into patch 3, and some other similar jumping around of
patches.  The number of conflicts that created in both the original
squash and the follow on patches was perverse.  So, since the original
20 patches as I submitted previously are what has gone through our QA, I
left them as they were.  If I fixed them up and squashed them, and if
some overlooked fixup failure snuck in there, it would invalidate all of
that testing.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-bv9jGeLoGkFFaDgZX+7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU3DIqAAoJELgmozMOVy/dYS8P/2px1IwRuWTHT/s9ZSZdqsWj
3j6j80WU/ukgK3WDDOF7Mp/ScrKNFtnDNj3kSfpQ0jO+W1GW2H+fQ1F0J8zlreeZ
CGfkDtCEnqfUquJRlQV/Vk58XFNkhWE5SD+k7e6ZC633XmZUwuW5pvIfbDY+zz9K
ZhUh10sX64DFyC1KO+Tn+pYFkgqwzb5ax7oGxkMnzsn/R36EQYY61Qd+EnoNYf7u
hF7j41ynUvjmHNSn0ifhuvYC01laT+moGtYu9uS4/muDLD4nofDQSjm7txbW7c00
JpA3/nUjGkWzWE4/LkaK6YW/ca2LLU8MiB5mfEZ9Go4G8qSmWCcHRuXBPKuML4R6
bqzP0ClYi1cSk9ANdG3I6wqOgrgzomfA3o1TyEOZFWSt8wrX6Q5qSWeBy7n/Twr5
bCnOaokN57q108MDQckvfqQIBfpUsetYgID2bZZPQlj0uYbFOAzbyNSLoT8NNnqa
sA5F1MiCyuPVqT460Yl25/gyMbVMAbDAHKzMCDRp/ub54sRXvmGkEsy1wrlpbZed
D5GWumKE+Be7XWDZ+ycRMzhh2U06jc3veHR45N45b5XINTN65SrUKOHen8ERPxWC
I9HavgAIwA8fYyq/0BlXHXHDygNhwb4DyUoUGCm84XcPv05dgrwBYx+010M0j6Ly
tVb5DBAq3V/Pbh6DuYQy
=oVc2
-----END PGP SIGNATURE-----

--=-bv9jGeLoGkFFaDgZX+7I--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
