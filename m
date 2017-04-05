From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] IB/IPoIB: Rename qpn to be dqpn in
 ipoib_send and post_send functions
Date: Wed, 5 Apr 2017 19:35:46 +0300
Message-ID: <20170405163546.GG20443@mtr-leonro.local>
References: <20170404191732.31895-5-leon@kernel.org>
 <201704050840.SLVNyMTT%fengguang.wu@intel.com>
 <20170405103838.GE20443@mtr-leonro.local>
 <1491404447.2787.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VuBTcNUPe5zwk2q6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1491404447.2787.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VuBTcNUPe5zwk2q6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 05, 2017 at 03:00:48PM +0000, Bart Van Assche wrote:
> On Wed, 2017-04-05 at 13:38 +0300, Leon Romanovsky wrote:
> > On Wed, Apr 05, 2017 at 08:56:29AM +0800, kbuild test robot wrote:
> > > Hi Erez,
> > >
> > > [auto build test ERROR on rdma/master]
> > > [also build test ERROR on v4.11-rc5 next-20170404]
> > > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >
> > It should be applied to v4.11-rc3 and not to -rc5.
>
> Hello Leon,
>
> Will it be possible for Doug to apply this series to his tree without
> rebasing this patch series on rc5 instead of rc3?

Yes, I tried it now and it worked in both directions without conflicts.
I merged these patches into rc5 and rc5 into them.

However, I asked from Doug explicitly during the OFA on which rc should
I base my submissions and he asked to submit based on rc3, so I did.

Thanks

>
> Thanks,
>
> Bart.

--VuBTcNUPe5zwk2q6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljlHOIACgkQ5GN7iDZy
WKcelg//ZasHdWlIP4iCdMotEAt/L4fDLZDyk1OdN4fYWcpjsXj0hOMaPPnGjdQA
IGrbdJdFiLvzEINv/kEbraifWtC3LEu1AypV0kmWp0bOO/g4QcqgmRpAdPXuKH+s
h471P44fcJ+jOebMiikVVEDdTIxY+xBep4CqWq/faHoo8HY9+eG6NlCgU3OOh5jB
cqADh84f67McA4+WWFsqLY6VpZjmI5B+Rly7g3FrGjefBHfLBkIjObCQtL0/Pzp4
HTUrVdTJm0SU27TNjfG9dojDqpDL49dvF/iVTyzuwBRRywYSBbiAun45Kp4msRfi
ryg2S7wsGiHry+UnJbM4vzuKe9v7MPsHzWkyy1DcuEhLhMnn7dFoATyoIi295Qp2
UXn/F6m4BxEhMizocr0xOta+jddbCDQOcZFyfuS/oB2AseX3ln5rKwkgCreOj/Om
GmZHgfhGXCKWigd7kMiCyuvQnSTf0OyGO+8Ll15kHCAUqIzPj+6DUvouWmNKKYgF
LqnWT2ZXqPEdZnZXrWarWkInCLaZ9hJj9zyyQ2GZ8LhWN+vQAuSIHmsCO63Phjq7
pn3hyEH4txB8j2222kLVy6uy2Q1QrLaT8Xh0d73EZ4PWYeZhlXFKc35jxN0A+moM
ILSKUnyWCvum8Ohy182nkMOtApEUEhM0xv/e+Ure4fR+RiUiab0=
=Z/NC
-----END PGP SIGNATURE-----

--VuBTcNUPe5zwk2q6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
