From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V5 07/10] IB/core: Support getting IOCTL header/SGEs
 from kernel space
Date: Fri, 28 Oct 2016 18:16:06 +0300
Message-ID: <20161028151606.GN3617@leon.nu>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-8-git-send-email-matanb@mellanox.com>
 <20161028065943.GA10418@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qYrsQHciA3Wqs7Iv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028065943.GA10418-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qYrsQHciA3Wqs7Iv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 27, 2016 at 11:59:43PM -0700, Christoph Hellwig wrote:
> > +	mm_segment_t currentfs = get_fs();
> >
> >  	if (!ib_dev)
> >  		return -EIO;
> > @@ -240,8 +242,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
> >  		goto out;
> >  	}
> >
> > +	set_fs(oldfs);
> >  	err = uverbs_handle_action(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
> >  				   file, action, ctx->uverbs_attr_array);
> > +	set_fs(currentfs);
>
> Adding this magic in new code is not acceptable.  Any given API
> must take either a kernel or a user pointer.

And it is indeed happen for new code. This magic is needed to allow legacy
write interface to be converted to new ioctl interface internally in
kernel.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--qYrsQHciA3Wqs7Iv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYE2u2AAoJEORje4g2clinWncQAIfv5gOk8L30/UmzYGZXMrEy
Q0T2iHo67w6gvNbkE8DDOYjRKE+bIog7XbZO+rrjnFqS66sl0rq79ZvrfhF9zv3O
A4WTuw/ZNlp/7whrRvmU0cPPwBCxGI+ZYqZNtjqluTd7U87SA8XE53m2nl9yVedG
lqDuch+tW6/4pysCyHGIFnyi0T1myhCGVduSM8Gpt0cEeJI9gc1yYUmWiEwaXIzq
gR+IvZRZU0zG4aaffseu8r5ohfv9gmuBcvoUrv2YxugNPZ0cqVHpDjDVpVsW6Y2C
USNLX26xPmm9xnixoawqZXH5jleG1KX3dpjWTqNW2XnBfmu3Qa2RiYTPTUhO1dkS
Vq4wnd0VMWTYemx3ozrQqKixlDyEh+gPYJS4apAEugfq5aB667jBsGRAESP4oSFr
NZHHr1GzSHik5KgutcwU+97EhZAmx/c2+aIObO3JlOkLACwb6EGIeX1YPFG6iELO
ulmehFrFdOXPKloj5CE0iPCalHlbQN3AEK7z9wScoCO74hsJo+vqio5B1F920E44
Fj9D+BCuYVQC2Lh3X5QubkVpWsB+Z2QQKh0+CvAX07Wrr4UWXwSRROiZ+pcob2Px
pwZfB7ZSoy2a08VorIZhwbE+4+96pLA2UP2V45SGf+rgmUJilcPxbmb3c7VhQ5cK
t0LJy0r25JwIIiBe/7ff
=YhHl
-----END PGP SIGNATURE-----

--qYrsQHciA3Wqs7Iv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
