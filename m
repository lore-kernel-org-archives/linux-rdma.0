From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/2] ocrdma license change
Date: Thu, 23 Jul 2015 17:37:13 -0400
Message-ID: <55B15E89.5080906@redhat.com>
References: <1437694440-25039-1-git-send-email-devesh.sharma@avagotech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jlEgxIMMmkpQBewP5oTfQK9kkVWLV46eK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437694440-25039-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jlEgxIMMmkpQBewP5oTfQK9kkVWLV46eK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/23/2015 07:33 PM, Devesh Sharma wrote:
> Doug- Thanks for your help!  Resubmitting, per your request
>=20
> Devesh Sharma (2):
>   RDMA/ocrdma: update ocrdma license to dual-license
>   RDMA/ocrdma: update ocrdma module license srting
>=20
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   55 +++++++++++++++++--=
--------
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.h |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   53 ++++++++++++++++---=
------
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   53 ++++++++++++++++---=
------
>  12 files changed, 409 insertions(+), 229 deletions(-)

Thanks Devesh.  I've picked these up and have them slated for 4.2-rc so
that we won't need to track down any additional contributors.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jlEgxIMMmkpQBewP5oTfQK9kkVWLV46eK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVsV6JAAoJELgmozMOVy/dpNMP/jq8Cujf4X+vpvp2BJlcOf/b
qLpToW2hkvYupFAa3jORHZvmEw1lSvCGdSXhLywzYYj6B8wBtbXsFcRdciVBzihM
/lJQW9zynFiBIhDZLNGTf6nAJ34y+8u8PxskFF5DohGvexIU1Rb9het+HeV0ZUBx
0D+XLhQIO46tgf6P36iHOii4+s6XFGmQXNxh8eCy7UsgiKb4e+/U44zrto94w2/C
mdOEOC5IGdTCTAOCtrJO376OcfB0hknmVbxCHgyBvPIPSm/5LwBbAkW42Zj3Skz8
URMS+s9s6sRpKzXvFhAwb+sjMFda93l+B1LIGBIv7vtEs8K/T9u5DN7RcNQLa7XO
IUNpXY6yLzrrBgSqh/um8x7Tx/LbwcHT9WoNiE79KfC/9AER2BA/VxbUtXjx80ag
TO29vkv71YYXVxwwFJsX92AITM4emN7XontpjlEtHifGb63Yp3Q0Te7ovl9yskUR
A0U2BuHgugYqPpTY4Yuzheir+HRcJ1owXizdAxkEz03Ds024vtk6GwoYhlsekBqp
JLcwA6MIn4qcpjRj41DjKA9kmlYu+NoWkPHFAh2e1iiqBm3aZ+Avx7i6X7vUL4i9
JWsTmOVB3z4xnvJQk0Ro73gbNE1BY+fhREcLWzBLd/PlsREChkidh7iIcYi3xgeF
rZs3U7bsY0FPDw9kqbPO
=n2bk
-----END PGP SIGNATURE-----

--jlEgxIMMmkpQBewP5oTfQK9kkVWLV46eK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
