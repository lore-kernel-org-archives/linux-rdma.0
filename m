From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 10:14:55 +0200
Message-ID: <20171113081455.GD18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <f7c88e99-5726-2f3e-9763-1f179ac6b292@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y4E6tNLPdzD/Rx2+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f7c88e99-5726-2f3e-9763-1f179ac6b292-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Y4E6tNLPdzD/Rx2+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 08:53:19AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 10/11/2017 =E0 21:24, Leon Romanovsky a =E9crit=A0:
> > On Fri, Nov 10, 2017 at 06:36:28PM +0000, Davis, Arlin R wrote:
> >>> I agree there is a big need for that. Currently reviewing all the pat=
ches I haven't
> >>> read (only 1000 mails to go...) to see if they need to be backported =
on top on
> >>> rdma-core 15 for the next SLES.
> >>> I'd gladly help maintaining this as I'm spending time on it anyway.
> >>> I'll leave wiser people debate and ready a doc on how this should be =
done
> >>> though :)
> >>>
> >>> Nicolas
> >> Thanks Nicolas.
> >>
> >> Ok, I am not sure what details the rdma-core maintainers are looking f=
or in a document. Let me start the discussion with the following:
> > More or less, you wrote everything that I expected, just need to post it
> > as a patch so I can apply it to rdma-core.
> >
> > The thing which is important to me is how long that stable will be main=
tained and how often they will be opened,
> > I don't want to see 12 stable branches after 3 years of running rdma-co=
re. It releases every 2-3 months, so theoretically
> > we can find ourselves creating stable branches after every release (4 p=
er year).
> >
> > Thanks
> >
> >> Stable Branch Release
> >>
> >> Current Maintainer: Nicolas Morey-Chaisemartin <NMoreyChaisemartin@sus=
e.de>
> >>
> >> Upstream rdma-core is considered stable after each mainline release. B=
ranched stable releases, off a mainline release, are on as-needed basis and=
 limited to bug fixes. All bug fixes are to be backported from mainline and=
 applied by stable branch maintainer. Branched stable releases will append =
an additional release number (e.g. 15.1) and will ensure that Travis CI rep=
orts a successful build.  Mention the frequency of stable releases or keep =
it "as is" cadence?
> >>
> >> See versioning.md for setting package version on a stable branch.
> >>
> >> Arlin
> >>
> >>
> >>
>
>
> Resent because Thunderbird screwed up my content.
>
>
> What would make sense IMHO would be to have people submit their patches t=
o stable branches through a github issues.
> Each issue should be tagged in all the main/stable release it is in and c=
ontains a SHA1 to a patch from master that contains a fix.
>

I personally against such close integration with github and creating two
different places for communication (ML and github), but as Jason said,
the core team has no plans to manage it and it will be your decision on
how you will manage it.

Right now, the gihtub issues are disabled in rdma-core, because we
didn't want people open bug reports there instead of posting to the ML.

Thanks

--Y4E6tNLPdzD/Rx2+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJVH4ACgkQ5GN7iDZy
WKcc1xAAvNiO9qakR+uYTS7tTgGQ5ydG2pdhv2TJcedUsJfowJvx3on8gRj3+9N5
u/dogix2VA8ofu4cbxzvE4eLUH9XoPRK3jTIjM0HybCKVNYHD9KnB0DEELuMqyaJ
KUo/6Kg3+jV7NyAW0Wzn6rNO9LDT+OS69cgSyndhsZRJafMucCTx0k6sHE5AX9v8
Wb+XKJ5u340QjAdW2oCaEipGQ9t3lX3FJAlCXMNDJL4doSeaRIFJo3R5n5cg2QKc
Um742czpC7/48fg0qd6rpPamAFBEQnNLpDu0ePHfXCLJzks7Bg8tofMd74atq+Jc
agi56JGEDaLAYio6sqsDihP0xTBOlfBD2MbN7/ZDpAqUC39chFQuXTbYQdhXoXct
Pz8HUGOVSkQwEtezXxowCo2J5Qal94hEQA0u2eA+q9dYcG5NkDFscPd40jDbN9Jn
gXXcrCRRJLYFQBCL5wPgG8paJKEHvgkzqlnwiTZ3tZA3k8dec5cSuoS+wCh07Q/+
gtAvqa+/jX4+A9Eh1sUrePV58xs4yvcXl5UHsMFf+kUPJYV5eis19kVW+qv/zUO6
j11hKve+Mob2aKXdUpq+LdVtKs9OanigWyzwaFh1YdN85jBniHtkoADHqEyTvb+X
qA0nr0seiPuSTYgg3w28wQqLHyNGZtlSo2L0FKvOAsQz+a/fu5g=
=jWDo
-----END PGP SIGNATURE-----

--Y4E6tNLPdzD/Rx2+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
