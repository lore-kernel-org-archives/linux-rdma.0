From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 09/11] RDMA/ocrdma: Add CQ usage statistics
 counters
Date: Fri, 15 May 2015 11:57:45 -0400
Message-ID: <1431705465.29187.8.camel@redhat.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
	 <1431762709-20740-10-git-send-email-selvin.xavier@avagotech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-aSN17AdM+a0OuC3U62yk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-10-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-aSN17AdM+a0OuC3U62yk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2015-05-16 at 13:21 +0530, Selvin Xavier wrote:
> From: Meghana Cheripady <meghana.cheripady-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
>=20
> Add counters for tracking the CQ usage by applications.

This isn't a bug fix, it's an enhancement.  We are already in the
4.1-rc3+ phase, enhancements aren't really appropriate (even if they
seem minor).  Please drop this one from the patchset.

>=20
> Signed-off-by: Meghana Cheripady <meghana.cheripady-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |  2 ++
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  8 ++++++++
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 15 +++++++++++++++
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 ++
>  4 files changed, 27 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/h=
w/ocrdma/ocrdma.h
> index ee9e335..8782e1f 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma.h
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
> @@ -290,6 +290,8 @@ struct ocrdma_dev {
>  	struct dentry *dir;
>  	atomic_t async_err_stats[OCRDMA_MAX_ASYNC_ERRORS];
>  	atomic_t cqe_err_stats[OCRDMA_MAX_CQE_ERR];
> +	atomic_t act_cq_stats;
> +	atomic_t th_cq_stats;
>  	struct ocrdma_pd_resource_mgr *pd_mgr;
>  };
> =20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniban=
d/hw/ocrdma/ocrdma_hw.c
> index 319675c..596d8c9 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -1720,6 +1720,7 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, st=
ruct ocrdma_cq *cq,
>  	struct ocrdma_create_cq *cmd;
>  	struct ocrdma_create_cq_rsp *rsp;
>  	u32 hw_pages, cqe_size, page_size, cqe_count;
> +	int act_cq_cnt, th_cq_cnt;
> =20
>  	if (entries > dev->attr.max_cqe) {
>  		pr_err("%s(%d) max_cqe=3D0x%x, requester_cqe=3D0x%x\n",
> @@ -1808,6 +1809,13 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, s=
truct ocrdma_cq *cq,
> =20
>  	rsp =3D (struct ocrdma_create_cq_rsp *)cmd;
>  	cq->id =3D (u16) (rsp->rsp.cq_id & OCRDMA_CREATE_CQ_RSP_CQ_ID_MASK);
> +
> +	atomic_inc(&dev->act_cq_stats);
> +	act_cq_cnt =3D atomic_read(&dev->act_cq_stats);
> +	th_cq_cnt =3D atomic_read(&dev->th_cq_stats);
> +	if (th_cq_cnt < act_cq_cnt)
> +		atomic_set(&dev->th_cq_stats, act_cq_cnt);
> +
>  	kfree(cmd);
>  	return 0;
>  mbx_err:
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infini=
band/hw/ocrdma/ocrdma_stats.c
> index 48d7ef5..47fef14 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> @@ -146,6 +146,8 @@ static char *ocrdma_resource_stats(struct ocrdma_dev =
*dev)
>  				(u64)rsrc_stats->phy_mr);
>  	pcur +=3D ocrdma_add_stat(stats, pcur, "active_mw",
>  				(u64)rsrc_stats->mw);
> +	pcur +=3D ocrdma_add_stat(stats, pcur, "active_cq_usage_stats",
> +				(u64)atomic_read(&dev->act_cq_stats));
> =20
>  	/* Print the threshold stats */
>  	rsrc_stats =3D &rdma_stats->th_rsrc_stats;
> @@ -200,6 +202,8 @@ static char *ocrdma_resource_stats(struct ocrdma_dev =
*dev)
>  				(u64)rsrc_stats->phy_mr);
>  	pcur +=3D ocrdma_add_stat(stats, pcur, "threshold_mw",
>  				(u64)rsrc_stats->mw);
> +	pcur +=3D ocrdma_add_stat(stats, pcur, "threshold_cq_usage_stats",
> +				(u64)atomic_read(&dev->th_cq_stats));
>  	return stats;
>  }
> =20
> @@ -745,6 +749,16 @@ static const struct file_operations ocrdma_dbg_ops =
=3D {
>  	.write =3D ocrdma_dbgfs_ops_write,
>  };
> =20
> +static void ocrdma_init_cq_stats(struct ocrdma_dev *dev)
> +{
> +	int i, cq_cnt =3D 0;
> +
> +	for (i =3D 0; i < dev->eq_cnt; i++)
> +		cq_cnt +=3D dev->eq_tbl[i].cq_cnt;
> +	atomic_set(&dev->act_cq_stats, cq_cnt);
> +	atomic_set(&dev->th_cq_stats, cq_cnt);
> +}
> +
>  void ocrdma_add_port_stats(struct ocrdma_dev *dev)
>  {
>  	if (!ocrdma_dbgfs_dir)
> @@ -828,6 +842,7 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
>  		goto err;
> =20
>  	mutex_init(&dev->stats_lock);
> +	ocrdma_init_cq_stats(dev);
> =20
>  	return;
>  err:
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.c
> index 9dcb660..48ec56f 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1119,6 +1119,8 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
>  				dev->nic_info.db_page_size);
>  	}
> =20
> +	atomic_dec(&dev->act_cq_stats);
> +
>  	kfree(cq);
>  	return 0;
>  }


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-aSN17AdM+a0OuC3U62yk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVVhd5AAoJELgmozMOVy/dBQcP/1ePssDIvfgi3uuBWNxHLiXB
I0rnCt/MGRIuSkMtiftukAbVHNzgbhai/Co/SzQLkGKKaCUK+0O8oJFEU0QHN2sk
ySMYBwhDmb6eveR2PiBIOk+VmFxZwc8PSJzTAuh7C3mOubnfG8PP1bNsmHe8mlkp
hl3Sw0OX/33ROjXBr5JreLot1ZrvrWc9EpBgGZ/069caSnYCsxudvefGrgWWW026
NwHEkzpwzyVtt8eXOO1xVfFIN+lxLna1le3mYynnsw7U40HFRC6h+l6IhUmrmumh
u16jvw+/twT2rkbalY1tpByHeDHM13fYfSko+r6fP45oUBQOTXjwqrSpiaUFSWd8
sClA33pcl3UPhO/Yd9CRBFlQI/RUoW1J8YICOTEZ9KBDs0lNq97aTJO0/BjM++dL
z1T2jBSkbZx2g+KlJT7X3u1DCJoI4IhTL4ZNCgh65nTdnIC0n/7vp/oPlG86LDpa
oYQj6cr3IjnyjQopNJ3DkYOjQ/7sVobxJFHYST4N8vU4I7UjS+nB3G9fzzXeC3wl
5Ee2ORVEYnfRq2gMOTd9GJAgoBdrbqNJXrOqD/9JfAIVjRaqyD/0pA9XfxCBt8O0
OLSZJWbBNntmuls3i7dwXie3o+Z6WCLQFNmBujWimqZPAXPoQYciLnazJAWRagh3
xMIOB47a8Z+4gJ3t76iD
=RtAC
-----END PGP SIGNATURE-----

--=-aSN17AdM+a0OuC3U62yk--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
