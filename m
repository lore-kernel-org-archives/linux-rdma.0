From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH librdmacm] cmtime: rework program to be multithread
Date: Tue, 01 Apr 2014 21:14:18 -0400
Message-ID: <533B646A.1010406@redhat.com>
References: <1380055497-13940-1-git-send-email-dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bIU62EpGgGnB0evFMdS7OuUqgkwM7Di1d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380055497-13940-1-git-send-email-dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bIU62EpGgGnB0evFMdS7OuUqgkwM7Di1d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/24/2013 4:44 PM, Doug Ledford wrote:
> When using very large numbers of connections (10,000 was in use here),
> we ran into a problem where when we resolved a performance problem in
> the kernel cma.c code, we suddenly developed a new problem.  That new
> problem turned out to be the fact that with the underlying kernel issue=

> resolved, 10,000 connect requests would flood the server side of the
> test and the cmtime application would respond as quickly as possible.
> However, the client side would not bother to check any of the returns
> until after having sent all 10,000 connect requests.  When the kernel
> had a serializing performance problem, this was OK.  When it was fixed,=

> this caused a general slowdown in connect operations due to overruns in=

> the event processing.  This patch causes the client side to fire off
> threads that will handle responses to connect requests as they come in
> instead of allowing them to backlog uncontrollably.  Times for a 10,000=

> connect run changed from this:
>=20
> [root@rdma-dev-01 ~]# more
> 3.12.0-rc1.cached_gids+optimized_connect+trimmed_cache+.output
> ib1:
> step              total ms     max ms     min us  us / conn
> create id    :       46.64       0.10       1.00       4.66
> bind addr    :       89.61       0.04       7.00       8.96
> resolve addr :       50.63      26.18   23976.00       5.06
> resolve route:      565.44     538.77   26736.00      56.54
> create qp    :     4028.31       5.70     326.00     402.83
> connect      :    50077.42   49990.49   90734.00    5007.74
> disconnect   :     5277.25    4850.35  380017.00     527.72
> destroy      :       42.15       0.04       2.00       4.21
>=20
> ib0:
> step              total ms     max ms     min us  us / conn
> create id    :       34.82       0.04       1.00       3.48
> bind addr    :       25.94       0.02       1.00       2.59
> resolve addr :       48.18      25.01   22779.00       4.82
> resolve route:      501.28     476.26   25071.00      50.13
> create qp    :     3274.12       6.05     257.00     327.41
> connect      :    55549.64   55490.32   62150.00    5554.96
> disconnect   :     5263.64    4851.18  375628.00     526.36
> destroy      :       47.20       0.07       2.00       4.72
>=20
> to this:
>=20
> [root@rdma-dev-01 ~]# more
> 3.12.0-rc1.cached_gids+optimized_connect+trimmed_cache+-fixed-cmtime.ou=
tput
> ib1:
> step              total ms     max ms     min us  us / conn
> create id    :       34.45       0.08       1.00       3.44
> bind addr    :       88.41       0.04       7.00       8.84
> resolve addr :       33.59       4.65     612.00       3.36
> resolve route:      618.68       0.61      97.00      61.87
> create qp    :     4024.03       6.30     341.00     402.40
> connect      :     6983.35    6886.33    8509.00     698.33
> disconnect   :     5066.47     230.34     831.00     506.65
> destroy      :       37.02       0.03       2.00       3.70
>=20
> ib0:
> step              total ms     max ms     min us  us / conn
> create id    :       42.61       0.14       1.00       4.26
> bind addr    :       27.05       0.03       2.00       2.70
> resolve addr :       40.65      10.73     869.00       4.06
> resolve route:      626.75       0.60     103.00      62.68
> create qp    :     3334.50       6.48     273.00     333.45
> connect      :     6310.29    6251.59   13298.00     631.03
> disconnect   :     5111.12     365.87     867.00     511.11
> destroy      :       36.57       0.02       2.00       3.66
>=20
> with this patch.
>=20
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  examples/cmtime.c | 227 +++++++++++++++++++++++++++++++++++++++++++++-=
--------
>  1 file changed, 189 insertions(+), 38 deletions(-)

Ping.  I noticed this never got picked up.  Was there a problem, or just
overlooked?



--bIU62EpGgGnB0evFMdS7OuUqgkwM7Di1d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTO2RqAAoJELgmozMOVy/duD0P/jZcV6GQHK5/CjGGGoHR36cx
kvN42sIzkb94oZ4SRsgtZ2S7dICu3CYvAKIkKkU+RlkeNxYcV8L9mWVsiHZ/VTUg
a/8PuedIk0xtNnrY2h0j37nbgplNt6hOCY3GgI8UnNULH44ZRBLiwqFffHDxKo5/
mAEifOvavZqgAI5xb/OCgZoADBVPTGBbktfpiiCjqArsmvAxKSuc9iYsmc5sFK/G
DBXgDs4D3IXUQqthYek4FpzMuOY63ZjJprMZfejebNp+7hrf4+waM3lLI7bLdAyl
+57Nb7ts6B3x8ch/KqhgJrG40uM8AMR2hCKNCf2zsqRvOVBSxlB4dDPz7J0N4l7Y
9grv4QRUWuWmI2qQJJFPnogYkFs7C23208SfLS8Epup5OeDDvVID4Jifjk2On3yU
C0OB+X8cheGTnUUiJbpKGwrcAcT1FKf4BFjD0bFkUNccB2sR02UmxM9MlQQ4+okf
baNX1Y/mZ0j1ZVDOHegef9KTTPzGVrMp7d1XHYtRJrgdOPoAGBL6CoyKW0zRsRP+
lnytt6UvcTRYqtjSMWQR7KtkDRlcYCKBGJe9v9O1evtN5ajvAt+xP3Fz09rOE/KG
MXrKtShPFTvYrK4z5N9H1gQKENM4nT1MSQ/qmlMPIO6rGpBuvA0pb+6dQTsvoFx3
J+rK1XmHQxItzialca+i
=z3Pp
-----END PGP SIGNATURE-----

--bIU62EpGgGnB0evFMdS7OuUqgkwM7Di1d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
