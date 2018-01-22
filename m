From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Mon, 22 Jan 2018 17:13:07 +0200
Message-ID: <20180122151307.GK1393@mtr-leonro.local>
References: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
 <1516242961-154453-3-git-send-email-liuyixian@huawei.com>
 <20180118043717.GC8414@ziepe.ca>
 <9e577314-4fcb-45de-6909-d5b3be570196@huawei.com>
 <20180118161949.GA18973@ziepe.ca>
 <a33a1337-665f-4cd4-5b39-b12d9f03af72@huawei.com>
 <20180119200029.GD3437@ziepe.ca>
 <68e02f2a-0474-bc73-a784-fd52dbbde552@huawei.com>
 <20180121065727.GF1393@mtr-leonro.local>
 <1d95b4da-1cb8-e1ef-9c0e-4ac70a848d38@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8tUgZ4IE8L4vmMyh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1d95b4da-1cb8-e1ef-9c0e-4ac70a848d38-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8tUgZ4IE8L4vmMyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 22, 2018 at 10:01:32PM +0800, Liuyixian (Eason) wrote:
>
>
> On 2018/1/21 14:57, Leon Romanovsky wrote:
> > On Sat, Jan 20, 2018 at 07:41:03PM +0800, Liuyixian (Eason) wrote:
> >>
> >
> > <...>
> >>
> >> With carefully release-management, there would be no compatibility problem
> >> both for hip06 and hip08.
> >
> > Sorry, for interrupting your discussion, but what does it mean "carefully
> > release-management"?
> >
> > Thanks
> >
>
> Hi Leon,
>
> Here release-management mainly means that our driver (kernel and userspace)
> for hisilicon SoC is released progressively with linux kernel versions. Take
> hip08 for example, our first version Roce driver for hip08 appear in linux
> kernel 4.14, as more and more features are added in, some features may be
> supported only in 4.16. I call this process as a release-management for
> hisilicon SoC.

Are you aware that rdma-core and kernel are independent and can be
installed in any combinations of old/new kernel/library mix?

Thanks

>
> Eason
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--8tUgZ4IE8L4vmMyh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpl/4MACgkQ5GN7iDZy
WKdy5w/7BMYkcwFT1y3tyVbhUn32/Q7LlNDBhDtJn0olFGhZYbZtO6aGdF2r5Bzw
96x8xeaxz4YeCWKGLfQP4LXxouwfoUtTrObzj2++l1cHXZMttR0H47uC76b6e6kd
3LgD4IXvcxbZq9SBB4z/IpkTvIhyunGI+UH0dolNmXCbOyqXTqjsRkBGYqjcVBsc
7BzmJKenqP3Vpgd41+hVD2U3yDG2mgH7qffrE1z9i6odJHaSXjfLfQvOrjUnURUm
csjoEPWDlfduKOT/H0a6QP17S9y20v39veiVuL1DId+19EaiITy/C1zliHNFFHRt
34C0be0dFf/ODtbww99q43F9CUbbG9gJPvHeksJN387YVB8sDy9Q2XbfmZe3yiMS
VwNt4zNP5iZwp8bRijb+gAzBTsA1fFXysvtA22Z+IiJpmpnAlLLj0DJoDsd9K6DG
Ru1i0aOx4btKA9M7Q/m+MySmqUCrOdEPNqd+av3hCYhG17i+bIe3BkhrVIDzLtcc
c3Js02dC0gnCellwPHAXSQjbXh1HTAZrTklW6DqxfrgMg/m9JNYgFvic03TsLG25
dqJipnjS5nFwTdFQc6Hkj1L5nkUQgpoo5Se8jFNewWWUM3yuqgxESqTAOH1mJNNx
2ruiUlvDKFfkM0TGKY3XlEnn2xbvZEThVTH/KAs71DHbMGgmp8c=
=DCGM
-----END PGP SIGNATURE-----

--8tUgZ4IE8L4vmMyh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
