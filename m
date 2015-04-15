From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/ipoib: Handle QP in SQE state
Date: Wed, 15 Apr 2015 08:08:00 -0400
Message-ID: <13F95634-36B6-4759-A300-E140CB7FF70D@redhat.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com> <1427971145-26943-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2074.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AEF88CB1-3FBF-4293-9349-941D5AABFBB0"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427971145-26943-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_AEF88CB1-3FBF-4293-9349-941D5AABFBB0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Apr 2, 2015, at 6:39 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> As the result of a completion error the QP can moved to SQE state by
> the hardware. Since it's not the Error state, there are no flushes
> and hence the driver doesn't know about that.
>=20
> The fix creates a task that after completion with error which is not a
> flush tracks the QP state and if it is in SQE state moves it back to =
RTS.

I assume you found this particular issue while tracking down the cause =
of the problem that you fixed in patch #6?  Otherwise, this is a =
=E2=80=9Cnever should happen=E2=80=9D situation, yes?

> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> drivers/infiniband/ulp/ipoib/ipoib.h    |    5 +++
> drivers/infiniband/ulp/ipoib/ipoib_ib.c |   59 =
++++++++++++++++++++++++++++++-
> 2 files changed, 63 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h =
b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 769044c..2703d9a 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -299,6 +299,11 @@ struct ipoib_neigh_table {
> 	struct completion		deleted;
> };
>=20
> +struct ipoib_qp_state_validate {
> +	struct work_struct work;
> +	struct ipoib_dev_priv   *priv;
> +};

Why did you choose to do an allocated work struct?  All of the other =
tasks we have use a static work struct that=E2=80=99s part of the ipoib =
private dev, so this is a bit out of the norm.  In its current form, you =
only use this on the single UD queue pair that the dev uses, and not =
ever on any connected mode queue pairs, so it could be static.  Or were =
you looking at the possibility of making the task work on the CM queue =
pairs and so left it allocated?  And if that, why not include a =
reference to the broken queue pair in the work struct instead of always =
using priv->qp?

> /*
>  * Device private locking: network stack tx_lock protects members used
>  * in TX fast path, lock protects everything else.  lock nests inside
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c =
b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 29b376d..63b92cb 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -327,6 +327,51 @@ static void ipoib_dma_unmap_tx(struct ib_device =
*ca,
> 	}
> }
>=20
> +/*
> + * As the result of a completion error the QP Can be transferred to =
SQE states.
> + * The function checks if the (send)QP is in SQE state and
> + * moves it back to RTS state, that in order to have it functional =
again.
> + */
> +static void ipoib_qp_state_validate_work(struct work_struct *work)
> +{
> +	struct ipoib_qp_state_validate *qp_work =3D
> +		container_of(work, struct ipoib_qp_state_validate, =
work);
> +
> +	struct ipoib_dev_priv *priv =3D qp_work->priv;
> +	struct ib_qp_attr qp_attr;
> +	struct ib_qp_init_attr query_init_attr;
> +	int ret;
> +
> +	ret =3D ib_query_qp(priv->qp, &qp_attr, IB_QP_STATE, =
&query_init_attr);
> +	if (ret) {
> +		ipoib_warn(priv, "%s: Failed to query QP ret: %d\n",
> +			   __func__, ret);
> +		goto free_res;
> +	}
> +	pr_info("%s: QP: 0x%x is in state: %d\n",
> +		__func__, priv->qp->qp_num, qp_attr.qp_state);
> +
> +	/* currently support only in SQE->RTS transition*/
> +	if (qp_attr.qp_state =3D=3D IB_QPS_SQE) {
> +		qp_attr.qp_state =3D IB_QPS_RTS;
> +
> +		ret =3D ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE);
> +		if (ret) {
> +			pr_warn("failed(%d) modify QP:0x%x SQE->RTS\n",
> +				ret, priv->qp->qp_num);
> +			goto free_res;
> +		}
> +		pr_info("%s: QP: 0x%x moved from IB_QPS_SQE to =
IB_QPS_RTS\n",
> +			__func__, priv->qp->qp_num);
> +	} else {
> +		pr_warn("QP (%d) will stay in state: %d\n",
> +			priv->qp->qp_num, qp_attr.qp_state);
> +	}
> +
> +free_res:
> +	kfree(qp_work);
> +}
> +
> static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc =
*wc)
> {
> 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> @@ -358,10 +403,22 @@ static void ipoib_ib_handle_tx_wc(struct =
net_device *dev, struct ib_wc *wc)
> 		netif_wake_queue(dev);
>=20
> 	if (wc->status !=3D IB_WC_SUCCESS &&
> -	    wc->status !=3D IB_WC_WR_FLUSH_ERR)
> +	    wc->status !=3D IB_WC_WR_FLUSH_ERR) {
> +		struct ipoib_qp_state_validate *qp_work;
> 		ipoib_warn(priv, "failed send event "
> 			   "(status=3D%d, wrid=3D%d vend_err %x)\n",
> 			   wc->status, wr_id, wc->vendor_err);
> +		qp_work =3D kzalloc(sizeof(*qp_work), GFP_ATOMIC);
> +		if (!qp_work) {
> +			ipoib_warn(priv, "%s Failed alloc =
ipoib_qp_state_validate for qp: 0x%x\n",
> +				   __func__, priv->qp->qp_num);
> +			return;
> +		}
> +
> +		INIT_WORK(&qp_work->work, ipoib_qp_state_validate_work);
> +		qp_work->priv =3D priv;
> +		queue_work(priv->wq, &qp_work->work);
> +	}
> }
>=20
> static int poll_tx(struct ipoib_dev_priv *priv)
> --
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_AEF88CB1-3FBF-4293-9349-941D5AABFBB0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVLlShAAoJELgmozMOVy/dyWMP/2ay3XbgK2dwoAnnWI0bGq4w
YWyDZAKUrW8yd5hfXbVfk2DR5+Q8tX3qayobQOKbBGedCPNPQGywuh6AGdNqtqZQ
0pPy8HIKH3BQPG/QuXU8YQs5asXFhEelGIOnjL9BYwXHYkB0ig5RmTJPHEa/3mYZ
z935t/1aYBhSEVzb0D0F5Mo+taiml6XXeZImLJFrqw+ajYjlyZQuSF4gorVZaJbO
dYiSKhwkBmPYZ2Qiq4JeoHgdPg2ObQshS/MlakMdrVMB/Sgvz84bt2EA8hODKkEU
EN47Z0hU6PpCguSqmHv2wo9iDVor81daVGoL0BTQj30fkouuGpN2YHk+C3RjW06q
a2cpBwHf5GYrwf8EC3dDxLvfrxAwj4FEBuTGshpVegNnAoB2dIigCexdExhEujxC
bd6j6MubYJjEPuwv5LID3F3PzKg0kGthkpxdwRLioZrXTi8Xr1xCR+eG6ReMjN4/
F1+dTe7gHGvG+ilaLFRbyX5m2T35FlKCTGfZd1EwOpwoPC+IY7OlaBgUuxkZ5ZAD
KG1IiXBqP1IdLtXfMUNuUXmRtxSYlWCHKcjxmwdVxXRDjrsP3og1rwYpx+U++bbt
W5G6wjuj9/WqvVlvUVAaz1MyQpmMc/k97GCyPFXCzVWYiC1k9qgBIVtS966e296Z
5XHYw2dCPJcJ5bvgvKi7
=8EyA
-----END PGP SIGNATURE-----

--Apple-Mail=_AEF88CB1-3FBF-4293-9349-941D5AABFBB0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
