From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix connection teardown race condition
Date: Fri, 2 Jun 2017 18:48:44 +0300
Message-ID: <20170602154844.GZ5406@mtr-leonro.local>
References: <1495113381-15564-1-git-send-email-vladimirn@mellanox.com>
 <1495113381-15564-2-git-send-email-vladimirn@mellanox.com>
 <18c0959d-af48-6db6-68df-ebbe2ef68731@intel.com>
 <20170519034836.GF3616@mtr-leonro.local>
 <1496348542.7171.53.camel@redhat.com>
 <20170601205727.GW5406@mtr-leonro.local>
 <1496358038.7171.77.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ca23f2aBZR6YDKM9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496358038.7171.77.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Ca23f2aBZR6YDKM9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 01, 2017 at 07:00:38PM -0400, Doug Ledford wrote:
> On Thu, 2017-06-01 at 23:57 +0300, Leon Romanovsky wrote:
> > On Thu, Jun 01, 2017 at 04:22:22PM -0400, Doug Ledford wrote:
> > >
> > > On Fri, 2017-05-19 at 06:48 +0300, Leon Romanovsky wrote:
> > > >
> > > > On Thu, May 18, 2017 at 04:12:33PM -0400, Dennis Dalessandro
> > > > wrote:
> > > > >
> > > > >
> > > > > On 5/18/2017 9:16 AM, Vladimir Neyelov wrote:
> > > > > >
> > > > > >
> > > > > > From: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > >
> > > > > root? Might want to check your git config.
> > > >
> > > > It is not the only one issue, I counted 6 violations of our
> > > > internal
> > > > policy/guidelines.
> > >
> > > Is Mellanox planning to address the internal policy issues and
> > > resubmit, or do you want me to munge out the root entry and take
> > > this
> > > patch as it is?
> >
> > Doug,
> >
> > I resubmitted it a long time ago. It was already reviewed by Sagi and
> > Max.
> > https://patchwork.kernel.org/patch/9739179/
>
> Ah, I see. =A0You submitted it as rdma-next while the original was being
> reviewed under -rc fixes. =A0That kept me from matching up the resubmit
> with the original. =A0I'll drop the original. =A0Thanks.

I submitted it to -next, because it fixes the "old" issue and anyway it
will go to the stable.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Ca23f2aBZR6YDKM9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkxiNwACgkQ5GN7iDZy
WKdG7xAAlHYzf9rhSvmbk+Mkih1HbQ6SSVUfkp62EUoprDhx75q6gXPdsQRNl/4X
OOc3tLprITv/kTAnq39ZElJs66eUs6loY69YqfTAPEGuf+znXibnM/br+4qSGdmU
V+rHisAtkl/QkAHv5JotB2vqS4KyyLeDLs6mlpGmjEgjSkzCTXyleDMl9XyLqbTd
cvQYe0CfhHfehBa5pNgKvxL/wehcXJvjRz58rVYKUJ8hNTVjvf9Mzx1dEGg+bKy2
19t8GKvX6+PkAlQLyL/NylpnZhWr8yYoIql1lvXNLfMTCuSdxkmNHighFeXielYq
kaER37JXPICblzPSUIbJgLKXvrMiXviuu1qoVFVllGei2wX5QiY/gAH83Cmv9GmZ
0KHnO4I/omwVGOtYnZZvWFR/MnSFY5rerng7DU+AAvHlsiTBQLQpyx/CQfhCs5UB
E+GlNsKgwMs9Kp8YEm/5G0sVC3nlIb/gRXARjITzwOpDCa+D+Rl+0XD3wwJAy9lr
1KmyqFkg7eAHtfOipuHpdlIpJz+i/wEM8EX9gNSbkwjdKf9NfEBQKQcGYtz2JpVX
G5OjMyb1lVKumS919geBevCeBQg032CJ/ET6tsI7aKqJpvu2BNQmUN7zQzTZ6xqU
wPTUTj/upofKtkvD8aG1x13T3O7v96J3Vrig3YxOqSn7l+RqyGE=
=Yzm2
-----END PGP SIGNATURE-----

--Ca23f2aBZR6YDKM9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
