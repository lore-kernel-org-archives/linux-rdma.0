From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/1] i40iw: do not print unitialized variables in error
 message
Date: Tue, 12 Jul 2016 10:59:42 -0400
Message-ID: <7bdfd597-dfc1-fe40-8ea8-de66d4d2d5b3@redhat.com>
References: <20160625155507.23961-1-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Vx5MuB1p6m7lh4eU1UAmA13T30THUpQK6"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160625155507.23961-1-nicolas.iooss_linux@m4x.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Faisal Latif <faisal.latif@intel.com>, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vx5MuB1p6m7lh4eU1UAmA13T30THUpQK6
Content-Type: multipart/mixed; boundary="BufbbiagGglxKqWfVpIJsPUomjrEhn6C7"
From: Doug Ledford <dledford@redhat.com>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>,
 Faisal Latif <faisal.latif@intel.com>,
 Chien Tin Tung <chien.tin.tung@intel.com>,
 Mustafa Ismail <mustafa.ismail@intel.com>,
 Shiraz Saleem <shiraz.saleem@intel.com>,
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <7bdfd597-dfc1-fe40-8ea8-de66d4d2d5b3@redhat.com>
Subject: Re: [PATCH 1/1] i40iw: do not print unitialized variables in error
 message
References: <20160625155507.23961-1-nicolas.iooss_linux@m4x.org>
In-Reply-To: <20160625155507.23961-1-nicolas.iooss_linux@m4x.org>

--BufbbiagGglxKqWfVpIJsPUomjrEhn6C7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/25/2016 11:55 AM, Nicolas Iooss wrote:
> i40iw_create_cqp() printed the contents of variables maj_err and min_er=
r
> in an error message before they could be initialized (by calling
> dev->cqp_ops->cqp_create).
>=20
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Applied, thanks.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--BufbbiagGglxKqWfVpIJsPUomjrEhn6C7--

--Vx5MuB1p6m7lh4eU1UAmA13T30THUpQK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQXeAAoJELgmozMOVy/d8QwQALwf6qDqm8d9stwXrUoUNmpu
V+ri2mzWztR6p5CrncqMj3V8SIecVenhhpegbQAkEP/33v03OnJ9tzdxtcXTMMOn
YLE9+uBVmUnmfZ+MfzGE6399H6oT8CAeKNsTWLZlxGkYHCcWAbKrcQym1ieueBfm
AtYXxyCla7jEWJzhMJR7uvFMtC/XN6QgXFw6d/rSaCUK23WQhFEw49kfqYGpt088
k9WYvj2hCReQskqjTMgSgXkIkFwDUZWbBoO0HuRjRoo8NH7KTUXpVgFYe5oTOf92
SJuQnKY6sRzjh1lXPPqLlFCnw4kHLXMAo/LZV6xYcrAJNwduEBmsVSVhGQbBedzw
sF2TR5dwNSzHXZuxBY1tRtWfilf/a0OxD6xMEvxzQDetYk2iytJfmpQlPVf9F5uD
tn4IYOTv+jJOfSXjFLRV1nb+p1rPS1TkdOF/yxx3r0lOwu6Jtmyxh2dTTaJzfWi/
ZNAfP7eTvSI6yWM01/IOZcjYHJ5v8WqzkUijs4vlNjyhIQpfOQT03pI5JWfVtdeS
d7xrLnjkDRIMt4SxCxHNKXdc9HojioO4nD0Ni+nTLAUxI5c1qJsJ5uJnPUXr1VoX
pWsj6eUYuZuDC4OI8lup6OcZ7Vc7qkHUEGFMDinFyJkypGeHnlAQG2R3tJd7XQhx
aoUUiQYmFFTCCgnDRCdA
=yHge
-----END PGP SIGNATURE-----

--Vx5MuB1p6m7lh4eU1UAmA13T30THUpQK6--
