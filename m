From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: delete some stray tabs
Date: Fri, 29 Sep 2017 17:45:54 +0300
Message-ID: <20170929144554.GB2965@mtr-leonro.local>
References: <20170929074943.cs2jea5xttk2r6vm@mwanda>
 <20170929102929.GA2723@mtr-leonro.local>
 <20170929104004.svcnntqmgdxnzgnn@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170929104004.svcnntqmgdxnzgnn@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 01:40:04PM +0300, Dan Carpenter wrote:
> On Fri, Sep 29, 2017 at 01:29:29PM +0300, Leon Romanovsky wrote:
> > On Fri, Sep 29, 2017 at 10:49:43AM +0300, Dan Carpenter wrote:
> > > These lines were indented too far by mistake.
> > >
> > > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >
> > > diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> >
> > Dan,,
> >
> > I saw in your patches and don't know if it important. There is no
> > diffstat after your Signed-off-by and there is no "---" trailing line
> > too.
>
> Yeah.  I leave those out.  I normally write two line patches like this
> one so the diffstat is normally -2+2 and I figure people will see that
> they're tiny just from glancing at the email.  When I create patches
> that touch multiple files, what I do is just merge the diffs together in
> my email client.  If I tried to create diffstats for those, I'd just end
> up messing up a lot.

What are the benefits avoiding them?

I personally want to see them without and conditions, for two reasons:
1. It helps me to see the scope of the change.
2. It allows me to simply copy/paste the name to the editor without need
to remove "a/" or "b/" from the "diff --git" line.

Thanks

>
> regards,
> dan carpenter
>

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnOXKIACgkQ5GN7iDZy
WKc+Nw//fUMx0RIWlEgf0jNzRQr99KEWYqEbhw07e7K9G/UhbvZ42aRsoH6yg+B6
ro5EzDXAiZT6mfNOX+3i9gRbVnYyuhpPvOPZEXg5kAAPKDk3+AP1Od+ay6RHBFh3
/8m9umuAe2+jmdoUnAZWFXsZ0eXWxlkjAKNnNaPTd/ELMONMpoSQi3UA8OWeu2vB
OsPTpYeVWzDKq7ifdN0CISZHPLzyzimk8riPYdrne3ObSTiUn7kq4UcetG0OJjpP
3gVA3YUC1ljWic5bKu0Kj6T6TKALr7IJTNp+zkVArk+VCXZPSKbN1SneMTKkIeUg
7ztq4419tbb5LlqxOL/E1vHb4s4+r+CBuyq36nsb8OPOdg7uwBM9Dm5hgW2HIP4a
d8fu6oC3+6CUHkPbjKDEYgI0+1cM4Yesoa+u//9kxMv7tHMNg06uU9iHikge0Ahw
z7gN3u1yz8iK3PZ7EqxdOMZyaZqJYpgZMAW1I5JKbQ/VY6kbm9e8YaNz+zZ/sL/G
skHQLFryZI2zqOGnPCXMJkdBOJCBhBp21v67CT+vZtitlYML/JKoTu+pGPXpG6nc
kcEjlwo9umT+ZRylTEunHGVTf4TPa2DAGdhLvOzV9U2BKdoTGzmPiRikJWSImcb3
TKHyZv9jxLEwrZJ9HHRe0spiZ9OdFU7yMwV0oF967S6C7P8yBQE=
=3WWg
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
