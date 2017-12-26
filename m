From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/31] RDMA fixes and refactoring for 4.15
Date: Tue, 26 Dec 2017 20:49:14 +0200
Message-ID: <20171226184914.GF10734@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171218231120.GH19056@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iBwuxWUsK/REspAd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171218231120.GH19056-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--iBwuxWUsK/REspAd
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

Jason,

I have a hard time to find the commit 09/31
https://patchwork.kernel.org/patch/10057549/

It is marked as superseded, but I wasn't supposed to send any new
version of it.

Thanks

>
> Thanks,
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--iBwuxWUsK/REspAd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpCmagACgkQ5GN7iDZy
WKddmxAAr/kHydGVVBosCehk+tseOK2ttyAOpgZNgWQtUkuoyOdkezIh8BbnGbgp
GE6fUHH5lTL3+aD/2HOpi63pPravPRg4gXrwMPzR4T+3YWVl9q92LiJ0R4BROJSk
VoXPzlnr2fkJZV+cUKu9bxMXcyPWR/rBKRvi/kydyFj9rusxi1sr1LmvPmb9XrN9
VQyekSl84t3KdcoEs5sFxdS0CtBsDicBrQm3zzFnFHQv/DBsbhET77FECj2fMMIw
/Ka5VthBJs0MtgNnCByOQB+TTysX+m2MiHtPoCmDJrsRX2Tt8ZSf9u8IeP+urmyS
0QhgljP+LiHU6nvTAf1zylp5NQWp1dgQ/Uv2rBzOG7UdF0/EuWXt8BT3TtnvInn9
MMWQZi/h3VTVEMQi8DtRALtc2V4zMFml0O8RlWcg5XfLWb3SslTVrwdZrVDCJt2V
F4L8BpQeCTug6DzYY1iaJbqAhcrfCOuAk+OgkxZGoUpmZOZ834t56RXbanWR5Awx
i0q60Pe5sB3nNA77Fv3oL68rV0KVCxMdjOILb/cqtD+PdQ2Ub1oSo0IorhlrhT2f
5fVHUKT0oYda9Uhvrksb1jh3YkaNsWH8Pz8oBWcsl0uZ9XkRElC1rmjsbY+Zh1jK
d6m7aQ3d7hg3oSM7MBzfNSqbbi0EbCE2Wgj98uO1R3meF3+0EXA=
=NLp4
-----END PGP SIGNATURE-----

--iBwuxWUsK/REspAd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
