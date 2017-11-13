From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 09:38:46 +0200
Message-ID: <20171113073846.GB18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <c3fd8037-9d80-f6a2-1e34-b9169f512784@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FntOJnOOIM0rA1zI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c3fd8037-9d80-f6a2-1e34-b9169f512784-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FntOJnOOIM0rA1zI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 08:14:03AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 10/11/2017 =E0 21:24, Leon Romanovsky a =E9crit :
> > On Fri, Nov 10, 2017 at 06:36:28PM +0000, Davis, Arlin R wrote: >>> I a=
gree there is a big need for that. Currently reviewing all the patches I ha=
ven't >>> read (only 1000 mails to go...) to see if they need to be backpor=
ted on top on >>> rdma-core 15 for the next SLES. >>> I'd gladly help maint=
aining this as I'm spending time on it anyway. >>> I'll leave wiser people =
debate and ready a doc on how this should be done >>> though :) >>> >>> Nic=
olas >> >> Thanks Nicolas. >> >> Ok, I am not sure what details the rdma-co=
re maintainers are looking for in a document. Let me start the discussion w=
ith the following: > > More or less, you wrote everything that I expected, =
just need to post it > as a patch so I can apply it to rdma-core. > > The t=
hing which is important to me is how long that stable will be maintained an=
d how often they will be opened, > I don't want to see 12 stable branches a=
fter 3 years of running rdma-core. It releases every 2-3 months, so theoret=
ically > we can find ourselves creating stable branches after every release=
 (4 per
> year). > > Thanks > >> >> Stable Branch Release >> >> Current Maintainer:=
 Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org> >> >> Upstream rdm=
a-core is considered stable after each mainline release. Branched stable re=
leases, off a mainline release, are on as-needed basis and limited to bug f=
ixes. All bug fixes are to be backported from mainline and applied by stabl=
e branch maintainer. Branched stable releases will append an additional rel=
ease number (e.g. 15.1) and will ensure that Travis CI reports a successful=
 build.=A0 Mention the frequency of stable releases or keep it "as is" cade=
nce? >> >> See versioning.md for setting package version on a stable branch=
=2E >> >> Arlin >> >> >>
> What would make sense IMHO would be to have people submit their patches t=
o stable branches through a github issues.
> Each issue should be tagged in all the main/stable release it is in and c=
ontains a SHA1 to a patch from master that contains a fix.

Nicolas,
Something went wrong with your mailer, It created long lines and broke line=
s.
Can you please resend so we will be able to read it?

Thanks

--FntOJnOOIM0rA1zI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJTAYACgkQ5GN7iDZy
WKd2EQ/7BqNCzPXLMPrG0y8mzbKfXEYL9OtCyi+GflANeMQ3FTzcGZlRRFwSAZEt
9qKKYmJyDCGdTv3WKf59F8E/3S1tPhk3/TxO5XPciDQyGibqDZ4Q3H+G/c17wRHj
5+LbgeaVfHiLUPO85MDjeOSgjQHDgH+wL+8bAYPr9OYeCknjpZ16WFhAszE2vQHC
Fe4A7xKTW3F5C3zYTyMA+THzDoBTTDZWoRZvBmUJIzVzfVgGlP3QaneMpIoJfVtX
ZmthNDvJHKZ3aADLiYfg5O3OUkPUj53mN5FJelTq3fhPHS3YEdX6AmBig3uvOZof
B2Czba3XI3BqDOlizLsFD5MBfbVLwZv3NYpJzm2qJnMKyG2o5SqKMUEh3vZ5sbuG
cQz8/3pTQEVHyjiDrRBY2TOGPYT2qTQHSu5MZYJcpImaV3lHGLor3S9vTHePX5aO
CyCW2XX2QjWsG6mcXbcTcQrhIKWwuDjo99Ei33tuNS+2/gmDbFpVjKdxjjx25GiN
02XgrxW79UgRqa3/j3n8Kyp9Me7Dw6o49e389Ta0rBH8RKAlViTGBBa5edTYO7+h
ddPJNc2Nhy3lXmFBoR7zSESG6NtLFFzcxFq2pGMB4yNM9UPac1VsST4i7ltoS5iN
4fk009f1PZXt79sM342Bgo9XZEHVu4pNKObtRqxnPQfY99ncXP8=
=xgMi
-----END PGP SIGNATURE-----

--FntOJnOOIM0rA1zI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
