From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: librdmacm in rdma-core build warnings
Date: Mon, 2 Oct 2017 09:15:32 +0300
Message-ID: <20171002061532.GJ2031@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cN519qCC4CN1mUcX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cN519qCC4CN1mUcX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

After moving to gcc version 7.2.0 (GCC), I started experience the
following compilation warning with default build.sh supplied with
rdma-core.

[26/189] Building C object librdmacm/CMakeFiles/rspreload.dir/preload.c.o
=2E./librdmacm/preload.c:818:9: warning: no previous prototype for =E2=80=
=98readv=E2=80=99 [-Wmissing-prototypes]
 ssize_t readv(int socket, const struct iovec *iov, int iovcnt)
         ^~~~~
=2E./librdmacm/preload.c:857:9: warning: no previous prototype for =E2=80=
=98writev=E2=80=99 [-Wmissing-prototypes]
 ssize_t writev(int socket, const struct iovec *iov, int iovcnt)

The code to enable -Wmissing-prototypes checks is part of the rdma-core
for a year now, see commit: b192ed2347e5 ("Enable -Wmissing-prototypes/-Wmi=
ssing-declarations")

The fact that librdmacm/preload.c uses combination of RTLD_NEXT and
dlsym to set readv/writev scares me to just delete readv and writev calls,
because it is most probably wrong.

Any ideas how to fix it?

Thanks

--cN519qCC4CN1mUcX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnR2YQACgkQ5GN7iDZy
WKdTsQ//XU2m2YCoBV/FwEROdsrN89eNFIY/RMMmBXP4NcfC0s1iIImfEXf3yQuS
Zhcwkdvt//CU9NjDMUDEZzjEWbCEhPZNZS47IKF2ToUgK4xz6ETLeAqNdy9IzyYS
hX16KYaLbfvg36zjLAwvq3uVLQnJetyG4uDX60Qz560xCEvozmSiL7c3oPtbWL5q
Q0JfA02mc+E6puE8RWBcEnH7Tg1GWbb4rNmf+ePf7iW2JR30PjcXp7Fk88N8OEt0
Ltjux9p4Uevamfa3nNp9O6XOdbRvlUHZPYX9EXqd4E40bd0sCClwq279/vC5+7vw
3CxUuOWplc+nzBLSzhkJ04C68VD/+UgM8FSiJYOQNepKtWN1RO/KC+D5uTZG89Xm
iP3R3aDK3KNcVVfAc5tHGDQNYQwY3GcJBsCBzLsnGJZhX9OpfRkEgERWJOOujRzo
jCBFSS1nHNB64Q5M0LLhhybgONPbPesHkt8NMDB3g0HVtawKEW3L0wXJtMqkwDPn
8ub4aGFq346Qjs5lQy+v1gBxtIlskX9LnLYHEbdlBU39hW3Yzu9PvvkSDMte9OaQ
Wbpvxd44yXsk4ZbgdkMkzraW4u0QjnB2NkKpHF1rZKa5oGyzP9GAKbCBXU2/Jzf+
UTw10N0sarHhU+OxXW918tzgg+WhtsDfKTpxDwYxJiVwYY7QRWQ=
=16Qz
-----END PGP SIGNATURE-----

--cN519qCC4CN1mUcX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
