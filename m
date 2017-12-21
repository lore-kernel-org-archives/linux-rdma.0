From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 4/4] RDMA/vmw_pvrdma: Remove usage of BIT() from
 UAPI header
Date: Thu, 21 Dec 2017 19:17:24 +0200
Message-ID: <20171221171724.GJ2942@mtr-leonro.local>
References: <20171220192305.GA28403@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171220192721.GA32622@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171221130034.GH2942@mtr-leonro.local>
 <20171221163433.GD20015@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hW3Q5Oh0pcvvyJMS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221163433.GD20015-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hW3Q5Oh0pcvvyJMS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 21, 2017 at 09:34:33AM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 21, 2017 at 03:00:34PM +0200, Leon Romanovsky wrote:
> > On Wed, Dec 20, 2017 at 11:27:28AM -0800, Bryan Tan wrote:
> > > BIT() should not be used in the UAPI header. Remove it.
> > >
> > > Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > >  include/uapi/rdma/vmw_pvrdma-abi.h | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > IMHO, it should go to -rc.
> > Doug, Jason?
>
> I can't decide if any of the -abi.h changes should be for-rc material
> or not..
>
> The BIT() issue is being worked around in userspace today, so this
> seems even less for-rc'y?
>
> I'm leaning toward 'not' as we can and do cherry pick a for-next
> uapi header into rdma-core, so there isn't really an actual reason to
> put changes to those headers into for-rc?
>
> Thoughts?

I think that UAPI should be fixed immediately without any relation to
number of users (in our case one), but simple include of that -abi.h
will cause to application breakage.

Thanks

>
> Jason

--hW3Q5Oh0pcvvyJMS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo77KQACgkQ5GN7iDZy
WKeH1g//b4KuYyuCmnVKt2QxjW6hI9nPHKmeE3MZjjmt/fCsgl4etvP2teTwJUcw
XxTEWef2sQNzSldO5j/aJPCDGl2Q1Cvzvf9x2qXv0WblTFDxZunuX8vy+JPcOspb
8pqgzDkXurG6hFi2wLe5amyTFbex12Ydt5fXqpk98YYUotSjMGKjmInLkqvRlQG5
6QQYopJIF0I1K4XLfiwKtCDSmBx0NGaE1226lRuKbglxYqPvPRDtJ0RGnlPiawyJ
rax3W3QFqF//VIuIlpUcKFsg8vdMrLmjaVFUBWdUhQ+H7mwrIljM1xxmivFK2aZS
8sRfElT3glvAydMjMqkvyiSLNuPQsm2Cex0AIRSygbyyUu2TBaqFUMyRyVnX1E0f
IdBeq8J1DJtZKGcOdoqNeLKwtd8pe3gVskY+Yb2oZzowTAsVeYqlhC8lzEps1+TE
lGHQd04uVfkTd3NMdz7ZSMMVWnJ3a4bSsOUGDEmTtp0JOYDorv6dPgLjNeRf+x6j
kdzBsVPoadQ5enA8AfWZynVAhniIoUGXtow7Epl+rCt7VtzfYqnhPHwyfxzHMvyd
QU6Ut3hz2AKWmfG2NiAhlFEzj4oJHhL0i2UTqySSJJH1+k+sC/EtMVOWc9dYMqha
iU67/xRi2cRTBrNUGtFnYNuEodeDWEBPB7XT0/RlMjqWHq/A2j0=
=ojPR
-----END PGP SIGNATURE-----

--hW3Q5Oh0pcvvyJMS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
