From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Thu, 15 Dec 2016 22:19:17 +0200
Message-ID: <20161215201917.GL811@mtr-leonro.local>
References: <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
 <20161215064807.GB811@mtr-leonro.local>
 <20161215165420.GA3264@obsidianresearch.com>
 <20161215183537.GH811@mtr-leonro.local>
 <20161215185034.GB16552@obsidianresearch.com>
 <20161215191751.GJ811@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7E53@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="I4VOKWutKNZEOIPu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB10AC7E53-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--I4VOKWutKNZEOIPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 15, 2016 at 07:55:18PM +0000, Nikolova, Tatyana E wrote:
> Hi Leon,
>
> Please see inline.
>
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> > Sent: Thursday, December 15, 2016 1:18 PM
> > To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Cc: Nikolova, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> > rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
> > variable
> >
> > On Thu, Dec 15, 2016 at 11:50:34AM -0700, Jason Gunthorpe wrote:
> > > On Thu, Dec 15, 2016 at 08:35:37PM +0200, Leon Romanovsky wrote:
> > >
> > > > I had in mind much simplier infrastucture, just add pr_debug(..)
> > > > call and allow every provider to place in any place in their code.
> > >
> > > I think the bitmask thing has to be hoisted too.
> > >
> > > > My main point is that I want to see all ENV variables in one place.
> > >
> > > Why?
> >
> > There are two reasons:
> > 1. Easy to document and for curious users to spot all possible variables.
>
> [Tatyana Nikolova] Thank you for providing an example for the environment variables. IMO the malloc implementation brings unnecessary overhead in terms of memory and code.

It is in init phase and it will take the same amount of space as other
global varibles now. i40w will have one ENV entry now -> it will have
one field in that struct -> malloc will be the same.

>
> A text file containing all environment variables and updated every time a new environment variable is added sounds like a good idea to keep them in one place.

If it will be one place and won't requre from us to remind and remember
to update the same information in multiple places, I'm ok.

>
> > 2. It helps to potential authors to reuse variables instead of inventing their
> > own.
>
> [Tatyana Nikolova]
>
> Jason gave an example with " VERBS_PROVIDER_DEBUG=qp,ah,blah". Should all of the environment variables, enabling other features in rdma-core use a similar approach?

I think that Jason is over designing it, but it is better to ask him
about it.

>
> Current environment variables are provider specific. How are they going to be reused without renaming? Renaming may create issues with applications and scripts already using the existing ones.

#define NEW_VARIABLE OLD_VARIABLE

>
> > >
> > > I really don't want to see util/ files include provider headers, for
> > > instance, so I don't like your SET() macro idea..
> > >
> > > At this point I'd settle for having all ENV vars *documented* in one
> > > place :(
> >
> > See, reason #1 :)
> >
> > >
> > > Jason
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> > majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--I4VOKWutKNZEOIPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhS+sUACgkQ5GN7iDZy
WKcqgRAArtPlkcKyPsXG5pTeJcJNWi8O62xL5RxUIk8FveGeGLi9oGnwz7yhnJLC
+GkXqQydQBM8cq13xXBB/3MS/9Cbj94pA+R48GVFQ5raeQDS+NM/YIvx9lZpJvnx
BkBkJpfP+MYB+KoWeldqTpwx/a+0INHqAjJhWoIAcpxpn0fNpAXLVbFP/m/S1B8K
63TTWnrKTi+zzO7R2YnLnIwT6IJaTlovbYRpGTB+CeYwhBBJloTapvS2sZAKsvWw
88Vm4PCEj4NV5z89yufqYT4jMaaLfIC1A4wOl/gV92w2mvcfZm+OhZAtfjh8eDXK
fCVDXv5emjVK8UrUMris/KzDrq6yhbte2FwQCnIGTIqDQ2Js7C0DXwfiDExE1gMz
oHA6+8b+voCrPFvNEhtwskoskBPj5OOQ/cbStPPVRjxV8rIQjlCFmirUFk0MHiKP
EsUtFa5mfqbdzQujNFiL1wAhcQ/xQeZ5P0UOpym20x4YKcc4bD2+fq48XpftK+ih
2Dutjlb7xzvlghOuJjsYwFG+hhzutPpvtnFRo3wQmcPS1G8PRiK+TkKfLjKkprKi
rgACaVpkJs6ObfSbQZZHMXQNuWDkFujt801THqPfmgcKzuoQ3uq0hRuywKp7IyfF
BeOGSSMftqn9uScJDXBUlBLJzHhN8inKebVN0mzy5SFz/p//Npw=
=5baJ
-----END PGP SIGNATURE-----

--I4VOKWutKNZEOIPu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
