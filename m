From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Thu, 12 May 2016 22:01:17 -0400
Message-ID: <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
References: <20160512174406.GB11827@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5L97MMAFSLwA4Cd927XnMcVnPDTMAmgLM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512174406.GB11827-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5L97MMAFSLwA4Cd927XnMcVnPDTMAmgLM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/12/2016 01:44 PM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> I prepared the base tree [1] with patches sent to RDMA mailing and pass=
ed review.

You can't know that.  The reason I say that is because they have to pass
my review as well, and that's usually an implicit thing.  If I review
them and they have already passed list review and they pass my review,
then I include them.  If they don't pass my review (which isn't often if
the other people on the list have already spoke up, but does happen),
then I ask for revisions.  If you take them without an explicit review
from me, then you don't know if I'll ask for a revision or not.  It's
premature.

> This base tree is part of linux-next and kbuild system, and it passed
> sanity checks.

Most, there was a linux-next build failure that I'm sure is related to a
change I hadn't had a chance to look into yet but looked fishy to me
(the move to put ib_addr into ib_core looks like it's broken, but I
hadn't delved into the code to verify it...the linux-next build failure
from tonight makes me thing that it is).

> I believe that it will save you a lot of work and time if you use it
> as a base for next merge window submission (4.7).

Not really.  I still have to review the patches, and I still have to
update patchworks, and when I'm sorting through patchworks is when I get
the patches to include.  The incremental time to grab the patches out of
patchworks and run git am -s on the bundle is negligible.  The real time
is in reading the patches, and this doesn't save me any of that time.
The help is appreciated though ;-)

> The topics which were added:
>  * topic/fix-core
>  * topic/hfi1
>  * topic/i40iw
>  * topic/ipoib
>  * topic/iw_cxgb4
>  * topic/iwcm
>  * topic/nes
>  * topic/rdma-rw-api
>  * topic/srp
>=20
> [1]
> Git repository:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git rdma-=
next
>=20
> Gitweb:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Drdma-next
>=20
> Thanks.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5L97MMAFSLwA4Cd927XnMcVnPDTMAmgLM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNTVtAAoJELgmozMOVy/dZRYP/0LDVNGyLWPs/HanIofHM1m2
I7lfRkw8W+xdSCIc38oCRqVZqOIn/JXhAOj33mkIZ2OHNFHy5pommWKoSjgo0VO0
GJ4E5CFMU3BGYciwiR1+TYCQMUxT2Q9xECk4+eNT/kGhtGaYjSPlSMZSX+XjvSh/
WIpP04cX5p9x6esF0FmKtktcS8I4I/XSfwREWNmnlz47RS7Ydi3Iv52RVo0Isp/4
3pV+mWEqLbtTsA90bdztpRQKzvtSNzzDeYV2aQq3XZ+spSYaBhVJEmXaiO6bEqQG
IT9HGoyaO3mgKFbWTs86Cngq9kVw1sI3x2xGwApHF+RwkxD1iap8p5RFyVAgD+jA
7UvPnLqpXGiW7AAvNvso8p60JstKOp835+lQ9smP7HcL7Q3jlTN7Tu4RCKAlcFU7
GgdINFtE/B2I417aaDr/vSJub9cABbLpFqpJ2iMxS8lDSKShUcPqFpxsTS/5WNLZ
MirN0D0TmyXqBd2ZtR+H14rOzh0MarRNfTWpVAXWrHNi9qwm0ks2aBjYJHAGcgUd
ysZwQfD3fGY1lGc7vl4WtwcFyEkJRDTqWy8sa7rY0UXQjdy5YW2SaZuF0mPBgisa
rud9D8XSD+BTeNCFR1vxbf6VjN4JDXlI4lTBeMeaxp8Hx/84nl/Q2or4JrAUKTU/
GDgpc8duP5HVKVTos1OF
=NKZe
-----END PGP SIGNATURE-----

--5L97MMAFSLwA4Cd927XnMcVnPDTMAmgLM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
