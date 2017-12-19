From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/31] RDMA fixes and refactoring for 4.15
Date: Tue, 19 Dec 2017 15:35:22 +0200
Message-ID: <20171219133522.GG2942@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171218231120.GH19056@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hTiIB9CRvBOLTyqY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171218231120.GH19056-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hTiIB9CRvBOLTyqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 04:11:20PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 14, 2017 at 02:51:47PM +0200, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > Please consider to take the following series to your coming pull request.
> >
> > The patches are available in the git repository at:
> >   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-11-14
> >
> > 	Thanks
>
> I applied this series excluding:
>
>    IB/core: Fix do not add RoCEv2 default GID when IPv6 is disabled
>
> As noted in my reply to that patch.
>
> I revised many of the commit messages, lets try to improve these please.
>
> I also revised this patch:
>    IB/ipoib: Avoid memory leak if neigh destination was changed
>
> To use ipoib_debug as noted in my separate message.
>
> Everything is in the wip/jgg-zero-day branch, it will move to for-next
> my tomorrow. Let me know if there are any serious problems with my
> edits.

I took a glance look on the messages and they seem ok to me.

Thanks a lot.

>
> Thanks,
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--hTiIB9CRvBOLTyqY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo5FZoACgkQ5GN7iDZy
WKdXhg//dAcD+nFid3hwCelEnxJTivEGfHtNkPMGhuAY89zQ/5OnzV6tTxCk96vf
3dJC9QEgPDCwFAiK9M+qD0FLTtr0KQwZFceO4B6Zc3NuNVO7srxnbnvqaSHxVOzj
RDdIs2YNYL0ZMD8aLEh89SEJ+vD+fBe8hxa8Bmzaqu9tkxAN4hzAEm/U+p8yHC1Z
QmYieVynnOtxHYx77/wmpOQNcC1mPqBsvVPWt07B9JMQmCiPckb0WPkcS8S39sbU
U22YRHopuMckIAy3HCUeGb5D5VYt0FjnPuVgvnTkmaykrLTx2LtN+YHH0QYbHGIY
KVd0xHwzXoQHHvNreCve3kvHR8EYRYHwDrghl1976ciFp3RoeyuKk68v5fCICoSC
JxxS72jnjKDLGYETc0QsuyT4xmN6hi3G5UvUoiCV4JazD61zkTJodllNYm76jd8q
gK1C7AcbXnDB5uRyN6DcOcGaeOcbMhPh6lyNMw6YWnauJbFcxoAhtKg4DMksTVgV
bkG2CUx8jq0evx1IvcaQTNChv1mXDxXXHwli2t4p1h6vswBEbAx1jPdz/JioW6CL
FAYSsrg4e78PjaIpVOWZl1+zrFiwurnkAspKS0dl51xDdkogRUEJQy/+oi7pUK0u
TpArVNRK80W9u7V7wT0gu9tL/9ReY+8IzyuXBmdyfWD341DJ7Ow=
=zbzD
-----END PGP SIGNATURE-----

--hTiIB9CRvBOLTyqY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
