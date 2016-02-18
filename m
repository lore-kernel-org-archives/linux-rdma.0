From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] IB/core uverbs support for legacy commands
Date: Thu, 18 Feb 2016 12:33:41 -0500
Message-ID: <56C60075.8080703@redhat.com>
References: <1455462469-9124-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uFh7dnSLmqUHxJMOSckpm3uWPKBqi26u4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455462469-9124-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uFh7dnSLmqUHxJMOSckpm3uWPKBqi26u4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/14/2016 10:07 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hi Doug,
> I'm resending the Eli's patches [1] which adds uverbs support for
> legacy commands.
>=20
> [1] http://permalink.gmane.org/gmane.linux.drivers.rdma/30545
>=20
> Eli Cohen (3):
>   IB/core: Avoid duplicate code
>   IB/core: IB/core: Allow legacy verbs through extended interfaces
>   IB/core: Modify conditional on ucontext existence
>=20
>  drivers/infiniband/core/uverbs_main.c | 70 +++++++++++++++++----------=
--------
>  1 file changed, 34 insertions(+), 36 deletions(-)
>=20

Thanks, series applied.


--uFh7dnSLmqUHxJMOSckpm3uWPKBqi26u4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxgB1AAoJELgmozMOVy/dQbsP/2yKAqjoLe0ZJJje8ek+T51L
MPKv/h0r+GXWn0ksOAPXc0NN7DeQYL6E7KnAeBo380Tm5QA1b0admS8dXIDm39/+
0nxRrqRtzBoWokHf95A0C8l2XaalEwXEB85LM69K+C407Z9EJiYIlO1ZipTg7Uec
ZODgss76KvLzXb6bgKhHxbPAqa1vQCAun9pxgE7wvMqWy9pd6BrdtFh1A/7KoxHs
Ft+ERJlF6ZSLR3GOahGaaRKlcz2jRtj/0x97yt7/qsGLltkmaVds5tqnJEXP0Gbe
XJxucNqtNn/XROcxz2pJKRlchTtpFzPEGhZN1bPyMYzbPhY6lBJMjyi6KPEhJdNo
Xdld/YPDnBPqVs2fjiKT5+a/EiE7rZX8ilgCJeq+1DMM1vy976Ig0vMh21m4rkgD
YOC5V6p9j4BAMCIVpj++ZF7W5JkLCHujv17VbBAJ3bqlxnRP/1xOey+e2q4iDWa+
sawv8XBd65U55jLLu+QQX/gGiVSFtgZJkLYkM931wCsyp1mG1zv/qry5cxzu5Kx2
FXy39l0o524pbBwbK53MxoWtKBWqmZv+jahjzkN5IiJUX4XBVRTU/De7Cz72ub0Y
QtGu5tSa7WynMnK9/zS5MfzPYiOvwcT9lgNCKxzdVSaulUBVIePeydbr/FaqPk9k
fyB4H2epqsuvOrK5i7yc
=b1rW
-----END PGP SIGNATURE-----

--uFh7dnSLmqUHxJMOSckpm3uWPKBqi26u4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
