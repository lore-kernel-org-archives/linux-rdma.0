From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 13:43:00 +0200
Message-ID: <20171113114300.GJ18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <f7c88e99-5726-2f3e-9763-1f179ac6b292@suse.de>
 <20171113081455.GD18825@mtr-leonro.local>
 <cb56c548-4962-58be-d293-5b4169c24b2e@suse.de>
 <20171113104146.GG18825@mtr-leonro.local>
 <838fb26a-363e-9874-728c-76e614943e56@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4ehG9HxkuyoI6jtY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <838fb26a-363e-9874-728c-76e614943e56-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4ehG9HxkuyoI6jtY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 11:56:19AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 13/11/2017 =E0 11:41, Leon Romanovsky a =E9crit=A0:
> > On Mon, Nov 13, 2017 at 10:16:32AM +0100, Nicolas Morey-Chaisemartin wr=
ote:
> >>
> >> Le 13/11/2017 =E0 09:14, Leon Romanovsky a =E9crit=A0:
> >>> On Mon, Nov 13, 2017 at 08:53:19AM +0100, Nicolas Morey-Chaisemartin =
wrote:
> >>>> What would make sense IMHO would be to have people submit their patc=
hes to stable branches through a github issues.
> >>>> Each issue should be tagged in all the main/stable release it is in =
and contains a SHA1 to a patch from master that contains a fix.
> >>>>
> >>> I personally against such close integration with github and creating =
two
> >>> different places for communication (ML and github), but as Jason said,
> >>> the core team has no plans to manage it and it will be your decision =
on
> >>> how you will manage it.
> >>>
> >>> Right now, the gihtub issues are disabled in rdma-core, because we
> >>> didn't want people open bug reports there instead of posting to the M=
L.
> >>>
> >>> Thanks
> >>
> >> I just saw that on Github. And yes people will open bug for master the=
re.
> >> I don't want to intrude in=A0 your workflow..
> > Feel free "to intrude", I'm not alone here.
>
> Well from my review of v15, the amount of work at the moment seems very r=
easonable.
> So I dont think there is a need to intrude ... yet !
> >
> >> I'm OK with keeping just the ML for the moment. If it becomes too much=
 of a mess, I'll come back with my github request (or something else).
> >> How do you suggest flagging me for those patches ? Should we follow th=
e kernel stable process ?
> > I think so, the kernel process works, we just need to adapt it to rdma-=
core.
> > Regarding the flagging procedure, we can do like Greg and Sasha do.
> >
> > Open email account (e.g. stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org), connect it to /dev/nul=
l,
> > so people won't get bounce emails while they sent patches to it, and
> > once a week or two run script [1], which will check master branch and
> > cherry-pick patches with Cc: stable@ in their commit messages.
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/sashal/stable-tools=
=2Egit/tree/
>
> Sounds fine to me.

Need to document that.
BTW: I opened stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org email, if you want I can forward all
emails from that account to you, right now, everything goes to /dev/null.

Thanks

>
> >> Meaning either:
> >> - CC me with version information on a submission to master
> >> - Send a mail to ML + me after patch has been accepted in master with =
a tag like [PATCH rdma-core stable], a list of patch-id from master, the ve=
rsion they apply to and why they should be picked
> >>
> >> Do you have any request/idea/suggestion about the release rate of the =
stable branch ?
> > I don't have.
>
> Apart from distros, are there people interested in stable branches ?
> If not, we could release simply release around the same time a new main r=
elease comes out (N.1 comes out at the same time as N+1.0), and on-demand w=
hen a distro requires it.
>
> Nicolas
>
>

--4ehG9HxkuyoI6jtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJhUQACgkQ5GN7iDZy
WKeRbA//ZrH37Wfw64PJ3GLUl+dbrWA7Qy7H4a736BVXTtS5pESYI+Z/HJFoDb/l
JjtwCvV4GDBXj+qj98GTLYM6lBjbN+ttWAaG4sIkBu9VjCj2ssMkdSp00V86urY1
NOzaKinz+d1YFB3Od3N0yqE7UVHmC2lXjW0SD2E7xhcDc80r8a4o5+e/SeRxLKN9
2nred5K+TNNiHd23sVtAvhLOQZgjauUNXUzAPK94jXyCCJQJ5Tk++1IMrkg8owS5
EmG4lXdpzZd/ntU38QzmMaDZcZ6OVy/m6KShgeCfy7B0/KtIZk9B31iyRupIiqzJ
mXQ7poVoftmstysuppWDKDpElsi1NUSbBuJVc64595WP5GBLJ7NmwCF4riZvfJII
dUjbgDfMSO/kf2OQ8kGZ1UFIwtrEb12PEzvoLrzQRAEP1emClcDj+ddrH77nUb2M
I7HDElUhedUz9iBE9DWMshno43FUjZV0rc/ky9vbCq5zcbAdVwIAJjmjVz0h5OmZ
BN11IoBvEru3KvJAsSZeSL/oMse1Oss9KfO9cUgws+wP+vWlICr39P6OTsb49zii
T6fcZ46U9rdbLZbM3Dgweo5yshbZZbj9TZMkQjazuxRp2+SeXD0bx5fhJGoI4HPC
5IGQiCFR+Zvphe9Dv0o0ZH9DDlPPH/rgUC3JCjPC7AjBrzhrguw=
=VPzr
-----END PGP SIGNATURE-----

--4ehG9HxkuyoI6jtY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
