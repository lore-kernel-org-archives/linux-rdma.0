From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Tue, 26 Sep 2017 19:34:22 +0300
Message-ID: <20170926163422.GH6816@mtr-leonro.local>
References: <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
 <20170926051349.GA1230@mtr-leonro.local>
 <20170926065600.GA6816@mtr-leonro.local>
 <6fa41141-cae5-da51-94ef-afe5bdec22bd@redhat.com>
 <20170926162140.GF6816@mtr-leonro.local>
 <4707c600-7aec-2c14-11d6-0443c2a835e3@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GBDnBH7+ZvLx8QD4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4707c600-7aec-2c14-11d6-0443c2a835e3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GBDnBH7+ZvLx8QD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 12:23:35PM -0400, Doug Ledford wrote:
> On 9/26/2017 12:21 PM, Leon Romanovsky wrote:
> > On Tue, Sep 26, 2017 at 12:03:01PM -0400, Doug Ledford wrote:
> >
> > <...>
> >
> >>>> He started to complain about empty merge commit with v4.13-rc1, and continued with explanations
> >>>> about difference between back and forward merges. From my point of view, my intention to base
> >>>> shared pull request on latest -rcX is exactly forward (good) merge, because it ensures that
> >>>> all our future submissions for net/net-next/rdma-rc/rdma-next are completely in sync and
> >>>> ready to go.
> >>
> >> This is why, when I submit a pull request for -rc, I also merge it into
> >> for-next.  It keeps this up to date as you say, without needing to pull
> >> in all of the -rc, so it gives Linus an easier history to look at.  It
> >> does not, however, sync up the net side of things.
> >>
> >
> > Doug,
> >
> > What is the bottom line for the bases for shared pull requests?
> >
> > Thanks
> >
>
> Just base it on either A) my current for-next or B) -rc2.

OK, in this cycle, we will have it on -rc2, but I don't know if it is always
feasible.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--GBDnBH7+ZvLx8QD4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKgY0ACgkQ5GN7iDZy
WKfOZRAAg6H3e9NefHGhBUbh173WZa6XOVpulBEwWRASrxIvv8oyld2Z291B2tAL
R+ghgJTU95kUmpj8vQPJThRpYH1i1Rv2GOWOgAadohwi9mdIvi4v20xfx4wN3BGq
6Ixo90FESy0aJDGci596vt9BK7tWBSkACgpAOBszhqn04PAJV+quHp81EGZ80xAj
koKz6mpDOEddZTO1PM1a0sjuWvXzYO2xwvOExnf0K2qUfNhojeAtbShbEA8351ve
OJrSye2h3WrIklq09UyK4sQfqwRora2X8VcYXWm7wAjlB7UVKsmS+KICLEv1T3jw
p/cs0VePuzVvZYbpFMYOW0VD2aFM28rPNTUVykPyL9G5uiqvUC2gYalSok2Hsdlr
muUcWg4bVl43Vz+TdFlj98ppgndgGPvBxfqsRK6KYwM6GCnUmLxhdZWhWNxaOy8x
/almC2MjnDge801nYEvCH/QzbrI8heVIGLF3rzsj1oUaSbwYXkn8IbK55G9ilJtj
6AebpXKHAIqjmTR9iDyZbrtqpqVnqqLLJL101w9UpmG7qPMVQlNr0FA9p9YnCpgb
HHHwxTvu7rrjhHwgN/hBTqzMF+d39pCNXg2DWyDK0YDzo7VpTDs7vPPLRNYvE4Oo
AUQYTAEBcQoAlmhflu9kLUKRnDtrfrBKQlIqic9BeirDY7kKzAE=
=JmGh
-----END PGP SIGNATURE-----

--GBDnBH7+ZvLx8QD4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
