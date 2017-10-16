From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/core: Fix use workqueue without
 WQ_MEM_RECLAIM
Date: Mon, 16 Oct 2017 21:32:17 +0300
Message-ID: <20171016183217.GL2106@mtr-leonro.local>
References: <20171016054517.30643-1-leon@kernel.org>
 <20171016054517.30643-5-leon@kernel.org>
 <4f08314e-fd5d-c108-438a-d9e83821e4b3@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AeHkbrJcO8giN/MO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4f08314e-fd5d-c108-438a-d9e83821e4b3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AeHkbrJcO8giN/MO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 16, 2017 at 01:24:12PM -0400, Jonathan Toppins wrote:
> On 10/16/2017 01:45 AM, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The IB/core provides address resolution service and invokes callback
> > handler when address resolve request completes of requester in worker
> > thread context.
> >
> > Such caller might allocate or free memory in callback handler
> > depending on the completion status to make further progress or to
> > terminate a connection. Most ULPs resolve route which involves
> > allocating route entry and path record elements in callback event handler.
> >
> > It has been noticed that WQ_MEM_RECLAIM flag should not be used for
> > workers that tend to allocate memory in this [1] thread discussion.
> >
> > In order to mitigate this situation, WQ_MEM_RECLAIM flag was dropped for
> > other such WQs in this [2] patch.
> >
> > Similar problem might arise with address resolution path, though its not
> > yet noticed. The ib_addr workqueue is not memory reclaim path due to its
> > nature of invoking callback that might allocate memory or don't free any
> > memory under memory pressure.
> >
> > [1] https://www.spinics.net/lists/linux-rdma/msg53239.html
> > [2] https://www.spinics.net/lists/linux-rdma/msg53416.html
> >
> > Fixes: f54816261c2b ("IB/addr: Remove deprecated create_singlethread_workqueue")
> > Fixes: 5fff41e1f89d ("IB/core: Fix race condition in resolving IP to MAC")
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> This looks like a -stable patch candidate. Once accepted this should
> probably be queued for v4.9+.

I don't have any strong opinion about that.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--AeHkbrJcO8giN/MO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnk+zEACgkQ5GN7iDZy
WKfiFBAAlkgp/DunBrksPkd3CBugAdvoVjJjUULpXjaPtC+sTcRUzBJ77iKzLess
JpxNPiQ2+5Oyxo2SvQWdu2c1nEl6nU2wDbW5iY+YAA4ZRqysD6d6iuUL22R0w+2w
RNZSYtduhLyfE8vwx6kSgUWl/XfY8jNNym9xJ6oISgkrRubnZtyiJKHnj+iI2OZK
1xXCGfH8AN3deXpI4SAC/Nls9tMkC3h9IlVYYBdnyh+ZnfiVdFYGJY8YzjlFUP8b
kpveo/P20AswtqvW4yV2Rv7yHd3ehYkVOHg7xHkPvfBFY1Cg9w5NYB/avztpAI2g
ETUHPLIfgvGo9eTlROulKUGG+YbrIW7HjjXmzKE+A2rUwUcMxnnUB5UCgky4JsgA
SS8x+giTuAPFr0MYw9be8oiOlvzv67BkIIVvKbMMR4KZ0ihm2QUIHQZFJ9gilJ4V
lAcdgvAOMSKUIus/Tz66Dn0zSTR2jlk9Sex961fufhZOMpN2Po8CKLmywZWTtgdD
nMcFhPTlzZkZgXptYh8YNkd0yjbhFhRyL0jqwqTcBpE8pMTokWrQZKVCRoGM2K5J
Jod0PEgioHJal1VuNpBL8DxCm3OkiNxzRPaF/vEVmowU/PrVLBRe+7/TKZSFQWKO
dST3IYQiAChJnhLgOhZV3oe7myDNdjbiH3s9tPbIrvdko+KuW+o=
=R96l
-----END PGP SIGNATURE-----

--AeHkbrJcO8giN/MO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
