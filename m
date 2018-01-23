From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v5 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Tue, 23 Jan 2018 20:31:30 +0200
Message-ID: <20180123183130.GV1393@mtr-leonro.local>
References: <20180122125119.26419-1-leon@kernel.org>
 <20180122125119.26419-4-leon@kernel.org>
 <20180123175433.GI30670@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XCAZszJJXrQJLz3d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180123175433.GI30670-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XCAZszJJXrQJLz3d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 23, 2018 at 10:54:33AM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 22, 2018 at 02:51:14PM +0200, Leon Romanovsky wrote:
> > +	mutex_lock(&dev->res.mutex);
> > +	hash_del_rcu(&res->node);
> > +	mutex_unlock(&dev->res.mutex);
> > +
> > +	res->valid = false;
> > +
> > +	if (res->task)
> > +		put_task_struct(res->task);
> > +	synchronize_srcu(&dev->res.srcu);
> > +}
>
> This locking is wrong..
>
> Nothing can invalidate internal elements of 'res' until
> synchronize_srcu() returns, otherwise it creates races.
>
> Eg here:
>
> +	key = srcu_read_lock(&device->res.srcu);
> +	hash_for_each_possible_rcu(device->res.hash, res, node, RDMA_RESTRACK_QP) {
> +		if (idx < start) {
> +			idx++;
> +			continue;
> +		}
> +
> +		if ((rdma_is_kernel_res(res) &&
> +		     task_active_pid_ns(current) != &init_pid_ns) ||
> +		    (!rdma_is_kernel_res(res) &&
> +		     task_active_pid_ns(current) != task_active_pid_ns(res->task)))
>
> Will use-after-put res->task
>
> Didn't audit closely enough to tell if valid is OK or not. Why isn't
> the hash_del sufficient? Why does valid exist?

Because, there are mlx5 QPs which partially flows through core code to register
and deregister. Such QPs were created "manually" but destroyed with ib_destroy_qp.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XCAZszJJXrQJLz3d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpnf4IACgkQ5GN7iDZy
WKfLsA//adh7N/bdu2FjPmv3VQQ79XMO4ExflOXnilA9Uw74r/PEt/suOez/rxwy
0HYOCI5pOD2v/RoGy/iWdaQ4/GSB8VeqIUfCoLikqHvXpY8k+7W5BPscRiDpN/3c
+RFX9VAkJyw6gxoLEixfowDpTzvK4WIhVY/5pLx0DURp8Adg6dH1cBrs8Vi888kd
3XqNxadYSlxc5eQr5pl7q8RR2rwAmsHSGxy1mR9O4/W7U4zfmou1AcroPQne7YoO
bPUCa5TiyZafJDAxqJnnm0NSDLluS/43BU5n257mO3QIpU41zF3kEh0CF0jgvGB1
qoxs20V1YCMwb0mjUdZeScDlpZcjZDQwqvzoNBIbJR7Shz6MJqgWAecGphwkT3lE
e55WlZTVTpMh0TDNOS56X1xDyrxikDKm83EcIMOW8zCMQQg4ExnQP6Yp0CRYoIfz
g7+XiLKiR4W4f+AIxUAdicr0plu4pSnLhHO2IxvqAlDxT9TyNIJyrahDiree9WjV
mlJ4dytbFRjrC9CrKYacCst6vPHDL7jOBR1886ItjYgqouSvUSEE1JAbdfJVw3Be
x6tOkT2w7udbsnNeIMbj7kggkxCu4zDRnPxnTqTHz886UyDeoaEtpOa4KIcnGYvQ
10q/83HGl9l1ogqPJ5GgRR8rrKcaJeWys3yUNWAh6H41/D76LEk=
=DAD7
-----END PGP SIGNATURE-----

--XCAZszJJXrQJLz3d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
