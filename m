From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] qedr: Use list_move_tail instead of
 list_del/list_add_tail
Date: Wed, 14 Dec 2016 11:29:47 -0500
Message-ID: <fc4fdba5-fa66-dca2-9c1a-352afc0c69e2@redhat.com>
References: <1477757993-32186-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Luq9BW5jq7SjR2C0brcDvgUMcm2fh1rpR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477757993-32186-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Luq9BW5jq7SjR2C0brcDvgUMcm2fh1rpR
Content-Type: multipart/mixed; boundary="AVlVLkBU8TKeRQU6JXmbmmmN6qhQXEUhA";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani
 <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <fc4fdba5-fa66-dca2-9c1a-352afc0c69e2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] qedr: Use list_move_tail instead of
 list_del/list_add_tail
References: <1477757993-32186-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1477757993-32186-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--AVlVLkBU8TKeRQU6JXmbmmmN6qhQXEUhA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/29/2016 12:19 PM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Using list_move_tail() instead of list_del() + list_add_tail().
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--AVlVLkBU8TKeRQU6JXmbmmmN6qhQXEUhA--

--Luq9BW5jq7SjR2C0brcDvgUMcm2fh1rpR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUXN7AAoJELgmozMOVy/doUQQAKnKPjTTfGhXge7zvXI/sNrz
2WHwvYr6aHH06SNrxTUFVShH2SgllcHXGLfzLXcumQws0Oyjr4j3Y93Cg9K2ljcU
Fm2NbFOmS1UmU/GcDTyOxZnpSptBmNbL4dcEx0M/gO3w70nzBBM50AhyjzUDDKx1
yL0d7+Pi2BosTCnS3HpK26Kcjpo9rvIC4kATpTE+pVsqaNrzGMf4eKMY+HcirGAb
+kPhCxU7cWaIZcL6a/mczO1p0Kz8vJwyttg6U2rNWe0C7DWfds9EcuAWWsO1L2iC
bM1BuLtWqmpTuQPSBaITIaC2uDiDLgozkck6Q7QFVXCxbnbdo+yN8cq6VX7LrtjQ
d6WLZrD4l1e+8rlLYRnu27vyd4nq9M9SpHj9nFVNqPjixpBSrgdkImfD/yDszcBT
owOZgrNVbaY/RB7KDBXUdUx7jas82BJiTDIr2Giw6sI+9DUVBDlN2M4MtS1Me0bb
yH/2TVShHqHywpRGYTx9j4Lehke02hojap3KLkFD5scjN29mtHv30vjfOE7zg5PM
1aZywX1tm61FP0Pjd/+qk4r4LpXgSjB2hh3f4Ay2TgOx9+nKYi2+vD5x8uI6fKQg
zT6S8aS8M64xiFCG6za+zGcRfviRaRt9bj4goQ5B1X5v7TE+MIdq69u6kSRFJLd5
JZ8SMpyAf5dyfRGQ9gug
=qTE5
-----END PGP SIGNATURE-----

--Luq9BW5jq7SjR2C0brcDvgUMcm2fh1rpR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
