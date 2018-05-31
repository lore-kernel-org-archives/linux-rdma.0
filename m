From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] qed: Add srq core support for RoCE and iWARP
Date: Thu, 31 May 2018 20:33:01 +0300
Message-ID: <20180531173301.GV3697@mtr-leonro.mtl.com>
References: <20180530131137.4653-1-yuval.bason@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AYsPlKobQGgtCvjI"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530131137.4653-1-yuval.bason@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Yuval Bason <yuval.bason@cavium.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org, Michal Kalderon <michal.kalderon@cavium.com>, Ariel Elior <ariel.elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org


--AYsPlKobQGgtCvjI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 30, 2018 at 04:11:37PM +0300, Yuval Bason wrote:
> This patch adds support for configuring SRQ and provides the necessary
> APIs for rdma upper layer driver (qedr) to enable the SRQ feature.
>
> Signed-off-by: Michal Kalderon <michal.kalderon@cavium.com>
> Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
> Signed-off-by: Yuval Bason <yuval.bason@cavium.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_cxt.c   |   5 +-
>  drivers/net/ethernet/qlogic/qed/qed_cxt.h   |   1 +
>  drivers/net/ethernet/qlogic/qed/qed_hsi.h   |   2 +
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c |  23 ++++
>  drivers/net/ethernet/qlogic/qed/qed_main.c  |   2 +
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c  | 179 +++++++++++++++++++++++++++-
>  drivers/net/ethernet/qlogic/qed/qed_rdma.h  |   2 +
>  drivers/net/ethernet/qlogic/qed/qed_roce.c  |  17 ++-
>  include/linux/qed/qed_rdma_if.h             |  12 +-
>  9 files changed, 235 insertions(+), 8 deletions(-)
>

...

> +	struct qed_sp_init_data init_data;

...

> +	memset(&init_data, 0, sizeof(init_data));

This patter is so common in this patch, why?

"struct qed_sp_init_data init_data = {};" will do the trick.

Thanks

--AYsPlKobQGgtCvjI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbEDHNAAoJEORje4g2clinpZYP/3VV80y/PljD5m7lIMD6XgBM
MKvLaeefcrJ8nJt9SdaJ3zSR/nZ5vnUoRsE/fFL3S2DQ6+0uC6IAF5od9pcinX2X
U85n1EsrZDiWB3577yyvjPEU8dQlnYQVR9SGtNPYDkYcU9py1KBtSHh5QN4IQJmo
895f40SwPuqRjXD3vnyxuvPW+zi5jXh9Dz5YUmVRvn1NyO0h4sKU+hpJag90XQy2
8gptqvZ2MgJ/JlWuBjo4ecqpKqE9YIZ+TCmigQ07XAjNMM/Cdn2PaJrARFfNkpcg
Im/8+w6w6aqzBrNxEucJTPrP/eOcxkRcyoDL6RKo9S83MQNXOhkPq4/FkUzdWlSh
C/4xS2miiG1fA52QEHZ3TMGMgf9NUdIBbL32ANqyIOSzXoIHLItVUhOhJin0gwPZ
GBc57lng331px/R+Ljn/JhMi0EtQKF9Yv+0YNlZxBTB7hnXyGu2HsaiLNrCTLbs1
0Uao9TtJDj7WF0jn84JB5h2IOmyaJDUEDp088LSWKdkfGjwYMT9uDaJ/+JxKoB+9
tODUMp8EYFtcdMNfqJrionhuaSsBRKmbU9SrPPJuMl5SWGgdsgc/4ufWMtpgnjap
sum/ZDTauN3WTAF0N+JLgxG6b3VgnawGJTQOFkhubscM14TpqC4LY7iOyOkHETyd
osxNQhzlzpsR881wm0R+
=DcZo
-----END PGP SIGNATURE-----

--AYsPlKobQGgtCvjI--
