From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] rds: ib: Fix missing call to rds_ib_dev_put in
 rds_ib_setup_qp
Date: Wed, 25 Apr 2018 15:48:51 +0200
Message-ID: <67AE1ED5-55ED-4572-92E9-9FCE18C824A5@oracle.com>
References: <1524655321-8379-1-git-send-email-dag.moxnes@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524655321-8379-1-git-send-email-dag.moxnes@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dag Moxnes <dag.moxnes@oracle.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, OFED mailing list <linux-rdma@vger.kernel.org>, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 25 Apr 2018, at 13:22, Dag Moxnes <dag.moxnes@oracle.com> wrote:
>=20
> The function rds_ib_setup_qp is calling rds_ib_get_client_data and
> should correspondingly call rds_ib_dev_put. This call was lost in
> the non-error path with the introduction of error handling done in
> commit 3b12f73a5c29 ("rds: ib: add error handle")
>=20
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>

Reviewed-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>


Thxs, H=C3=A5kon

> ---
> net/rds/ib_cm.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index eea1d86..13b38ad 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -547,7 +547,7 @@ static int rds_ib_setup_qp(struct rds_connection =
*conn)
> 	rdsdebug("conn %p pd %p cq %p %p\n", conn, ic->i_pd,
> 		 ic->i_send_cq, ic->i_recv_cq);
>=20
> -	return ret;
> +	goto out;
>=20
> sends_out:
> 	vfree(ic->i_sends);
> @@ -572,6 +572,7 @@ static int rds_ib_setup_qp(struct rds_connection =
*conn)
> 		ic->i_send_cq =3D NULL;
> rds_ibdev_out:
> 	rds_ib_remove_conn(rds_ibdev, conn);
> +out:
> 	rds_ib_dev_put(rds_ibdev);
>=20
> 	return ret;
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
