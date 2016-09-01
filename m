From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Thu, 1 Sep 2016 19:20:43 +0300
Message-ID: <20160901162043.GD21847@leon.nu>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
 <1471987907-6336-7-git-send-email-leon@kernel.org>
 <1472738739.16467.8.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472738739.16467.8.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 01, 2016 at 02:05:44PM +0000, Dalessandro, Dennis wrote:
> On Wed, 2016-08-24 at 00:31 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=A0
> > -#define HFI1_CMD_ASSIGN_CTXT=A0=A0=A0=A0=A01	/* allocate HFI and
> > context */
> > -#define HFI1_CMD_CTXT_INFO=A0=A0=A0=A0=A0=A0=A02	/* find out what reso=
urces
> > we got */
> > -#define HFI1_CMD_USER_INFO=A0=A0=A0=A0=A0=A0=A03	/* set up userspace */
> > -#define HFI1_CMD_TID_UPDATE=A0=A0=A0=A0=A0=A04	/* update expected TID
> > entries */
> > -#define HFI1_CMD_TID_FREE=A0=A0=A0=A0=A0=A0=A0=A05	/* free expected TID
> > entries */
> > -#define HFI1_CMD_CREDIT_UPD=A0=A0=A0=A0=A0=A06	/* force an update of P=
IO
> > credit */
> > +/* allocate HFI and context */
> > +#define HFI1_CMD_ASSIGN_CTXT=A0=A0=A0=A0=A0(HFI1_CMD_BASE + 0x01)
> > +/* find out what resources we got */
> > +#define HFI1_CMD_CTXT_INFO=A0=A0=A0=A0=A0=A0=A0(HFI1_CMD_BASE + 0x02)
> > +/* set up userspace */
> > +#define HFI1_CMD_USER_INFO=A0=A0=A0=A0=A0=A0=A0(HFI1_CMD_BASE + 0x03)
> > +/* update expected TID entries */
> > +#define HFI1_CMD_TID_UPDATE=A0=A0=A0=A0=A0=A0(HFI1_CMD_BASE + 0x04)
> > +/* free expected TID entries */
> > +#define HFI1_CMD_TID_FREE=A0=A0=A0=A0=A0=A0=A0=A0(HFI1_CMD_BASE + 0x05)
> > +/* force an update of PIO credit */
> > +#define HFI1_CMD_CREDIT_UPD=A0=A0=A0=A0=A0=A0(HFI1_CMD_BASE + 0x06)
>
> This is a minor issue, but the problem here is when we build PSM
> against this kernel it will no longer work for older kernels because
> the value of HFI1_CMD_ASSIGN_CTXT has changed where as it used to be 1.
> Right now PSM is backwards compatible, this breaks that compatibility.
>
> So while no one uses the __NUM() macro directly it lets us not change
> the PSM command values. Can we put that part back and keep the command
> values unchanged?

Sure, I'll post new version.
Just to be sure, you are not using __NUM() and I can redefine that
macro, am I right?

Thanks.

>
> -Denny

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXyFVbAAoJEORje4g2clinxFYP/1DNqbbLkIcpa6e3UNrIPSLE
z4Y5EBEQD510FuoEP8IXDvI5eW/ZaalPqn34tvBdFjbfuXZymHJMRkBZ5rN3zvy/
L5Uo1FZENSd4qUsldmWurfUghITnbueU4tWlctDUZXnyeZWwXVoM/K8IRyTJVP1n
byh/r6n2W9WyvR0yNxVQRR98ckEKphEmUbNpRym2wp8E7w2XPfh8xKkd9fmRAw+p
FrABnRJdY63rXkBbmeTxRLyu8dgyrOYiOhZMFcU7XfWDlP9371Ootw1AjlW/hsP/
CQDMJqLTIJ+/S3ups/k6qknHnau31l6MXWY+jKQHHScxS6tWDpqSp92GRuGgSksi
Qb4Q+PhJ6982wPQdgaygK1A/4CgUGAqBl2ZU/VlVyVjSRn3gWoOxyA2gNdhSs1iL
HR8lVLeuvN7LeUyE6vNgoPUP6VBvCqa3MaVm+kbzAplcF8v8/KlOnLkxUZ/00l+5
FfI+e9YxDlRvwz3aty9OSGXuG2L7VdOyoW9s9Z3psZ1aP5uyQ291Wuqoe2NPvNGU
H4I7yAs/7vqrhEVI0crzhtpI1RvthKu0VoEbXgeBbpnb7V2YVE9votwX0ANM92L0
Hz2z5hUMUMMuS6k80x4OHhbMczm4iEe+4QDjfMswaXS/Zyh4DTAQxq2+dODw666B
41HlB1+uUHgv5Rsbrjw7
=+URd
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
