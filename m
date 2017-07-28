From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Fri, 28 Jul 2017 07:32:33 +0300
Message-ID: <20170728043233.GE13672@mtr-leonro.local>
References: <20170726053749.GV3259@mtr-leonro.local>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
 <20170726130350.GW3259@mtr-leonro.local>
 <a1abee42-58d2-aba6-bc56-9bf1830a4539@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a1abee42-58d2-aba6-bc56-9bf1830a4539-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 27, 2017 at 02:34:57PM -0400, Doug Ledford wrote:
> On 7/26/2017 9:03 AM, Leon Romanovsky wrote:
> > On Wed, Jul 26, 2017 at 08:24:44AM -0400, Dennis Dalessandro wrote:
> >> On 7/26/2017 1:37 AM, Leon Romanovsky wrote:
> >>> Reply to: "Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from reset to error"
> >>>
> >>> On Sun, Jul 23, 2017 at 09:14:02AM -0400, Doug Ledford wrote:
> >>>> On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
> >>>
> >>> <snip>
> >>>
> >>>>> BTW, when will you post for-4.14 branch so we will be able to base our
> >>>>> submission queue for the -next?
> >>>>
> >>>> Tomorrow.  I wanted to base it on 4.13-rc2 so it would get all of the
> >>>> fixes that went in this week.
> >>>
> >>> Any news on the matter?
> >>>
> >>
> >> Check Doug's GitHub, I see a 4.13-rc2 based "for-next" branch there.
> >
> > Are you referring to this branch?
> > https://github.com/torvalds/linux/compare/master...dledford:k.o/for-next
> >
> > It doesn't have most of mlx5/mlx4/cavium/core/e.t.c features.
>
> Oh, and I never said I would be *done* processing the for-next area all
> in one go.  You said you wanted regular progress and updates, and the
> branch I have represents that.  But regular progress does not mean take
> everything all at once.  As I process more patchsets, more will be added.
>

Regular sharing of information is also part of regular progress.

As I said more than once, I'm fine with sequential work, I'm fine with
the fact that not all my code is accepted, I'm fine with scheduled
delays, but I'm not fine with silence.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll6vmEACgkQ5GN7iDZy
WKfLdhAAvKCmPFap3l1JFtPcemOwnfBa5Nbs1yZFs+4K5RzMsjUi5CX9f2zk2Jyw
Rmx62mpBTY/PRvMWdevqwMm0uD1BdabCIEDZId18fIdHZX9gxPrnGAN9Qzu5MD3f
OKht5jCY1iY8/kAB8eh8O/lrlO7/guDtNlMObZxKi9YUvqZhGEP2sKuZKkgmBV2f
QbFg/yuj7iDCMkmNgu6oaDKkF/xeb8PUvwQKVOKXEMgEoPN73iMCUCVHBxV61XNH
AXzXwMPIVVpdeLjI5GnrVfinodpLSdvhIHrtiKCU0TM3lxmwbSBcwEbpwfdkr0fu
xgL0zabVEs8LMckTQoJc1Wyq74MF0AtONFl1nhC89wAuPzwmLVD5h/M1BPPAGmJv
CtnBv0TMyH78T5ulqTXR8lguVfZOS/qo3Upukca7c6M3ZheLE1RxdZQo+f36hJiC
7nSOhxIWG+lALqSfJ2FcbleM3lu3Ya4WXmH09LhqoyiH2h6nA1HPvJJf1v/2tHAY
Xy/vb7xQRIcTzmnkNyMtu4UCEE24s6b05N0Nbh/TI77Ab5uKAd2tLqjweeMkJsnP
rIk5fuvWHDiNyX6W1YWC89spWIHRNnFcBuPEreN7rwp/Os6Kj644E4Y2m39U6U5l
Wa58/TiaCppTy7qpumbcNM2aOBHwKDJWsQkjIdpgxyp+WZJa/hU=
=4PLB
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
