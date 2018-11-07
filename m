From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma] net/mlx5: Fix XRC SRQ umem valid bits
Date: Wed, 7 Nov 2018 09:34:34 +0200
Message-ID: <20181107073434.GJ9230@mtr-leonro.mtl.com>
References: <20181031102028.9142-1-leon@kernel.org>
 <cb4d41e3a24c667c5c4e0492d3d3b21a5a165919.camel@redhat.com>
 <20181106220206.GC30490@mellanox.com>
 <581ad7a59e00c7ee01a65940637df25ad826041c.camel@redhat.com>
 <20181106221153.GG30476@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181106221153.GG30476@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 06, 2018 at 03:11:53PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 06, 2018 at 05:10:53PM -0500, Doug Ledford wrote:
> > On Tue, 2018-11-06 at 22:02 +0000, Jason Gunthorpe wrote:
> > > On Tue, Nov 06, 2018 at 04:31:08PM -0500, Doug Ledford wrote:
> > > > On Wed, 2018-10-31 at 12:20 +0200, Leon Romanovsky wrote:
> > > > > From: Yishai Hadas <yishaih@mellanox.com>
> > > > >
> > > > > Adapt XRC SRQ to the latest HW specification with fixed definition
> > > > > around umem valid bits. The previous definition relied on a bit which
> > > > > was taken for other purposes in legacy FW.
> > > > >
> > > > > Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
> > > > > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > > > > Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> > > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > > > Hi Doug, Jason
> > > > >
> > > > > This commit fixes code sent in this merge window, so I'm not marking it
> > > > > with any rdma-rc/rdma-next. It will be better to be sent during this merge
> > > > > window if you have extra pull request to issue, or as a -rc material, if
> > > > > not.
> > > > >
> > > > > BTW, we didn't combine reserved fields, because our convention is to align such
> > > > > fields to 32 bits for better readability.
> > > > >
> > > > > Thanks
> > > >
> > > > This looks fine.  Let me know when it's in the mlx5-next tree to pull.
> > >
> > > It needs to go to -rc...
> > >
> > > This needs a mlx5-rc branch for this I guess?
> >
> > I don't think so.  As long as it's the first commit in mlx5-next, and
> > mlx5-next is 4.20-rc1 based, then pulling this commit into the -rc tree
> > will only pull the single commit.  Then when we pull into for-next for
> > the first time, we will get this in for-next too.  That seems best to
> > me.
>
> That works too, if Leon is fast :)

Thank you both for suggestion.

I did it.
99b77fef3c6c net/mlx5: Fix XRC SRQ umem valid bits

It is first commit and it is based on -rc1.

Thanks

>
> Jason

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb4pWKAAoJEORje4g2clinoLgP/0jT1T0w2y7U+ykUvKuVSsQh
40V+pODkaAdpVEow5Kwel9B/BtrjtKBRbkSbplXxTmIubqgR25DVHBPg8v55sMiN
YO8loRd5UGQtNV92tSRe+8BmFupIUHcYwNc2LmRHCTfIyIu7LR0dmip8XRFIVqjZ
kil9ISZrxIH9FdFpNF1Cw4rIbfSwjYS2i95M12Og/Pvve1InZGTyIhOaXGRDEqNu
CRHKn5MpIS1MQKz1o33O2DQD2pV9oGc0BVHc5GyCl0IJKj5Kk1yLD46zN0VGqHtm
y5qnCY3kPwLS3pMnAWPiXo3c0OQKgtNRSlMiKZW41AexZ6ifm4IkrNuYs2bRG2eg
wZ+BkgvycTSVpIDbrKNBYXVEMcdi8ybhkCcrTAt7jmPBkwadhVKKHqANxtsHyqS/
fZljtgZmZjhMH0Ww6FT75It3TP2O84itGDWMBBUOPB7qBCZ29Pne80zGUdMgEeiS
zEYtiJdqEhMBxcyH6vD+qCVWZ9JFXqG5XWK0XF6DtEt3vRNonZNytbAWk6XjaqkP
Dk/ciQpNpv8bMiM1nf3SZ13BoJdZlzkTWHTrJ+EX4yOEZF1be+ys7zQn4z/W502L
/xJTgwuRgK8HMO7A7RqywsWPt+YpyzsGf3MK/DCEi242wXppf4mU8+IS3kI1Ofnc
00tvT/hWb1EyowHuVlav
=4fY4
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
