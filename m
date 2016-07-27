From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send
 limit
Date: Wed, 27 Jul 2016 15:42:17 +0300
Message-ID: <20160727124217.GJ4628@leon.nu>
References: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
 <c71ece34-36e2-86da-5032-2fc946ff0073@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwgQ89ZNnFUwFHTC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c71ece34-36e2-86da-5032-2fc946ff0073-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--rwgQ89ZNnFUwFHTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 21, 2016 at 01:03:30PM -0700, Bart Van Assche wrote:
> Compute the SGE limit for RDMA READ and WRITE requests in
> ib_create_qp(). Use that limit in the RDMA RW API implementation.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
> ---
>  drivers/infiniband/core/rw.c    | 10 ++--------
>  drivers/infiniband/core/verbs.c |  9 +++++++++
>  include/rdma/ib_verbs.h         |  6 ++++++
>  3 files changed, 17 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index 1ad2baa..dbfd854 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -58,13 +58,6 @@ static inline bool rdma_rw_io_needs_mr(struct ib_devic=
e *dev, u8 port_num,
>  	return false;
>  }
> =20
> -static inline u32 rdma_rw_max_sge(struct ib_device *dev,
> -		enum dma_data_direction dir)
> -{
> -	return dir =3D=3D DMA_TO_DEVICE ?
> -		dev->attrs.max_sge : dev->attrs.max_sge_rd;
> -}
> -
>  static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
>  {
>  	/* arbitrary limit to avoid allocating gigantic resources */
> @@ -186,7 +179,8 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *c=
tx, struct ib_qp *qp,
>  		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
>  {
>  	struct ib_device *dev =3D qp->pd->device;
> -	u32 max_sge =3D rdma_rw_max_sge(dev, dir);
> +	u32 max_sge =3D dir =3D=3D DMA_TO_DEVICE ? qp->max_write_sge :
> +		      qp->max_read_sge;

Bart,
I'm sure that I missed something.

Can "dir" be DMA_BIDIRECTIONAL?
If yes, mxa_sge will be min(max_write_sge, max_read_sge).

--rwgQ89ZNnFUwFHTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmKwpAAoJEORje4g2clin49MQAJ5j3ZVTowvwKrsdbu3wIRyX
8Wc+Og9GHFu5cPRyZLw2n3IHCreUMV5eRnx3cpcun8kwhhPoRh0aqDOGl9TXg8bm
3wZdG1NkFQXZ/ut5GP+HTQANde+J6yBkSXIKTxaXJgq1k/RhxEF8WtERhp96nOnz
3DM4V8ERyzlmwW5kDyH8Ii6aNd8JudJWo07DkQpBRu84EUlC0XGGYn+gsVv7mRQg
nR/vqOH2vZEL2vHiUINAOpdPZaM2QH+vWZyT5Yf0D+dPq9ZVxeA7ImMFV/5nVwQE
88cfkJdTHPbWv3vpUmOdIPEKbYs4XuXaGigbnmLUDHmfrsgoZX+aHm9Nqs6k5miR
hztIY98KmN1bJdmEz+jvuDvdMIVdLthOGiIcqafdOVjZColRUoX97cceZRDo1d0K
5uM90pRGkghQDMfLtMvlMDA1wxz0Bq16SlarJJBwbEn478im5tT+jWPG5xXDg8ut
3T0Kz5Jpq0j119Bd/sMRYN65l5KE3CMP2YHULhuxRqE5J+s5nJ13y7PI8sVs7Mvp
LBHWtgf5783IQtr57yuNWsOn/XuLm3nONsyK/Dkn7s6TYo9EoPDPHNxsYSzbhySV
fRoQ1eV9xB6wCIOkJ8Y4jU+2LOz9lnzf32Uuo2SE1IWvaNj0+BIEpHO3a+05JbQr
Eg6k5bmfW3gJWVwrVfJ1
=7Kth
-----END PGP SIGNATURE-----

--rwgQ89ZNnFUwFHTC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
