From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/9] Export vendors specific ABIs
Date: Fri, 23 Sep 2016 12:42:02 -0400
Message-ID: <701c2cd1-a47a-807d-41dc-c8057dd073bd@redhat.com>
References: <1474554679-21953-1-git-send-email-leon@kernel.org>
 <20160922144716.GA10032@infradead.org> <20160922160924.GI4088@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pbWU4TTjdVsvAA3FKlKFG67wX6X6nw6I5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160922160924.GI4088-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pbWU4TTjdVsvAA3FKlKFG67wX6X6nw6I5
Content-Type: multipart/mixed; boundary="OUGe7mNOJKLkfk2q2UBwvEUh9AshFnOgj";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Message-ID: <701c2cd1-a47a-807d-41dc-c8057dd073bd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/9] Export vendors specific ABIs
References: <1474554679-21953-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20160922144716.GA10032-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> <20160922160924.GI4088-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160922160924.GI4088-2ukJVAZIZ/Y@public.gmane.org>

--OUGe7mNOJKLkfk2q2UBwvEUh9AshFnOgj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/22/2016 12:09 PM, Leon Romanovsky wrote:
> On Thu, Sep 22, 2016 at 07:47:16AM -0700, Christoph Hellwig wrote:
>> Although I would have removed patch 8
>=20
> I'm not sure about it, but anyway it is separate patch which can be
> easily dropped by Doug when he will apply it.

Mostly easily, yes.

>> and add the Kconfig changes to
>> each individual driver change instead.
>=20
> I want logically separate move part and export part of this patch
> series.

There's no reason to separate them.  And it leaves dangling uapi header
files that are in the uapi directory but not listed in the Kconfig.  I
squashed the Kconfig changes and also the MAINTAINERS changes down into
the main patches, so the series is now only 7 patches.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--OUGe7mNOJKLkfk2q2UBwvEUh9AshFnOgj--

--pbWU4TTjdVsvAA3FKlKFG67wX6X6nw6I5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX5VtaAAoJELgmozMOVy/d/MIP+gMgGkb2IsHDawv/pVfXa5dE
d29bJURhYXlfI7s0e6huBZSbPi/LAvgeZ6VmewQpO3CRwV0pltMQHe543zepizqw
41P193OMefrt5l7DfIs1vfRlZRlosklgN5xi9c4HSbigzOkUw9Dmwdv1uDmNyLS3
a7Du6cmHYghnRcX6ls6bXVsIfk58Oz5IHPfatSozewdgMIRxHk5BME2YrZC603U7
SoypXrnQC/mC0b87tskAqINpiqCNwaQM2LPmKp+TmUWAHQtw4i21bsDQ5HTIryd/
HnoJAmUbU3z2lmsailkQGuurCttzAtAun3YKdVa8OgEtzihxYATwWVYS/VisbKaA
Km95g3o0yt8xzeBkjxgVfpoSzRg5sVttpDL6z04G3kRFyHLp0XUirJ0jCae1iSyN
mxkdbzEjYFCUtqGVVT04nvixhnjhyr5TOEViaSFaNyqoSXc7g38u80D4CBp3QhpV
f1UPrAa9yrSB/iWk835GTL/9I+rZxfWc6JpCO6pds59PhEzjlFkRqSyBuLJaVRNn
ZoG2OAKLmmvmvThn3pOgvePsWAXbFkAeQ+sEbzoc4+Oihi2SsXQtpoqCz4llKdXU
D9pLTXG4nWwwsCgORydY+M0k8yT8rV67cZlM12+SJNmacobmeWaQ2hy+6G3keMay
tM3HXAAIGAEzmFTDXr3l
=bxDP
-----END PGP SIGNATURE-----

--pbWU4TTjdVsvAA3FKlKFG67wX6X6nw6I5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
