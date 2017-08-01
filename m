From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 18:13:03 +0300
Message-ID: <20170801151303.GN13672@mtr-leonro.local>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="smEuXhZLKnMjT4Ht"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--smEuXhZLKnMjT4Ht
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2017 at 09:22:47AM -0500, Christopher Lameter wrote:
> On Tue, 1 Aug 2017, Chien Tin Tung wrote:
>
> > Why do I need to explain the original patch?  It was accepted many kernels
> > ago.  Your questions on the original were based on false assumptions and
> > facts which I've proven over and over.  You are right in that I do
> > not want to revisit those either.  There is a patch that can solve
> > the problem you are facing but yet you insist on the revert.  This is
> > very puzzling to me.  You simply refuse to move this forward.  That
> > is your choice but revert is a no go for me.
>
> Ok this is pretty confusing to someone not involved in the prior
> discussions. Could both of your stop attacking each other and start
> talking about the technical issues?
>

Christopher,

I'm reverting the patch which made two things to RDMA netlink - It made
the netlink stack blocking, which shouldn't. And reinvented the wheel with
setting timeout on socket, instead of using proper and already exposed API.

I tried to explain it in commit message.

Chien sent patch which supposed to replace my revert, but both of his and
my patch wasn't accepted without any reason, so I proceed.

Thanks

--smEuXhZLKnMjT4Ht
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmAmn8ACgkQ5GN7iDZy
WKdw8w//YidLweaYH50u0CU57k/Hksz1Ez5i+b3ZQUTCetiNvdO5yvtRz1v4v5GE
FSEGcbd0amrTnVFVTPSfiV78xo4+Lnj3Dhj3QRyJUXjCW3qjJGkAA5Ihi2OnoY9u
9tzY1AzT4qARGIXA8BDc5OHpyZ9rpf2cP2vVPpoVg1D4VDrTUQBLJl/PJrKGsPEh
w07qFCRN+ItlbR/9kx+tKMQXAiYN/4M7evG8MsztjPakSa2WZVza7zowH2qxyVi2
cKTi4ZFadp7ZHrYUngXG97CxI4/WtVAV9fUBcwgdk2SRjDA6+9V4H4xwV96RId6/
olMrwR6iXgkAdEcwi5XY5Z5x5nv5aHT3OTxFYhVGxVXU6EBgwuufUos2YQdZXgKe
jhFJz0eQi8UpRtSVMLErbEw2Ntw7pJg0PumNpDEzeVjqnI4iVi/5zW/g1bcWt7le
0OGNgZLgenJcqQUbpJSSdVmTVNpGKe+EdktPxmIcWyZWkYPwZm+8hXH0rOvFjCmw
YMvC9R5IQ1vkvZII4hZuzyoKIMGvPE9V0Hg4PLt9Ne66VdqnhMcWHyW/3ZmQbuWH
4ycuVFi4S3NyniJXrw2zA4kRqL1T7QrzH8m6YoFB7r41J3tgW2foDb0R28QXpo/I
Dz+cJrRnZky2ReoU4P+l6PAJFVsDo6N9LNfgAXi9nQ6F6C4LnMM=
=HknG
-----END PGP SIGNATURE-----

--smEuXhZLKnMjT4Ht--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
