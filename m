From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add missing NULL check for MPA private data
Date: Tue, 23 Aug 2016 12:47:35 -0400
Message-ID: <a4f9a872-74a1-7cf9-93a0-808f4b820fa7@redhat.com>
References: <1471907797-81772-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bGnlC3kdmddsTS5rPkBi1q8nk1t3omBo3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471907797-81772-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bGnlC3kdmddsTS5rPkBi1q8nk1t3omBo3
Content-Type: multipart/mixed; boundary="9xt5IDe22JT9xbUI6iP7BkCe9kLhfBbMv"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <a4f9a872-74a1-7cf9-93a0-808f4b820fa7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add missing NULL check for MPA private data
References: <1471907797-81772-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1471907797-81772-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--9xt5IDe22JT9xbUI6iP7BkCe9kLhfBbMv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/22/2016 7:16 PM, Shiraz Saleem wrote:
> Add NULL check for pdata and pdata->addr before the memcpy in
> i40iw_form_cm_frame(). This fixes a NULL pointer de-reference
> which occurs when the MPA private data pointer is NULL. Also
> only copy pdata->size bytes in the memcpy to prevent reading
> past the length of the private data buffer provided by upper layer.
>=20
> Fixes: f27b4746f378 ("i40iw: add connection management code")
>=20
> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniban=
d/hw/i40iw/i40iw_cm.c
> index 5026dc7..6434398 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -535,8 +535,8 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(s=
truct i40iw_cm_node *cm_node,
>  		buf +=3D hdr_len;
>  	}
> =20
> -	if (pd_len)
> -		memcpy(buf, pdata->addr, pd_len);
> +	if (pdata && pdata->addr)
> +		memcpy(buf, pdata->addr, pdata->size);

Is there a guarantee that pdata->size is always less than pd_len?  Do
you need a check here?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--9xt5IDe22JT9xbUI6iP7BkCe9kLhfBbMv--

--bGnlC3kdmddsTS5rPkBi1q8nk1t3omBo3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvH4nAAoJELgmozMOVy/dN28P/1rr8LoHiJyreQwehk6glxZW
4YcH2URcD/iMoBUTXHENbSRVKpeOg9MbQ3ZuDfYK3CJ3zmWyZs/Rmw4RPmxEPsKf
FHhFz6D6hjQXNsP7yQxG97RLfK2VesqqHZ2KD/I9SIyTTQF4MdN4U6Ls2wdiYys/
KxPyQ0UYd4CSczCYgjSMPukZuJlCRo4MAHhqd1pjt5E6qCwygAue1XPumhNxLhUA
opqMEXz0UpzgHn1YvkkgOPD9Z8EH8GVHAG7N7PqEF/c2zrvu8j2NEZG4p7fAIans
03CFD4QCzeLHhNtG+FYsDepVqzyJlN61tYlROoDd3VZ1tN48gWLFV9E9+IE85K/l
4pIPFuFH+bWrVEf5RvyvOvCuzVOAkwsyURIwN0ZR6qXeNbzR1e54zzMS67wwSelq
wCXO7cyYzo0wiIPZvkrydIHODMdZlNi9UmZ8DZZuagCeUEbI6hJuqWBaoW3oRRG+
Q+NQNNKKCGwF/EJ4BUYbHuUctFKzZZn+Aj5HDpoXtLMUEGQzhTxLTjyfDuJ2HCJk
FTaUhD43mDz1O3qaD8rlmKyDpA+rvvTJnr8Tjey7hlrVmtP7vQBzB32QiGgjlzjs
Umwb+wCACXWCPYMXo08Cjbjr4fEoxC6KzrUd9BjEgGus1J2T/8hNUSSuEFG5CfVY
1A3MNhJzcu2cAIxYjyXs
=uiP+
-----END PGP SIGNATURE-----

--bGnlC3kdmddsTS5rPkBi1q8nk1t3omBo3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
