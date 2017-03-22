From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] infiniband: Fix integer overflows
Date: Wed, 22 Mar 2017 08:39:18 +0200
Message-ID: <20170322063918.GG2079@mtr-leonro.local>
References: <1490041006-8092-1-git-send-email-vlad@tsyrklevich.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZP7cwq+yCXYhlQRU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490041006-8092-1-git-send-email-vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ZP7cwq+yCXYhlQRU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 20, 2017 at 04:16:46PM -0400, Vlad Tsyrklevich wrote:
> The 'num_sge' variable is verfied to be smaller than the 'sge_count'
> variable; however, since both are user-controlled it's possible to cause
> an integer overflow for the kmalloc multiply on 32-bit platforms
> (num_sge and sge_count are both defined u32). By crafting an input that
> causes a smaller-than-expected allocation it's possible to write
> controlled data out-of-bounds.
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)

I would recommend to simply return EINVAL in such case, and don't bother
to complicate the code with wr_align.

>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 7007822..ebb34ae 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2542,9 +2542,12 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
>
>  static void *alloc_wr(size_t wr_size, __u32 num_sge)
>  {
> -	return kmalloc(ALIGN(wr_size, sizeof (struct ib_sge)) +
> -			 num_sge * sizeof (struct ib_sge), GFP_KERNEL);
> -};
> +	size_t wr_align = ALIGN(wr_size, sizeof (struct ib_sge));
> +	if (num_sge >= (U32_MAX - wr_align) / sizeof (struct ib_sge))
> +		return NULL;
> +
> +	return kmalloc(wr_align + num_sge * sizeof (struct ib_sge), GFP_KERNEL);
> +}
>
>  ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
>  			    struct ib_device *ib_dev,
> @@ -2742,6 +2745,7 @@ static struct ib_recv_wr *ib_uverbs_unmarshall_recv(const char __user *buf,
>  {
>  	struct ib_uverbs_recv_wr *user_wr;
>  	struct ib_recv_wr        *wr = NULL, *last, *next;
> +	size_t                    wr_align;
>  	int                       sg_ind;
>  	int                       i;
>  	int                       ret;
> @@ -2771,7 +2775,14 @@ static struct ib_recv_wr *ib_uverbs_unmarshall_recv(const char __user *buf,
>  			goto err;
>  		}
>
> -		next = kmalloc(ALIGN(sizeof *next, sizeof (struct ib_sge)) +
> +		wr_align = ALIGN(sizeof *next, sizeof (struct ib_sge));
> +		if (user_wr->num_sge >=
> +		    (U32_MAX - wr_align) / sizeof (struct ib_sge)) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		next = kmalloc(wr_align +
>  			       user_wr->num_sge * sizeof (struct ib_sge),
>  			       GFP_KERNEL);
>  		if (!next) {
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZP7cwq+yCXYhlQRU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljSHBYACgkQ5GN7iDZy
WKfwPg//ejBdeU4145hum2TK8yaVkB6F1VzHyVjwdRFnZ+UkYTFVNE2Sb1OcLAsm
g4MyXRp+41d7QQBrgCKdmmx+NieStcSSPpJFcZji24g8XwRqwMHs09/iFi9GkI9n
8h8M2r5cvBjvxjAqFW5rwDbquvf1sXFZuLzyfAbs5YE/141W2mzzr2VVc3/zZ1ut
pOicBeNnwv4+EGblNE3CXyfHJUQLYm7PSaHOSrZDhxZcyHUBzWWWOw1/TsCh+K3Q
oxB/j597f50C4c6A0EZyIe09VtusQUHA+kbv/I6R/ypQ0JwjhtJZQNNnRB185Eqs
D11Rq3GPpJbjSsYROqIDPh2RVResZhMtXq2oepACc6p1iIYMl6bf/woJj9Qq0vPc
GsIhcFRnLk28lGdUNxdfs4Nr1w8cw3f8sWznjgaNo7a8lR6gz8o6whn6d4GtN6Dk
4TY1bQeE2mMMlzVHIqVVzlfU9VaQ9SZd1Kn86Ky5FU+nQvW48ehDsRY2LQ+Ti3Pb
BPM4Mx1vUdlbqeOC+h6072duq1FxM/2wkl8pA/q+MkyqJsFRT2I4ZRvdLNlSGkMg
Wv8q23wKMRL5OuV+oDWO5OE29Dl3iwE3FTqgdJbcnK/Gy5Lk2Ske80oigtQaoBn1
xuXpbDpoFTINhj9pxO+/0BUnYNn2oTWt+Fxp3FcN2V58Y7ZA5Zk=
=66XX
-----END PGP SIGNATURE-----

--ZP7cwq+yCXYhlQRU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
