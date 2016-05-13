From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rdma] IB/mlx5: Allow mapping the free running counter
 on PROT_EXEC
Date: Fri, 13 May 2016 15:43:22 -0400
Message-ID: <29e2d9d7-7140-efcf-df05-e868dc7abad8@redhat.com>
References: <1460641930-5118-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cpUrnqMq9LKO9tEgu9DwJueqKpE4f2MK6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460641930-5118-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cpUrnqMq9LKO9tEgu9DwJueqKpE4f2MK6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/14/2016 09:52 AM, Matan Barak wrote:
> The current mlx5 code disallows mapping the free running counter of
> mlx5 based hardwares when PROT_EXEC is set.
> Although this behaviour is correct, Linux does add an implicit VM_EXEC
> to the vm_flags if the READ_IMPLIES_EXEC bit is set in the process
> personality. This happens for example if the process stack is
> executable.
>=20
> This causes libmlx5 to output a warning and prevents the user from
> reading the free running clock.
> Executing the init segment of the hardware isn't a security risk
> (at least no more than executing a process own stack), so we just
> prevent writes to there.
>=20
> Fixes: d69e3bcf7976 ('IB/mlx5: Mmap the HCA's core clock register to
> 		      user-space')
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--cpUrnqMq9LKO9tEgu9DwJueqKpE4f2MK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNi5aAAoJELgmozMOVy/dRL4P/3qYv3Akhv8rMzq3VuzVz4n/
Oi6+lh3aCsBbwJkyDLR/D2SSLG2+/7Wm6qjRGjIu48nqqmg4aJHo2aPqbpKi6/Po
B2kJUkXC3zbrdrMTLb3ELuunt8wHYMNeK5i90zhwxaa34GMoGIMXKE+OhiAMLtLV
rSvnAleraYMarO6ULzBlpAHQ8gjcWNirpeGSUJNiSiY8ShYwqW4asjB6aASTGT6I
F2FYzFSXVHg6wtPehun/bmU1fUfa9eZO3Z8JgtFbDgJiDSHf1ehFlpM5I8nkRmtE
GRx3uVaa91/Lc9DZHldboohnoxlgtDOxsTXtW38wjvg2GeDYbYUALYA7QJlMX3Ay
Ij98EUm5V9aDqdW+GxWvIn+ETuWyYEtz85e0nzdVjKNYDfWSwrTB+JQSBPBhIsPl
NXKFNt4bYB1LfVVg8/wVuYtdDmKsO4Mi3YBpP2BQZvt4dW0yDLhNyHkK4Ux5UelT
HF3DcHQ9r5vd3nNuayP8Z12TvW2AXNMpe9WTvHieUaVipD4o9r+rY6di8nqLoS23
IKI6qgtSC2CzxgC+KY8pYjWhpFOHL+luWhAdZEvYVyGaMqHLCFqQrNSg1mq0wGx9
ttgA7eh6JKv6szwUyQa/g0EFs143lLQtlzLtB8n25ozz3WTjfbu/ApGmFiAraBip
lzDdgFZrmhvWEqja5ID1
=ptfV
-----END PGP SIGNATURE-----

--cpUrnqMq9LKO9tEgu9DwJueqKpE4f2MK6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
