From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Expose CQ moderation to user space
Date: Mon, 23 Oct 2017 12:47:44 +0300
Message-ID: <20171023094744.GH2106@mtr-leonro.local>
References: <20171019053524.11135-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n2RoZOfqketZuWCG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171019053524.11135-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--n2RoZOfqketZuWCG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 19, 2017 at 08:35:18AM +0300, Leon Romanovsky wrote:
> This patch set exposes CQ moderation. This will allow to moderate
> number of CQEs needed to create an event. Such change brings performance
> improvement by reducing pressure on application to receive event per-CQE.
>
> The proposed semantics follows the well-established kernel semantics.
>
>  * cq_max_count - defines the number of cookies needed to create an event.
>  * cq_period 	- defines the timeout between last event and a new one
> 		  that will occur even if cq_max_count was not reached
>
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-19-2
>
> 	Thanks
> ---------------------------------------
>

Doug,

Please drop this series.

I'll resubmit it once user space part will be finished.

Mellanox,
I would like to use this opportunity and to ask publicly, please submit kernel
and user spaces altogether.

It causes for too much errors and it is actually wrong to submit it separately.

Thanks

--n2RoZOfqketZuWCG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlntusAACgkQ5GN7iDZy
WKdg6g/+M/cWl6TLLI6iClKx48ywdMEHS/Tu4mv4GzAlP5nNZuT3nGr67HWWlSbu
QaZtL/w6l/ZefjiJmRYELn3yvNpyOw3LnXbyCzFkBpeCE1nd3KruHPsxumYLxAhv
PhqKslDaoihB38htg4EemXCDk4mrtf2IXdcYezgnn1T3+QzdmJGbWLykSuvRJvZ1
0L1X+ccCabEBGVFzw+04WxIVbXAJt4QppUNV/BdiVzCGzGP+E8af419aIKofnxml
L5CYyTPchp8oJzMgsBlZvXoRb0+sTXLxK/PugDBj/7F9bBsFiRUzfVb3PojboLXo
sQ4n3dj1tQATcwahHz41Nsk5MggsZcBnuG6+2bNzaDIupROjZhMa83Y+rwfL1CLn
pNwBG6zpQE0ebHZoyqHYUT1JsKw4W4b9xNcnIKbAt1OODDEAWQo5UvqyzXE7+0d4
3p79Nrrpqi5vhApf+1ZmR2E8U51TQp6hvs+tx1yYnADauSOo2I5KK+QHxMFCiE0q
rpgin/cl7dB0KgZ0yXOiQX8zxd1WM5OBkk5lOTc9OVxhK5aC3cXtIPGw/zTqnx2/
YslbrawnNxYcJbGoezE3f0X2IsguWSP4Up15EJCJZYh850rmehpNH7SfivPaQ66o
KkH2hUgMOlGqRdhHmEkdLdin02PFYuU5oZ9sDnLbpthrfazTsds=
=y2+7
-----END PGP SIGNATURE-----

--n2RoZOfqketZuWCG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
