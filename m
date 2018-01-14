From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Sun, 14 Jan 2018 09:20:53 +0200
Message-ID: <20180114072053.GR15760@mtr-leonro.local>
References: <20180112055842.23125-1-leon@kernel.org>
 <20180112170228.GD15974@ziepe.ca>
 <20180112183958.GP15760@mtr-leonro.local>
 <20180113191806.GD32353@ziepe.ca>
 <20180113201118.GQ15760@mtr-leonro.local>
 <20180113204609.GE32353@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kERJ49nCKmnv470N"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180113204609.GE32353-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--kERJ49nCKmnv470N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 13, 2018 at 01:46:09PM -0700, Jason Gunthorpe wrote:
> On Sat, Jan 13, 2018 at 10:11:18PM +0200, Leon Romanovsky wrote:
>
> > > > The rationale behind it that it so basic change so it worth to have in
> > > > stable. Also, it goes as all our countless fixes to those two series:
> > > > Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
> > > > Fixes: 7db20ecd1d97 ("IB/core: Change wc.slid from 16 to 32 bits")
> > >
> > > Nevertheless, the commit message does not explain to me or Linus why
> > > this is *important* - it does not talk about what user visible
> > > consequnce there is to this bug.
> >
> > I'm a little bit confused here, when I submitted Fixes to -next, you
> > asked from em to send such patches to -rc and now you are asking to send
> > Fixes to -next.
>
> I never ment that every patch with a Fixes: should go to -rc, I mean
> that 'fixes' (lower case) suitable for -rc should go to -rc and not
> -next.
>
> And I've always ment that patches going to -rc need to have clear
> commit messages that explain to Linus why they are worthy of -rc.
>
> This is to help the overall broader community to ensure that patches
> we deem important are made more visible and not just dumped into
> for-next.
>
> It is not just Linus asking for this. The distros *need* quality
> commit messages to manage their own backporting activities.
>
> > It will be better if you and Doug have more clear definition for -rc
> > than LOC count and gut feelings.
>
> Well, show me a guideline from Linus and we can follow it..  Linus has
> some standard that is sort of deliberaly nebulous and we have to try
> to follow it. I've already outlined my detailed thinking in a recent
> email.
>
> Linus is clearly concerned about the risk of introducing regressions
> as the rc cycle moves along, so the commit message needs to explain
> the benifit of the fix as worth taking a regression risk.
>
> So again, back to 'RDMA/core: Fix avoid decoding iWarp port as
> RoCE'. Looking at the actual patch now.. To a casual reader
> it changes iwarp's RDMA_AH_ATTR_TYPE_ROCE to RDMA_AH_ATTR_TYPE_IB.
>
> Why don't we have a RDMA_AH_ATTR_TYPE_IWARP? Apparently because iWarp
> doesn't use struct rdma_ah_attr at all!
>
> So the proposed patch apparently *does nothing* - that is clearly not
> acceptable to for-rc at any point, and it certainly isn't worthy of
> -stable. (so unless I hear a better explanation the -stable tag will
> be dropped too)
>
> Maybe I'm wrong, but the commit message *DOES NOT EXPLAIN*.
>
> > For example, Dave took this series for -rc7/8, because it fixes the code
> > and don't add new features.
> > https://www.spinics.net/lists/netdev/msg477875.html
>
> And Linus gives netdev more latitude than he gives rdma, so you cannot
> use what DaveM accepts as a guideline for what we should accept. In
> practice that means rdma gets more selective as the rc cycle moves on
> and maybe netdev doesn't.
>
> For instance, I think Linus would be angry with RDMA if we sent
> something like 'net/mlx5e: Add error print in ETS init' to -rc8.


Ok, let's close this discussion.

I learnt from it three things:

1. I'll submit all my fixes to -next, and you are free to decide by
yourself how to sort them. I don't want to waste my time on trying to juggle
patches between various branches and do postdoc on every patch, in
order to understand how Linus will feel about it. Currently, my decision is
really simple - bug/not bug, and I don't see any reason to complicate it.

2. This kernel release will be DOA for me without patch
"RDMA/mlx5: Fix out-of-bound access while querying AH".

3. -stable tag is a perfect example of cargo cult in RDMA community.
There are number of ways how patches are landed in stable trees
and stable@... just expedite things [1].

Thanks

[1] https://lwn.net/Articles/701304/

>
> Jason

--kERJ49nCKmnv470N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpbBNQACgkQ5GN7iDZy
WKekchAAvBY1iVpSGcBIUSAE/LmoP0pNeCQi9vRPHPJ2cjaB5ROv1CdmzmYhqvic
ybbjQmZOE7uekbwuh2EZK9VUlSHDVBOmF7Uq1yolAXKiZJbukgoc9g9XDJe2wrJ3
9P2C+y3qrjnoKS+y0fg019+PH/Cbggf2l3bpLjM3HZHVvyYSjo9Q1Dd5YDJWNRJS
R1NFlWxStSZfS0Q3leWbGl2SJY1+Vog8mKIG0SLjlloHl2N3uRcg3tnYs/hcFuw7
/WITXIVcJRIkPVnbUUCzeA/dHVolrNr/Psc5Lc/mohTrZX5sEpbVS+SU3C0ndPid
tiM9+HbldzhDQkD1utqnUprReAEgGH4A8zit7Y8GDhf7s9AoAh/HCiE2hjqrTVNH
GoKF598oubrxt5CpzUbOsMN6A9YQTolEWGuDt7M/ArWPJMx7zAcRCizngK0di/A6
xptj/X/uLyVzClcekuYMr//6a7NCYQFCKCgOPa4fW2BiiVJRBMFcJKDUsz13ffL9
Pc3IxR/oJhyIG5a2udsjW3gLfcP4C0pAetMKzScDd4mytkbBxkl8NG6OJsFNH4hP
/HDMlQnk4doPMK66UtkzJzbo0Nko1LsUIFS1wgHtQQmC1PhnJCTD3xHP8ZUXggSQ
yC8gdCL0KWLyGHAj0yfi7Vx/uZOj4VgzrNcDUsMqsCyS8jQwQ+I=
=rK9g
-----END PGP SIGNATURE-----

--kERJ49nCKmnv470N--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
