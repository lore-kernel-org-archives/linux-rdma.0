From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 2/4] rdma: add helper rd_sendrecv_msg()
Date: Mon, 1 Apr 2019 09:29:17 +0300
Message-ID: <20190401062917.GD8348@mtr-leonro.mtl.com>
References: <cover.1553627811.git.larrystevenwise@gmail.com>
 <06a2302a1dc575a0829a5b789bb7a412adb2ce95.1553627811.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <06a2302a1dc575a0829a5b789bb7a412adb2ce95.1553627811.git.larrystevenwise@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <larrystevenwise@gmail.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 26, 2019 at 02:18:28PM -0500, Steve Wise wrote:
> This function sends the constructed netlink message and then
> receives the response.
>
> Change rd_recv_msg() to display any error messages.
>
> Change 'rdma dev set' to use rd_sendrecv_msg().
>
> Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
> ---
>  rdma/dev.c   |  2 +-
>  rdma/rdma.h  |  2 ++
>  rdma/res.h   |  1 +
>  rdma/utils.c | 18 ++++++++++++++++++
>  4 files changed, 22 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcoa+9AAoJEORje4g2clinHlkQAL5RAs1VXVQjDSZhetmgTwNH
xRjebaFasVZbzd+IVsIXSlqDQuRJp/GsUzAlfY4IlnrY8ihmwiIsTV2cY6zBDhVL
3pqkzNY+ABvuZYWu5cJHnySdVBILA3dQox25k7vcmLk8uz0gE/u4m5UPFvQO1Qlc
9E9srE5vRdtjmlFqUZnw/aO0RKmGoeQC+4/VDKohkLtOQgOr724a4v9XeCfWQxgf
YoJEClli3+sE0hPclQYuAu+SynVW7cyJ9RZaYjSdMxPe1TYJc5UiHnqr2/93U4RB
2SAz/KMrx/wA7dO8WAVRdbRrrZpJAMRWqIXDqst+ybwFAawDMVCg/amLtKzOIDXM
LS/+6rP6vDV1x+lZ8LBNXv7RnO32PRmotY0r3YJgVRhgu/qaoWgJU8Nf32B887WT
BypwZGTyXQpolQ+DXdVnf2kko4v93X/ukn2XGEkxGFwbrG3Oz7T7irwobUOnZFf/
TBXV9Z2yMIwFwRI7bPmpX6gtlp8F1XwNMV/1jKJ0lROZUFFdL4HvAtf7G/2Pm9IP
LQF28LHKdEPwJj6X/4JUvGYaUvJllQZ2KisOdAz0OUjklNaEus7ZpMR/taFC14/r
MRd80Mntye3/gqdo1eZUtjmdSBmOfqTrVWS8fphMuJSZD0PHS95e5jwWOVSac9u6
uekcoZVeaaBixEf9dp1T
=7AOD
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
