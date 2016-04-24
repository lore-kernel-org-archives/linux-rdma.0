From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Sun, 24 Apr 2016 11:35:38 +0300
Message-ID: <20160424083538.GF7974@leon.nu>
References: <571A936F.7040409@sandisk.com>
 <571A94AF.7000609@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XIiC+We3v3zHqZ6Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571A94AF.7000609-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XIiC+We3v3zHqZ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 22, 2016 at 02:16:31PM -0700, Bart Van Assche wrote:
> If both max_sectors and the queue_depth are high enough it can
> happen that the MR pool is depleted temporarily. This causes
> the SRP initiator to report mapping failures. Although the SRP
> initiator recovers from such mapping failures, prevent that
> this can happen by limiting max_sectors.
>=20
> Reported-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>=20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
> index a173ec4..ebd4d90 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3172,6 +3172,7 @@ static ssize_t srp_create_target(struct device *dev,
>  	struct srp_device *srp_dev =3D host->srp_dev;
>  	struct ib_device *ibdev =3D srp_dev->dev;
>  	int ret, node_idx, node, cpu, i;
> +	unsigned int max_max_sectors;
>  	bool multich =3D false;
> =20
>  	target_host =3D scsi_host_alloc(&srp_template,
> @@ -3228,6 +3229,25 @@ static ssize_t srp_create_target(struct device *de=
v,
>  		target->sg_tablesize =3D target->cmd_sg_cnt;
>  	}
> =20
> +	if (srp_dev->use_fast_reg || srp_dev->use_fmr) {
> +		/*
> +		 * FR and FMR can only map one HCA page per entry. If the
> +		 * start address is not aligned on a HCA page boundary two
> +		 * entries will be used for the head and the tail although
> +		 * these two entries combined contain at most one HCA page of
> +		 * data. Hence the "- 1" in the calculation below.
> +		 */
> +		max_max_sectors =3D (srp_dev->max_pages_per_mr - 1) <<
> +				  (ilog2(srp_dev->mr_page_size) - 9);

=46rom my understanding, srp_dev->max_pages_per_mr can be equal to 1, in
case device will advertise it.

Is this understanding correct?
Will the code work in such case?

> +		if (target->scsi_host->max_sectors > max_max_sectors) {
> +			shost_printk(KERN_WARNING, target->scsi_host,
> +				     PFX "Reducing max_sectors from %d to %d\n",
> +				     target->scsi_host->max_sectors,
> +				     max_max_sectors);
> +			target->scsi_host->max_sectors =3D max_max_sectors;
> +		}
> +	}
> +
>  	target_host->sg_tablesize =3D target->sg_tablesize;
>  	target->mr_pool_size =3D target->scsi_host->can_queue;
>  	target->indirect_size =3D target->sg_tablesize *
> --=20
> 2.8.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XIiC+We3v3zHqZ6Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXHIVZAAoJEORje4g2clinnU4QAKRgFRS90Z+Ehs3AWE62F/Va
32A1p/UEt6e19O3DOueEtDc//dJZkjbHla6USL4xAtqdrLMAw9kKjbY+zy2236vz
sT2riGxrRiplVShTRaJ6g6GJ6VyRU0miKyTr7qSsQZOZHVCbIbat74Uu999kDAYH
ShPPkEMRD09RwIYE15oXPT7zgpx2bg74EKK9HKbRoYykijtfKXBXUqM6IC3mYenh
SQRG3jaHOfQx9T0XVoR3XfHNlgEBz0A5Ky203NrP7VpY6t1LGJ2jjn8w/oBOGJzn
KWfGDXPFK2dfmwUciYmXDAMor54hTl7RjvI2epuXJ0oRLYA4MAO44AzDqsA26psp
D0GnCSwzTZi/mf77NbNOQsMIh9DI6I+PZJ6ZC7/QbRk7bFLwvM+H5/Ipr3kW2oi8
CFqQ1JriRQT7Acn+wNvn2/v1z1zvaEXjwXScV3gM+AGp3xWA7S0trYVv88IfD24i
jntHoG/NHtlfJwPXLcO1i9ADxVl3Mqw1XzgQWUeTFcQKo1pWrMMcS7qB8auUIE+u
sfPcJqSXiVVY8tqrA2KO/qZwAzzaEVc1HojSc8uuMS917Ev4gQnufNY8Clb7oK1Z
1fvNgGOcu71pccNVNJu3wohsdFqtZW27VCGqxUNVUq+SZpMyVRolYGEJwZXajqsr
REw2zuEYAZ+hxVac4cWd
=akas
-----END PGP SIGNATURE-----

--XIiC+We3v3zHqZ6Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
