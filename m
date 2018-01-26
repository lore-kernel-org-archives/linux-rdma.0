From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Fri, 26 Jan 2018 08:24:23 +0200
Message-ID: <20180126062423.GV1393@mtr-leonro.local>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <20180125174529.GB3739@ziepe.ca>
 <20180125194436.GR1393@mtr-leonro.local>
 <20180125201023.GA9162@ziepe.ca>
 <20180125202710.GS1393@mtr-leonro.local>
 <20180125210026.GA10719@ziepe.ca>
 <20180125211831.GT1393@mtr-leonro.local>
 <20180125215716.GA11537@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IjzautVOrq+IorBk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125215716.GA11537-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--IjzautVOrq+IorBk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 25, 2018 at 02:57:16PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 25, 2018 at 11:18:31PM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 25, 2018 at 02:00:26PM -0700, Jason Gunthorpe wrote:
> > > On Thu, Jan 25, 2018 at 10:27:10PM +0200, Leon Romanovsky wrote:
> > > > On Thu, Jan 25, 2018 at 01:10:23PM -0700, Jason Gunthorpe wrote:
> > > > > On Thu, Jan 25, 2018 at 09:44:36PM +0200, Leon Romanovsky wrote:
> > > > > > > > +	/*
> > > > > > > > +	 * @kref: Protect destroy of the resource
> > > > > > > > +	 */
> > > > > > > > +	struct kref		kref;
> > > > > > >
> > > > > > > Sticking a kref in a random structure that is itself not malloc'd is a
> > > > > > > big red flag:
> > > > > >
> > > > > > It is not "rand", but embedded part of ib_qp,ib_pd and ib_cq. It is
> > > > > > malloced as part of their creation.
> > > > >
> > > > > I mean the kref isn't in any way linked the lifetime of the malloc
> > > > > that contains it. So it isn't really a kref, it is just a refcount.
> > > >
> > > > For now, yes, in the future no. IMHO it is the direction to manage RDMA
> > > > objects.
> > >
> > > Maybe but until we do that this doesn't have struct kref semantics at
> > > all and shouldn't be called kref..
> >
> > You are actually open-coded kref semantics with addition of completions.
>
> I generally don't like seeing 'complete()' as a kref release
> function. There have been very subtle problems with code trying that
> in the past..
>
> But yes, you can force things to work that way if very, very careful.
>
> I've often thought I'd like a helper type that had the kref+complete
> semantics, because that does seem to crop up in a few places and it
> would really help clarity.

Actually, it is used a lot, one of closest examples to us - qib sdma
kref counting.

Thanks

--IjzautVOrq+IorBk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpqyZcACgkQ5GN7iDZy
WKdLag/+OsM1bxx3Oz2GBp/B4b4B39UX86DXt0dVwVJ4aC/U5M9U2/DiI/HWLPkr
10u52WVyft44P1DzKvj/UWFNWGoH/m98YFcNWIyPtXSDhkXjqftHuf4goEIi4+Ga
n8OYcOYTHaxpRBjV7aB//aIGcnc344lcWAgR0SOyeNoYa+fWrmC03sDGd0zNWs/w
9z2Nz8ODy0+dX/UsZcRR7PisI8PWQC2VDUzPRPlJ3APBYGsWMSwMwLRcZMrCqgDb
PVR7nuCT7y2cSgAjhwzpG+lLHEq+45PcWzckA7YwZNBNvpIHPZJy4EVUmbvwP8yk
uF2AvPds7Kc9OrpDBqVnKtKirczAHIN/yeM+N/WWtNmcKAGOQPQ+MKlCrGpW6jkc
DGTyWPl1PMBi19hilmFIOamco4Lo3BV+peHG6kkcsVAKswvyuAVmu9LqkHdb4DIR
EoslIeQiNy31VwrZafIPsMvstjm+fd+3cOCa4eCrMTkd48/ZvD0pHVU8S798j7mh
T1Mu+GF3okqwUHhhYoKMYigo3sf8Z0GzkGEzGJwIw9yuG38My71pHsNRDPFetQBA
0BCOX8YGZHcFA7kQv03IiZhSAgDMJbwYLJFvu+Ybhsowf6jbNN3gRaCbvmX4kYUC
4VVqWiW9YM+fxm5emYBjpXs04CcPAu3yMcnZjmip1DAGyYjIoc0=
=Xw/2
-----END PGP SIGNATURE-----

--IjzautVOrq+IorBk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
