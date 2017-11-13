From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 12:41:46 +0200
Message-ID: <20171113104146.GG18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <f7c88e99-5726-2f3e-9763-1f179ac6b292@suse.de>
 <20171113081455.GD18825@mtr-leonro.local>
 <cb56c548-4962-58be-d293-5b4169c24b2e@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="00Xftji29zlN/ZGB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cb56c548-4962-58be-d293-5b4169c24b2e-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--00Xftji29zlN/ZGB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 10:16:32AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 13/11/2017 =E0 09:14, Leon Romanovsky a =E9crit=A0:
> > On Mon, Nov 13, 2017 at 08:53:19AM +0100, Nicolas Morey-Chaisemartin wr=
ote:
> >>
> >> What would make sense IMHO would be to have people submit their patche=
s to stable branches through a github issues.
> >> Each issue should be tagged in all the main/stable release it is in an=
d contains a SHA1 to a patch from master that contains a fix.
> >>
> > I personally against such close integration with github and creating two
> > different places for communication (ML and github), but as Jason said,
> > the core team has no plans to manage it and it will be your decision on
> > how you will manage it.
> >
> > Right now, the gihtub issues are disabled in rdma-core, because we
> > didn't want people open bug reports there instead of posting to the ML.
> >
> > Thanks
>
>
> I just saw that on Github. And yes people will open bug for master there.
> I don't want to intrude in=A0 your workflow..

Feel free "to intrude", I'm not alone here.

>
> I'm OK with keeping just the ML for the moment. If it becomes too much of=
 a mess, I'll come back with my github request (or something else).
> How do you suggest flagging me for those patches ? Should we follow the k=
ernel stable process ?

I think so, the kernel process works, we just need to adapt it to rdma-core.
Regarding the flagging procedure, we can do like Greg and Sasha do.

Open email account (e.g. stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org), connect it to /dev/null,
so people won't get bounce emails while they sent patches to it, and
once a week or two run script [1], which will check master branch and
cherry-pick patches with Cc: stable@ in their commit messages.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/sashal/stable-tools.git=
/tree/


> Meaning either:
> - CC me with version information on a submission to master
> - Send a mail to ML + me after patch has been accepted in master with a t=
ag like [PATCH rdma-core stable], a list of patch-id from master, the versi=
on they apply to and why they should be picked
>
> Do you have any request/idea/suggestion about the release rate of the sta=
ble branch ?

I don't have.

>
> Nicolas

--00Xftji29zlN/ZGB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJduoACgkQ5GN7iDZy
WKfUCg/8CBpVj0IYy3QBLs5tFiATEFeRBEPjxWiW2WSmIO15C1HVmNSFDBeH6IqB
3loHmk2bn4PIkT7agT9UNWa2ztEphf/sZwo0x9eCPG+p6R4gA/wDRt7evoDq3LkD
OFbb4eoBRFXzp+OZV3GxRpsMvukkcyJjo8MdsHCsmMHYwLJr7HKtNOTVQEc1cFA5
3pjs9sic36+WZmc7a+B/fZjSVmO0Bzmkq+Xpb5N0IEHwBvxzpe20Urd9dS30jKQM
N8t879ck7nJGdKR25Jl915of+tbyQwtvTSroxrESTg3MYoJGDRo4fgUzQulCt3ud
uIhr11rr4daHbErBY86kke/zD009l5ah591PMYwLOciHDPswbRDRnHvBM/toqMAv
pVQ8eJImhOnQ8+jiS+BfDz9rDveIWJQ+vX7vxiyQTQzt4oPs3ObAvq1jtvBA3mn8
LCf/CBZJpRbmPTAgiTlb2ML/nu92L1FgtsHLEBRPyEw51cG9mV6JwnLigCs0JU38
407APs+robJ/7wfanEqIzBFKj/bAZRiSGTLCEqVW4qJico6Mn3PVU5raJdhwA1Qu
96ZI2f0JwYpepKIJyrhtVTCseho8U2gktUKlX9gsiMZh3qfptehuKRgu2EiM4gRs
nWzEdnaBw7f/Uqp+wqwemyRbZFiejdXryQCTr9zUDeC5MJdvfew=
=MtyA
-----END PGP SIGNATURE-----

--00Xftji29zlN/ZGB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
