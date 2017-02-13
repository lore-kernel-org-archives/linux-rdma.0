From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 6/7] mlx5: Add direct verbs man pages
Date: Mon, 13 Feb 2017 20:13:38 +0200
Message-ID: <20170213181338.GB6989@mtr-leonro.local>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-7-git-send-email-yishaih@mellanox.com>
 <20170213165445.GC25430@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170213165445.GC25430-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2017 at 09:54:45AM -0700, Jason Gunthorpe wrote:
> On Sun, Feb 12, 2017 at 04:16:51PM +0200, Yishai Hadas wrote:
>
> > +.\" -*- nroff -*-
> > +.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
>
> Please use the MIT variant for all new files
>
> > +.fi
> > +.SH "RETURN VALUE"
> > +0 on success.
>
> 'or the value of errno on failure (which indicates the failure reason)'
>
> and in other places.
>
> > +.BI "int mlx5dv_query_device(struct ibv_context *ctx_in,
> > +.BI "                        struct mlx5dv_context *attrs_out);
>
> This isn't going to work with comp_mask, at a minimum you need to add
> a size_t attrs_len argument.
>
> I recommend against adding new complex queries like this - they don't
> work well from an ABI perspective and not being performance critical
> do not require this comp_max madness
>
> Eg just use:
>
> int mlx5dv_query_cq_format(struct ibv_context *ctx_in)

This will end with bazillion small exported functions and I don't think
that it is clean way to provide API. Especially for function which
should query_device.

>
> We still need man pages for all the inline functions :|

There is documentation in the include file itself. It is hard to imagine
users are working with these functions without good knowledge of mlx5
HW. They don't need man pages :).

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlih91IACgkQ5GN7iDZy
WKc+9Q/5AbCqbixsNvevItombYYXeM0Acg0DkNIg9vhzI+ooblKG9VucOs5Xu5Lc
mvlyiafMdmE9sUwgl4HZtVsMKMZ3G3JqFvBwxRjuBMP0pvYmeZ3BrMtpC9cJNHZk
Q2QC4QZgEgJrw80PpaG2YNVv25+lDzw20QndjwSlo5Z9DYIYToWNwArtdpWY5oi1
wXZyaI02Vs6Jmd8/3WajAIpaZ9V1T/bZ085WuttoAplL4H81OMf2r9L0nMCZlCac
LEkY5HnfUkze10UtMdgqATO0EL4oRG/1W46rnVSAovtrxJl9v6mZJNMgyadC36vg
j7wboXE/o5VTB5eo8sAhXGvK79CZaetqUKDTmrEwVSYSppvXvmpjQdf9/wFrk6Pg
EwawtAtPOlc56MIINoTU1Kj97BSjM+LN4u2T4Unv6l9Lz7ordZrG24Oc2UdSZJOJ
l5WzWCHivFbOHaUEBEBrtSLcgojAYlWX2BzHXtTLrHUp3KjRIi1Db8XZ6jcb89up
T4iRFRF+X8J3EmMYe4CACFn53pFnltV07N81KFkfEaViVjWP6/rvFb6iL5Eb06Py
R+g4N8XdTFQvESdtoMUJGq6StIePuAl+qoqmLyRCcwxy1D0A3169VGOcTklVzBH+
HgqgVm/cC8HphVxT9YqiAg6jwKIH3KgVGoXC/OVa+OHZqQrEYH0=
=pvMC
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
