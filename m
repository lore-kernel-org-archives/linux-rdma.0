From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Tue, 7 Nov 2017 13:27:10 +0200
Message-ID: <20171107112710.GF18825@mtr-leonro.local>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
 <20171104100846.GA1636@mtr-leonro.local>
 <7dba9ad9-5a71-c4fe-b2b9-ccc35c188f8c@huawei.com>
 <20171106020945.GA26011@ziepe.ca>
 <2622b4b1-5bc4-ec04-c9a4-d78d5a727f4c@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kR3zbvD4cgoYnS/6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2622b4b1-5bc4-ec04-c9a4-d78d5a727f4c-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kR3zbvD4cgoYnS/6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 07, 2017 at 06:59:05PM +0800, oulijun wrote:
> =E5=9C=A8 2017/11/6 10:09, Jason Gunthorpe =E5=86=99=E9=81=93:
> > On Mon, Nov 06, 2017 at 09:43:05AM +0800, oulijun wrote:
> >> =E5=9C=A8 2017/11/4 18:08, Leon Romanovsky =E5=86=99=E9=81=93:
> >>> On Wed, Nov 01, 2017 at 10:13:28AM -0600, Jason Gunthorpe wrote:
> >>>> On Wed, Nov 01, 2017 at 06:00:40PM +0800, Lijun Ou wrote:
> >>>>> @@ -385,7 +385,7 @@ static int hns_roce_v2_poll_one(struct hns_roce=
_cq *cq,
> >>>>>  		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
> >>>>>  			wc->opcode =3D IBV_WC_RECV_RDMA_WITH_IMM;
> >>>>>  			wc->wc_flags =3D IBV_WC_WITH_IMM;
> >>>>> -			wc->imm_data =3D cqe->rkey_immtdata;
> >>>>> +			wc->imm_data =3D be32toh(cqe->rkey_immtdata);
> >>>>>  			break;
> >>>>
> >>>> This can't be right, wc->imm_data is marked be32.
> >>>
> >>> Lijun,
> >>>
> >>> Are you going to fix it?
> >>>
> >>> Thanks
> >>>
> >> Yes=EF=BC=8C I think that it is not fixed. I have tested the roce devi=
ce
> >> aginst hip08, D05(ARM64) and CX3, and I also have tested the D05
> >> aginst cx3 and D05.  I also tried to run sparse and don't produce a
> >> userful result. I also follow Jason's advice. Is it ok?
> >
> > The patch I sent fixes the bug properly, you need to review and
> > validate it.
> >
> > You'll also need to get sparse to work, in the mean time use
> > 'buildlib/cbuild pkg travis' which will run sparse on hns once you
> > apply my patch.
> >
> yes, I am solving the warning during run the sparse. I have run the travis
> CI check according to the README.md before send every patch
> > My patch fixes all the sparse problems.
> >
> > Jason
> Hi, Jason&leon
>   Do I need to clean this patch and send a new patch refer to Jason's pat=
ch?

It will be the best option.

Thanks

> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
>
>

--kR3zbvD4cgoYnS/6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloBmI4ACgkQ5GN7iDZy
WKdB9xAAlE0l4oGOpW2ZY0RLH1h8srieHiLt5A5sC2SGz8g664oFlC8V7yL+z7u7
qCG7SuJgySE/mL3wNOtNceMKfMLWLvwwKT/o74GiNynzbaMPxqCSHJnfZTvuCkCH
tn203T+gK1+XnlvC8EuVEErBtsiNbQHfZ8xVc2sQwarW244pqyU0BfD4kSTFU0SG
ReIcA6Uv2QH/lkyt3Db3Qyq0t+PtMdcMM+NLe4qExrAiZV9ryQYqPYQxqfVWrmRl
kFgPq9amvo7h4h6DfCwIJAMo9V9V/EOAW1qDhC4sYGnVX2BAvsGYmb83Twiv+YKg
w3NPT4h0KyTXMcLx8/Wkg+yAfL7O+62u2lgrjWiSMeKVwpPzjftUHE3/MB1+V7oa
XgIDeO+cYLxuSqToF2lsrhW0Pp9013Sh4C6QEVH/i7NiWE0FRh0cp9pa7tleRgjX
Dw/8OjkirWZ98hrGIqUwQcZpvqcdLDTUCfLaL4yMK5WZ9jj6qLYXNWLS3Vj5wBPY
/moVnQB3pAP/u2Yj70CFpvJ1KyimFdRI/LliWX6lE/fphtKaUTgqz3o1o+zraeHH
RwB+YGFGJq0Hg34gFq5x+HYGWJOi75pDl+evZtzpcCqaeI71ooR8IBrSDDeuMTyF
pUhgpvUlONeF96BHy29UnijHeEcu4nXVf2kwHD+hCLcnZpi0vl0=
=sHC2
-----END PGP SIGNATURE-----

--kR3zbvD4cgoYnS/6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
