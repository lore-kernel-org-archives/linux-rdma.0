From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iSER-Target: Release connection resources
 properly when receiving RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Wed, 27 Jul 2016 19:28:22 +0300
Message-ID: <20160727162822.GL4628@leon.nu>
References: <20160727050918.12772-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrM5Z5VIJgwP9LWp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160727050918.12772-1-rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nrM5Z5VIJgwP9LWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 10:39:18AM +0530, Raju Rangoju wrote:
> When the low level driver exercises the hot unplug they would call
> rdma_cm cma_remove_one which would fire DEVICE_REMOVAL event to all cma
> consumers. Now, if consumer doesn't make sure they destroy all IB
> objects created on that IB device instance prior to finalizing all
> processing of DEVICE_REMOVAL callback, rdma_cm will let the lld to
> de-register with IB core and destroy the IB device instance. And if the
> consumer calls (say) ib_dereg_mr(), it will crash since that dev object
> is NULL.
>=20
> In the current implementation, iser-target just initiates the cleanup
> and returns from DEVICE_REMOVAL callback. This deferred work creates a
> race between iser-target cleaning IB objects(say MR) and lld destroying
> IB device instance.
>=20
> This patch includes the following fixes
>   -> make sure that consumer frees all IB objects associated with device
>      instance
>   -> return non-zero from the callback to destroy the rdma_cm id
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 24 ++++++++++++++++++++++--
>  drivers/infiniband/ulp/isert/ib_isert.h |  2 ++
>  2 files changed, 24 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index a990c04..9adc38d 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -405,6 +405,7 @@ isert_init_conn(struct isert_conn *isert_conn)
>  	INIT_LIST_HEAD(&isert_conn->node);
>  	init_completion(&isert_conn->login_comp);
>  	init_completion(&isert_conn->login_req_comp);
> +	init_waitqueue_head(&isert_conn->rem_wait);
>  	kref_init(&isert_conn->kref);
>  	mutex_init(&isert_conn->mutex);
>  	INIT_WORK(&isert_conn->release_work, isert_release_work);
> @@ -580,7 +581,8 @@ isert_connect_release(struct isert_conn *isert_conn)
>  	BUG_ON(!device);
> =20
>  	isert_free_rx_descriptors(isert_conn);
> -	if (isert_conn->cm_id)
> +	if (isert_conn->cm_id &&
> +	    !isert_conn->dev_removed)
>  		rdma_destroy_id(isert_conn->cm_id);
> =20
>  	if (isert_conn->qp) {
> @@ -595,7 +597,10 @@ isert_connect_release(struct isert_conn *isert_conn)
> =20
>  	isert_device_put(device);
> =20
> -	kfree(isert_conn);
> +	if (isert_conn->dev_removed)
> +		wake_up_interruptible(&isert_conn->rem_wait);
> +	else
> +		kfree(isert_conn);
>  }
> =20
>  static void
> @@ -755,6 +760,7 @@ static int
>  isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>  {
>  	struct isert_np *isert_np =3D cma_id->context;
> +	struct isert_conn *isert_conn;
>  	int ret =3D 0;
> =20
>  	isert_info("%s (%d): status %d id %p np %p\n",
> @@ -778,6 +784,20 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct =
rdma_cm_event *event)
>  	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
>  	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
>  		ret =3D isert_disconnected_handler(cma_id, event->event);
> +
> +		if (event->event =3D=3D RDMA_CM_EVENT_DEVICE_REMOVAL) {

It will be nicer if you can reshuffle cases in original switch in such
was that will eliminate the need of this "if".

> +			isert_conn =3D cma_id->qp->qp_context;
> +			isert_conn->dev_removed =3D true;
> +			wait_event_interruptible(isert_conn->rem_wait,
> +					 isert_conn->state =3D=3D ISER_CONN_DOWN);
> +
> +			kfree(isert_conn);
> +			 /*
> +			  * return non-zero from the callback to destroy
> +			  * the rdma cm id
> +			  */
> +			return 1;
> +		}
>  		break;
>  	case RDMA_CM_EVENT_REJECTED:       /* FALLTHRU */
>  	case RDMA_CM_EVENT_UNREACHABLE:    /* FALLTHRU */
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband=
/ulp/isert/ib_isert.h
> index e512ba9..d0c5c2c 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.h
> +++ b/drivers/infiniband/ulp/isert/ib_isert.h
> @@ -159,6 +159,8 @@ struct isert_conn {
>  	struct work_struct	release_work;
>  	bool                    logout_posted;
>  	bool                    snd_w_inv;
> +	wait_queue_head_t       rem_wait;
> +	bool                    dev_removed;
>  };
> =20
>  #define ISERT_MAX_CQ 64
> --=20
> 2.8.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nrM5Z5VIJgwP9LWp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmOEmAAoJEORje4g2clinfMAP+gKgh9Uwn9FrkpAO/6V7luNS
8zIIY27NC7SjSiG8B2kZXebFmObQ05ccvjnPWq+pAW1QrU3tYTWTj2hysOS2nytI
M1zjUfSPX4IxTqCIJHKkeRqIAHJmhRsDNlMhM4R1VDB/6cz73Is95f4ZaEDeDnFB
5EKGk7rH59iRQPoqLvIyQSppijZxGLISct2yGM44MAjbpfscxJVIi8JQwGFVREtB
Dms1Hq54sICqoiLLOMzCqaZUEwG7D7Pe/l+llaXaYlra3cegxCXIx0/MuI2TAP1D
ppsWsEasb1OrZT8uPn+o/KqrIVxfNgJUuZ0UZ55iTUBWUkVUWEwY7gdHtEZk8g6e
43xZSDf8Thelc/bOvTE+9FBm2bz7ccVvsV3Yb74gopg4yNZNYoizMqRNJCB6gTT0
Ln0co41gxHHfPyfCncg4W1RJbW4fB+zGQMAv0B3RcYzxN9X0LpVayrHAgi56w5xX
KF2k+Tjw2D7pKfd8GX3FoD8JMrzdhh1gBDylMMR9vJ00R8kCQdDSLkVrdyKYfk8q
bZ3pymM006g/WULa340myYqdUM5k33H716fmDYTdVLJThppp5ttImvqNdGsQFieq
4rr0NI7yPsKkoI5gxl4MXS5nbVGD9EN9CfEkh1yWfvIjJun4NFxS+QdBZJCuHZ0Z
e/4foL97Eci+R3TXE+C6
=9ZDD
-----END PGP SIGNATURE-----

--nrM5Z5VIJgwP9LWp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
