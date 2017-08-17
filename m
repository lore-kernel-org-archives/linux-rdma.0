From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 17 Aug 2017 20:39:32 +0300
Message-ID: <20170817173932.GJ23648@mtr-leonro.local>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
 <20170817173320.GB22792@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170817173320.GB22792-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 17, 2017 at 11:33:20AM -0600, Jason Gunthorpe wrote:
> On Thu, Aug 17, 2017 at 04:36:38PM +0300, Yishai Hadas wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The returned UAR pointer is actually void ** and points to whole
> > UAR database.
> >
> > Because user is not supposed to access it and expected to use
> > the CQ doorbell, we will return uar[0] (CQ doorbell) directly
> > and eliminate the following logic in the applications:
> >
> > uint64_t cq_db_reg = (uint64_t *)(((uint64_t)(uint64_t *)rxq->cq_uar) +
> >                      MLX5_CQ_DOORBELL;
>
> NAK, at least, as is..
>
> This changes the ABI and mlx5dv is a public interface now, so you have
> to do it properly.
>
> Looking at it, my advice is to rev the symbol version of
> mlx5dv_init_obj and consider providing a compat symbol.
>
> Also, you need to change the name of the 'uar' field:
>
> > -	cq_out->uar	  = mctx->uar;
> > +	cq_out->uar	  = mctx->uar[0];
>
> To something else, to make it clear, which of the two ABIs the
> application code is coded to - for a change like this, you *MUST*
> force old apps to have a compile failure.

I know exactly who coded on top of this interface. They are the ones who
asked for this change and they are fully understand the implications,
inability to work with this interface on "old" libraries.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmV1NIACgkQ5GN7iDZy
WKdzYw/+KYbx4eN0HkanfU89gNOataRunIT9Y81PeDnbQznyGsXlpja1YCNeiFsq
53tGfwv40uXJAm5tHLSwuZjCCkEBJmg6wrhclpY4qaO0NbNzT4dRDP1D2H/4Es7u
iMr9L8IX7c7KcgJ+OFevPQJR2IDREjKt8/gq6B6BnUQg9xOV1U57E9mtC/Q2AeEj
61jWmG/wUUOWEWeS38VsbODDUalxnmcfSWTCnygiIy8duSzWI+WoKyjNKxaNuD4r
z90SUHa9I5cXrDsBo94U6lIueCQK/t4ynNolatYKId0dMAQ1xSHsv5oq0jxfNQ+z
Br4/U535OVPXAcwaH289t7YMVEKediS4K6uLfADi4iaLdkFIsGR8XSUMoDZGKggm
Zy8rZ+RuB8bgs/nTZvRAkI5zrB7AatxK/Bpx//EczG3ovjuiJZiMhueuZMAhI3Um
GZ+8rG+W1OEeBqcnxsyTqoWddKYYgHkz4l0VWUXMfuTIPGb8svMtts0zGJbtm05K
4tIaBYUGaizdv9zRMk4+9Xloz5hjPXR+jBQdaEWqoXGNb6UqF6yI/YXI/WluWog1
SXc2A5ki9xNnMEVpf0StHf3qAI3zclZM0I2Ip16VYFAH5spbXLDeOq8JZOd2QVIm
5Ww8u07FgW1fZg6v11rTBnI0Fi40Wb17+r6wpfW/ifqjl2+Dtj0=
=Gll0
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
