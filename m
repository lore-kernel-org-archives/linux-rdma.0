From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock
 is held
Date: Thu, 16 Nov 2017 06:48:52 +0200
Message-ID: <20171116044852.GE18825@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-29-leon@kernel.org>
 <CAJ3xEMixWZvCVDYTK1-2w0pYdy65HExvN2ae7y=hAkk6htrETg@mail.gmail.com>
 <VI1PR0502MB3008970D8D6034E4A2D952DED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAJ3xEMhdp_2BYPA+s+We5Qgatye8hNLUYGnZu0ZimpPb86U-VQ@mail.gmail.com>
 <VI1PR0502MB300897A41317A06FFA5CC329D1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAJ3xEMiQc_am=rqYg2TyNqU1s9uGSE-wcVxGmW244x8XJNDuyg@mail.gmail.com>
 <VI1PR0502MB30081717A7E8BEC1B7CFD471D1290@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2xLJ6++3TBBpDvnj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30081717A7E8BEC1B7CFD471D1290-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2xLJ6++3TBBpDvnj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 15, 2017 at 11:10:54PM +0000, Parav Pandit wrote:
> > -----Original Message-----
> > From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > Sent: Wednesday, November 15, 2017 1:53 AM
> > To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Hef=
ty,
> > Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Subject: Re: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin =
lock is
> > held
> >
> > On Wed, Nov 15, 2017 at 12:32 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > wrote:
> > >> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> >
> > >> >>> In case of LAP are used for RoCE
> >
> > >> >> AFAIK APM is not supported with RoCE, isn't that? if yes, on what
> > >> >> HW/RoCE mode and how do you test that?
> >
> > >> > This particular patch in this series is not tested on RoCE.
> > >> > APM is not supported but injecting such frame in network is not im=
possible.
> > >> > We don=E2=80=99t have particular checks to reject such frame for R=
oCE.
> > >> > So I prefer to fix the issue before getting such hang/oops report
> > >> > when issue is
> > >> evident in code.
> > >>
> > >> mentioning testing, in this series you did bunch of fixes for the IB
> > >> core, CM and CMA.
> > >>
> > >> Would be good to add a section in the cover letter mentioning under
> > >> which type of testing the modified code has gone through.
> >
> > > It's been tested for RoCEv1, v2, IPoIB with ConnectX4, ConnectX3 HCA =
with
> > perftest, rping, krping tools.
> > > In few individual patch, it's been mentioned how is this tested.
> >
> > Please also add more info (and in the cover letter please) on IPv4 vs I=
Pv6, unicast
> > vs multicast, etc.
> Is there a template that you can share that linux-rdma follows that I can=
 use to mention what tests are done?
> Any example past cover letters that I can refer as reference?
>
> Depending on how much information you expect in cover letter, this patchs=
et can have many revisions just for cover letter.
> So it would be best for you to share the template that I can fill in for =
v1.

Parav, relax
There is no need to respin.

I reread responses and there are two types of response/disputes:
1. Jason vs. Erez. Jason is in favor of having memory leak as long as
IPoIB doesn't filter input (in our case wrong input), Erez in favor
of fixing memory leak. I'm with Erez.
2. Or vs. rest of the world. No doubts that the commit messages and
cover letter are important, but they are not the most important part
of this series to justify resubmission.

And yes, you should listen to the feedback provided here and improve
your commit messages in next submissions.

>
> > You touched the CMA and addr modules quite heavily on all these areas, =
need to
> > cover them in testing.
> Which are those tests that I should execute apart from above summary?
>
> >
> > did you test APM? I don't think it would be correct to change the CM AP=
M code
> > without proper testing.
> As I already told this particular patch is not tested. All others are nee=
dless to say tested.
> I do not have APM setup to test this fix.
> I am ok to drop this patch and provide fix when crash occurs later on.

Not everything is possible to test, it doesn't mean that we shouldn't fix i=
t.

Thanks

--2xLJ6++3TBBpDvnj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloNGLQACgkQ5GN7iDZy
WKc3NBAAhvbvwibgVIlqubgDF/SPCdXM6dgh2WjH9kU2gElpElhJUBBqQnbsSVA+
1xVxtF78dgY6UCUegIPHc+zpOqQnVtAv1EfJCoXJVZHpUPmxlv4rCHd/SsCCU0XN
7Aa0gKSXMYYeDw2PsQltUUo6PaaY9bt7PC30GH9xlcAwFozr5KCKBfoQC4RPdDax
1QOfDaAutyKPCsDu0JEv6xINaEokYjTuwBJvuhZNnOtNcAJwPt9B6xmpfGdn7AFe
ZTP/vdS6gNpM4ksBiIvIEGtFWkyaeKTXKGq+iBKunQkVgibFRc3E2mh7m3Sh5abn
GVg8w9ae/viI/rYvlwcS5p96UuLAu/jFyzMoZDh4uufIGVrF4XLfHhxVTNvQQgt1
O3GwKbbIsLkEzMcmNcDTWYMJ11TAMcBvYrJMJbCtMwzuGkf4yLW6sEx2CDn8+S9n
C8esuZk8/JVglcFpNFNOMTBIMn2OlO9lMBfLc3paKXu4pnaCjT9ihQ7FBQB7ZEyE
+OY/7jow4PZEwIYwhNEiCVLGYavt9crqjnHRU92zXcHti7FSz/P0m5vmc0XzlJ7a
214i8k1GhpuMc6X9Lf+2LUGX3CDWDKvFvjVtwdkCMd5wXy+wILOhLN+u5hclyne4
2LCzWmErp7L6Akn1iPwkZM0vvcYIMoi20MrZTRYQaGvb8QLJpOU=
=5MeY
-----END PGP SIGNATURE-----

--2xLJ6++3TBBpDvnj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
