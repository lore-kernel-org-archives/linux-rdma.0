From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH qedr 05/10] qedr: Add support for QP verbs
Date: Sun, 9 Oct 2016 09:27:07 +0300
Message-ID: <20161009062707.GC9282@leon.nu>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-6-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="POjlveFHrWq2ZO+N"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475682483-9878-6-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--POjlveFHrWq2ZO+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 05, 2016 at 06:47:58PM +0300, Ram Amrani wrote:
> Add support for Queue Pair verbs which adds, deletes,
> modifies and queries Queue Pairs.
>
> Signed-off-by: Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
> +	qp->wqe_wr_id = kcalloc(qp->sq.max_wr, sizeof(*qp->wqe_wr_id),
> +				GFP_KERNEL);
> +	if (!qp->wqe_wr_id) {
> +		DP_ERR(dev, "create qp: failed SQ shadow memory allocation\n");
> +		return -ENOMEM;
> +	}

Please remove prints for ENOMEM failures for all code. k*alloc
interfaces will print it for you.

Thanks

--POjlveFHrWq2ZO+N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+eM7AAoJEORje4g2clinV8wP/RMXi4pUqp+YzfWkKL4mSB0p
rscp+rxtj6+2OozXfpWMpdcd6eihvzxJc4zpbwM/0S+0DwyC/0Rhivt5Oi1k3kD4
Zj8gFgwboYWLWovObMBaFnxsVEoO6R13N0X4IET8nlr8hlPY7MxvytLr1k8FZLIH
os2NcP/WE/2BMdJn7BDBr7TcAa8M6N8q/y0sE8lKk5v/XIwOAv04OgWVQjZiNZI/
H3vVhXEF884oO5dX4qGfbP1gBfCum9qzr7q06SXKIqrikNaRwbYTUzBvZnncoPqR
04zKdPe7u6oqOsQ8C1ElFaOhWd1oDgSZuw7wWX6tNBEs81J4Eswin+m+WNMEyHQW
iBW/c+afLzwuhZWjQf61hieiNbTPDI+Lhg6GUgNBcIj1XtrSeL/5EfBGSygy/dAf
HwVdy9U67xFKON5GhKAR6diODOdJ4mpEOIqLOzxVSNU+Iq94MLu8bwa+iwbBtmz9
OwATIbL82IKkBvBpD5fjd/DPE9YeGgPxO8h6NkwklTZAre6I+lVmufO91ue0ItQF
02yALj41G9ZajoV4T35QfH4Jkljm8knap9LDg3kBbT2t2gSYwakSgc8iWJi13Xh7
bVHot5JCc0J32YlNYq7gQhRfMBoejAak37qurAwdWnRT6hj9PPBnc7uKfImb/YzT
sDVbCvunwoBZzoQg4N2Y
=NAsc
-----END PGP SIGNATURE-----

--POjlveFHrWq2ZO+N--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
