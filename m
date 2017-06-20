From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/qedr: Notify user application if DPM
 is supported
Date: Tue, 20 Jun 2017 13:41:04 +0300
Message-ID: <20170620104104.GS17846@mtr-leonro.local>
References: <1497790871-23945-1-git-send-email-Ram.Amrani@cavium.com>
 <1497790871-23945-2-git-send-email-Ram.Amrani@cavium.com>
 <20170619155553.GB10188@obsidianresearch.com>
 <BN3PR07MB2578EC6DD9C3DF920388418AF8C50@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oJFDFiWc3BlD0xT/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB2578EC6DD9C3DF920388418AF8C50-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oJFDFiWc3BlD0xT/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 20, 2017 at 08:34:24AM +0000, Amrani, Ram wrote:
> > Um, how is uapi compatibility achieved here? I don't see any size
> > tests related to qedr_alloc_ucontext_resp:
> >
> > struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
> >                                         struct ib_udata *udata)
> > {
> >         struct qedr_alloc_ucontext_resp uresp;
> >         rc = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> >
> > Seems bad.
> >
> > Same with the other patch.
> >
> > Jason
>
> It does seem bad. Did you had in mind something like this:
>          struct qedr_alloc_ucontext_resp uresp;
>          size_t copy_size = min_t(size_t, sizeof(uresp), udata->outlen);
>
>          rc = ib_copy_to_udata(udata, &uresp, copy_size);
>
> If so, it makes sense to me to protect everybody's transactions.
> I.e.:
> 	static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len)
> 	{
> 		size_t copy_size = min_t(size_t, sizeof(uresp), udata->outlen);
> 		return copy_to_user(udata->outbuf, src, copy_size) ? -EFAULT : 0;
> 	}
>
> Likewise, a protection can be added for ib_copy_from_udata() too.

mlx4 and mlx5 don't need such protection, because they calculates the
response length and ensure that no extra data is copied.

Thanks

>
> Let me know if I'm missing something. If not, I'll send a patch.
>
> Thanks,
> Ram
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oJFDFiWc3BlD0xT/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllI+74ACgkQ5GN7iDZy
WKdUMA/8C6lZzIiNI1iZnATkdnmHnc2fIR4npP7EIIBiWJPLeUJr7Z7jRHPCQoWu
Rqfov699uz2ghaAxHE4TOdGPWllwZmIAya6X4AAwDt6ZIu1hGU7l3av6oDTFQzyu
/41ymg04BWoEhBd69YRbWhBLY4uNohUfnvfPukUjMATDEhMuismNYM4VuQmRkMPh
DehY+0LluJ/mcOP0yhyEYQVw7Fmd2g0ikq6HPTHee+iTn7CipUE3x2FztWo/ZR6h
7/oAu4iOF16/zSN5/Olvm0DELeF5maelTWDy2PI87zEzPsVzcwok3PjwmMafLrkg
ZhRkGmZLTgqYut92uzDaonXyY04RzIDEX4VY1o4K0oOL+KgjlN24BDPGE5Za3V5a
xCvFrSaeSkqK1GXMZm6yHfpS9WVHEIS0HBb3xCrnsEqkPHtzWMFpKeUy5jvr/gxw
yMzu+4JYqF3K5rZ/hJ6VM6/baI858a6LV27IFrs5MUAJpxdASbdlFWtXdJ5zrqdu
SwxeOveZcWmKKP1L4sxl1nH/ctYV1zzZLOmmyje4YZiV/RgaKl1W37k/M0cSEQdj
6o7HkLqAov7CzVYKEYEHVyNV5dJjnZl3soS8UsmdEbT3nQzZzyZBfK6SHFVgu3Ce
c+2DQrfBTmboJ6qHKn5F0myoTi09aOM5ivslUtns+Bv9A/W82k0=
=ui8Z
-----END PGP SIGNATURE-----

--oJFDFiWc3BlD0xT/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
