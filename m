From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/1] IB/mlx4: Unaligned access in send_reply_to_slave
Date: Wed, 18 May 2016 10:41:13 -0400
Message-ID: <bacbd948-1a7e-4c8b-0397-3699093d88be@redhat.com>
References: <1463566690-22881-1-git-send-email-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2IIDelUwu36tUicUnUHtwatMVb69dXtNu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463566690-22881-1-git-send-email-shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2IIDelUwu36tUicUnUHtwatMVb69dXtNu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 06:18 AM, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
> From: shamir rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> The problem is that the function 'send_reply_to_slave' get the
> 'req_sa_mad' as pointer whose address can be unaligned to 8 bytes.
> In this case the compiler cannot know in advance what will be the
> alignment of the 'data' field.
>=20
> Sowmini Varadhan pointed to this reply from Dave Miller that say
> that memcpy should not be used to solve alignment issues:
> https://lkml.org/lkml/2015/10/21/352
>=20
> Optimization of memcpy to 'ldx' instruction can only happen if the
> compiler see that the size of the data we copy is 8 bytes and it
> assume it is aligned to 8. If the compiler know the type is not
> aligned to 8 it must not optimize the 8 bytes copy. Defining the
> data type as aligned to 4 force the compiler to assume it is not
> aligned to 8 at all time.
>=20
> Full credit for the idea goes to Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>.
>=20
> v3: Change patch according to suggestion by Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20
> v2: Minor fix in patch headline by Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Signed-off-by: shamir rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

I considerably reworked the commit message, but otherwise applied.  Thank=
s.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--2IIDelUwu36tUicUnUHtwatMVb69dXtNu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPH8JAAoJELgmozMOVy/djswQALKMiWhLgZOrKHlHg2SSLYk3
rbzLZi6WX9SGoi58z4B8mNGatPW1eySypCyxHv08hzSZ2xNdpSvCuQ4wttRkCkjF
Cbbljken0i/5YS2yQxg+1p/cqDSG5gy+xh7qMkGiq5UHCqiBJD0PH0YY/dVt4jT3
uVOxPGfiNkMM28mQY90SG9fGnAShz2RSxJic68Xpc7TlMdZ35Oj2PFAhL9kNayAP
v6pEzBHe+arhnDHJjq2my598EA3Sh1vGahNjqD6CKsByoEGf7w63M+jcnpp4mlQO
wty+N/TcOYX518mnAM1cEI45VlaA8terpqVI1cvlq2Dwqz86nf2bFMJTMS7B3abp
CnNLJI7yWul/cjD+5XNrrC6O+YPSp+XSuy11wGPdd7ZWY10HXff9jS0HlFqJQv2R
WF5kKn4JwuUoxtihC4uCaORPlyxnxbiD879cf5lkfFJaVkuv2sAn0p90pgL84+UV
2rTqw2S/h6qJg4O7woD5cDlNnPAktHEqW+AZ8HZoXqwCjyhjoPHv85cSFGDYyLny
8B6rwrl4uK2DOoE7B7AB189RFJBDBTAdwk8sKP20yXuVnMaLlrwxwDgSWTAUhV/+
OK+rBoNsKc72OATyt3nf7sJscM4WLChdW0ElIb3ncj+ruqxZphYRwO791c7f3glP
Nh+enu71mwwkNn4JDyR6
=32XH
-----END PGP SIGNATURE-----

--2IIDelUwu36tUicUnUHtwatMVb69dXtNu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
