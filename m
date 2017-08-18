From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user verbs
Date: Fri, 18 Aug 2017 18:58:08 +0300
Message-ID: <20170818155808.GN23648@mtr-leonro.local>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
 <1498572282-22370-2-git-send-email-Ram.Amrani@cavium.com>
 <20170628095422.GA1248@mtr-leonro.local>
 <BN3PR07MB25788193EFA21CEB5C430201F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170628101124.GD1248@mtr-leonro.local>
 <CY1PR0701MB1337A8E7B1E40CC4C1EC230A90DD0@CY1PR0701MB1337.namprd07.prod.outlook.com>
 <1503068404.2598.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ms5iOKSBOB9YS8zC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503068404.2598.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Ms5iOKSBOB9YS8zC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 18, 2017 at 11:00:04AM -0400, Doug Ledford wrote:
> On Wed, 2017-06-28 at 10:23 +0000, Elior, Ariel wrote:
> > > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > > Sent: Wednesday, June 28, 2017 1:11 PM
> > > To: Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel
> > > <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > Subject: Re: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple
> > > user verbs
> > >
> > > On Wed, Jun 28, 2017 at 10:02:45AM +0000, Amrani, Ram wrote:
> > > > > > Most user verbs pass user data to the kernel with the
> > > > > > inclusion of the
> > > > > > ib_uverbs_cmd_hdr structure. This is problematic because the
> > > > > > vendor has
> > > > > > no ideas if the verb was called by a legacy verb or an
> > > > > > extended verb.
> > > > >
> > > > > Why vendor should know about it? It has midlayer (ib/core)
> > > > > between him
> > > > > and user to handle it.
> > > > >
> > > >
> > > > Knowing the inlen can be used to determine if the library is
> > > > newer than
> > > > the kernel and what features it supports or not.
> > >
> > > It is not interesting case, because we are not breaking UAPI, only
> > > extending. It ensures that kernel will fill as much as possible and
> > > will
> > > always have success in it. After that it is library responsibility
> > > to
> > > understand if everything was filled.
> > >
> > > Thanks
> >
> > In our case, kernel driver needs to know whether library supports a
> > certain
> > feature (doorbell overflow recovery). It doesn't care if it was an
> > extended
> > verb or not, but it cares whether the lib is sufficiently new to have
> > provided
> > the required information. If the library is sufficiently new
> > (supports) then
> > kernel will register the library's doorbell address with the overflow
> > recovery
> > mechanism, and perform recovery if required, otherwise it would not
> > (as the
> > library is not supplying the necessary information for recovery to
> > take place).
> > This is not something the library needs to know, but the kernel
> > driver. Having
> > correct input len is required for successfully avoiding breaking the
> > UAPI.
>
> Leon, does this explanation resolve your objections?  Also, have you
> checked the mlx5/mthca portions of this patch?

Yes, let's me recheck/rerun the patch and post results.
If for any reasons you don't hear from me till Wednesday, take it.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--Ms5iOKSBOB9YS8zC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmXDpAACgkQ5GN7iDZy
WKe4Sw//TYSc5+t1YMLqeEAbjTRvQuZ1p+m89/YE8O/FgWJ4zXAHB0aM8Or01gow
wYEop/5DR+9Y6idxn+i3geQjFVrSfjbDv1/wOxrJ03iSb9ZZCod+abNpQt9DsbAu
UZbG5lwhW+vXDTW1hSR9QMI9ncBLrNMft4YFZd4lT6WgvatWiesHLdeCc5yzariR
0eVrlbVsETqiojbpTYGmGHxRzJMfhx+3faS6GBGv0f3AE5Gon2X9IYtmLWJxBSXP
/mbgE/p6K5+tpn4Dh2ABxDqViIGHvs/E74uhmN+pRuUkJrI/jDT5LmDYeTqshxn+
qvsBFddyaWOaPy0huN3Qehtp3mq2Q/DVEbGX90ALbkrPJjC8w8n31zWXd9XCYZIG
3ju2ig0+H0H604So0z+xC2fJMFiTRb90Gs7rNCrGxKb4reEnQritAG/o1BuXnOJu
J7jBLpgpb/NJXX1XiK2Nc2rQplead1s/5CvgJxGwe8isN+kjs9B2M5hQAZOVi8oM
muSBDNLjtsil7OqdWgVrO5vHmnnwHInH3GFSV4KQfVKIfdek+jRBGCmdUeSQu/+v
Z22LlRv7DH6grhObT5neq2LTh5Zi5swbqsOGIi6BKjvvdDpCYT7WcgyVlgWiXN5J
f2dLV1vXnMzbVy0Ho5Ejd9FjqIlaEdD59UPzSp5hfe2ym36Jgfg=
=W6yX
-----END PGP SIGNATURE-----

--Ms5iOKSBOB9YS8zC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
