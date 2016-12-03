From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/17] Remove debug prints after allocation
 failure
Date: Sat, 03 Dec 2016 13:21:32 -0500
Message-ID: <1480789292.15032.64.camel@redhat.com>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jpG5zRoJm1O4NdF6bfa1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro a <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-jpG5zRoJm1O4NdF6bfa1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-11-03 at 07:02 +0200, Leon Romanovsky wrote:
> Hi Doug and all,
>=20
> This is semantic cleanup of infiniband stack from printks immediately
> after allocation failure. It doesn't get rid from all printks, but
> only from
> the ones which were found by the following grep construction.
>=20
> =E2=9E=9C=C2=A0=C2=A0linux-rdma git:(topic/clean-alloc-prints) grep -rI
> "[k|v][m|z|c]alloc(" drivers/infiniband/* -A5 | grep "n\""
>=20
> The patchset consists from the 16 almost identical patches and from
> one fix
> which was discovered during the cleanup work.
>=20
> The fix is presented in the patch "IB/core: Release allocated memory
> in cache setup failure"
>=20
> Available in the "topic/clean-alloc-prints" topic branch of this git
> repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/
> ?h=3Dtopic/clean-alloc-prints
>=20
> CC: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> CC: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> CC: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> CC: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> CC: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> CC: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>a
> CC: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>=20
> Leon Romanovsky (17):
> =C2=A0 IB/mad: Remove debug prints after allocation failure
> =C2=A0 IB/core: Remove debug prints after allocation failure
> =C2=A0 IB/core: Release allocated memory in cache setup failure
> =C2=A0 IB/mlx4: Remove debug prints after allocation failure
> =C2=A0 IB/mlx5: Remove debug prints after allocation failure
> =C2=A0 IB/hfi1: Remove debug prints after allocation failure
> =C2=A0 IB/cxgb3: Remove debug prints after allocation failure
> =C2=A0 IB/cxgb4: Remove debug prints after allocation failure
> =C2=A0 IB/i40iw: Remove debug prints after allocation failure
> =C2=A0 IB/qib: Remove debug prints after allocation failure
> =C2=A0 IB/nes: Remove debug prints after allocation failure
> =C2=A0 IB/mthca: Remove debug prints after allocation failure
> =C2=A0 IB/usninc: Remove and fix debug prints after allocation failure
> =C2=A0 IB/ocrdma: Remove and fix debug prints after allocation failure
> =C2=A0 IB/rxe: Remove and fix debug prints after allocation failure
> =C2=A0 IB/isert: Remove and fix debug prints after allocation failure
> =C2=A0 IB/ipoib: Remove and fix debug prints after allocation failure
>=C2=A0

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-jpG5zRoJm1O4NdF6bfa1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYQw0sAAoJELgmozMOVy/dvYsP/2THAHAxQmHRD+paAMfpSlzQ
EhWR+CkXyesBsNVW7aw4S+qPojmABNU07I9CBmOpNmdWmI820+9xH8ALSFkMFGx5
DrdHpyTypJd2T4y0iXW+ojGXlac9aWKabtT83xQruIN65wT+Yoq7IIIuugkVaPKw
nHyuKA8mqGYaMNxrdvoeVU+/my996idimJiOr8wDg00exZh25VkDZUz8XCUg1nAt
DDJdFspJIDsBOjY0w9KFbrFM9zqAyVNI7bZXjRcFUFANDDvwQC4CrTTlRe7cPvj1
HJeNy+hKer6E1t5bEuYk1l9NvK0s2vYEM/sU9rhK+UirQIDeQVIeqDA61AQp5gQy
m6OtUZyIEsi6JNmZNBnXaaQp+A2pSBTZ3eZQAU9hWF1t6gXcgTF8NSfwFlernal7
uyPPcqZrejPqlOvaNBM2OPAnrb6CM/0c3YVbCWMZ8tlu1BK7uNpomDPJ1RZQqfOK
W5bW/eXJj7TALm/JNwg97gPXO6MHvSofU1Gj12z+60aU/YuHvDlL7Uh9ZzXdhB9I
sAdpCu/pImD/tqiJ9PHS4iVyAM24Amf267/qvvSeQ8dcmqmlcvUsg64b4HlMpILr
ge2NL8j2KiW14QDq1Ks0SgOslbk58SwQuKnCDncHpLsvUnYCRshblSQ90KhS02GR
BH0VeL5AQy6zEdp4zkOb
=MIiI
-----END PGP SIGNATURE-----

--=-jpG5zRoJm1O4NdF6bfa1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
