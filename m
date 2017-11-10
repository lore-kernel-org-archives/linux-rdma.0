From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Fri, 10 Nov 2017 22:24:55 +0200
Message-ID: <20171110202455.GP18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lhhpAkuygu+L0poz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54347E5A035A054EAE9D05927FB467F9B61778A9-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--lhhpAkuygu+L0poz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 10, 2017 at 06:36:28PM +0000, Davis, Arlin R wrote:
> > I agree there is a big need for that. Currently reviewing all the patches I haven't
> > read (only 1000 mails to go...) to see if they need to be backported on top on
> > rdma-core 15 for the next SLES.
> > I'd gladly help maintaining this as I'm spending time on it anyway.
> > I'll leave wiser people debate and ready a doc on how this should be done
> > though :)
> >
> > Nicolas
>
> Thanks Nicolas.
>
> Ok, I am not sure what details the rdma-core maintainers are looking for in a document. Let me start the discussion with the following:

More or less, you wrote everything that I expected, just need to post it
as a patch so I can apply it to rdma-core.

The thing which is important to me is how long that stable will be maintained and how often they will be opened,
I don't want to see 12 stable branches after 3 years of running rdma-core. It releases every 2-3 months, so theoretically
we can find ourselves creating stable branches after every release (4 per year).

Thanks

>
> Stable Branch Release
>
> Current Maintainer: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
>
> Upstream rdma-core is considered stable after each mainline release. Branched stable releases, off a mainline release, are on as-needed basis and limited to bug fixes. All bug fixes are to be backported from mainline and applied by stable branch maintainer. Branched stable releases will append an additional release number (e.g. 15.1) and will ensure that Travis CI reports a successful build.  Mention the frequency of stable releases or keep it "as is" cadence?
>
> See versioning.md for setting package version on a stable branch.
>
> Arlin
>
>
>

--lhhpAkuygu+L0poz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloGCxcACgkQ5GN7iDZy
WKcJ5g//W1UE5CyHg19KZ12CM44JPh7ty6Lc9glNWIQutJmwsxIxTP4Youn1olsc
OAIaw1pf7R6FnPTg4J4WGdmBEJRNZHFbqYx3fzibl1X8N9CbelluUE6B7VL1wJpk
nNqej4hRopcpeWVK3fAVKX1kolNfPjaQvCYXAZrwr9B4u+/g/Vm32IBzpNX/wyuK
MTF5cqQ4k9XhfMxuGHNE93SABAF9PtX5v1ff0wzcZvlCWVLDYbu7XPnz+5Wc64/z
VzasdEqOBz6i+gKn7xKAyuqrHRAZG9CJgFTf9ySJiywFKVoFDzOqpripQhavZLpz
HaNscKYvjDwKbPBl0Ic8ddnONegk4lEnkFxvk6BNIfkc6t5uqgiFx4HPfGhT9wqu
dAwDnY4eDVZABXZExv9/G773/dO/iZDxRn8ONyHfA//jA/sRGfEdrkmr/P/MA5AM
2QQcPX33nPPXesoR0Dvkla3y22QLSKeJ8WUxzXUOFY5ZeMZTufbpVdB3FpZTaCyQ
r0+S/4HS/R+z0Zd+x3MiU6wTGQb+x4irBgWW5XSHCv9vp0tL3kzhqkmw6rcJgEMb
9/KbgNuN/Rp6uLJJ4YikfCJbptGt/2hYVBbrRLgSkFTU1E+EGUhmILm2eM530ByJ
/GOyXJ/Fo6TWL9ZbvWlfoiN6dOXC3LhdK+ZBvyaR4ZUwVDD1NWc=
=pDBM
-----END PGP SIGNATURE-----

--lhhpAkuygu+L0poz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
