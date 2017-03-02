From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Thu, 2 Mar 2017 15:22:58 +0200
Message-ID: <20170302132258.GC9525@mtr-leonro.local>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170301001023.GA3001@phlsvsds.ph.intel.com>
 <CAFgAxU_i+5FtBkdf=t5vdQAvBqDt9aKsFJbAKGN5YWQQ9w-c2A@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E67C5CA68@CRSMSX101.amr.corp.intel.com>
 <20170301230743.GC2820@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301230743.GC2820-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 01, 2017 at 04:07:43PM -0700, Jason Gunthorpe wrote:
> On Wed, Mar 01, 2017 at 10:15:31PM +0000, Weiny, Ira wrote:
> > > On the call we discussed that today there is no 'incarnation'
> > > value exposed for the uverbs%.  You suggested an optimization by
> > > using the cdev's file creation timestamp as option for libibverbs
> > > to understand that the driver did or did-not restart since mapping
> > > of that ibv_device.
>
> Not the cdev, read the timestamp from /sys/class/infiniband/mlx4_0/hca_type
>
> > > Main pitfalls with this is if system time is being modified (admin
> > > or ntp/ptp). In the rare case that we have a hoplug event and time
> > > is rewinded we can accidentally reach a very hard debugging
> > > exercise.
>
> You are only using it for direct equality comparision, so someone
> would have to roll back the clock and hotplug the driver at the exact
> same nano-second resolution timestamp. That is deeply unlikely to ever
> happen by accident.

Jason,

I think that we are over engineering here, but it can occur with NTP clock hopping.

Thanks

>
> Jason

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli4HLIACgkQ5GN7iDZy
WKexpRAAjwarY3GE97WLiu341MZjm4SR3UTyHC3IbC1TyEl7O8JS/g7eDfOwmFUl
BolIZ10omkQbgJvbzygV9i7L0q+bRz7Hc7Trmyn4Or6U8FTAEXkK/F6qbvxh4wwB
wAew+U6CxnwfOfgdw4GQzVqZFNEDJjs0Lo6ZP8PxJc1Za0itKQOdiq6QS/cXu5BN
KfBeyQATJNXTfn8TaF8/NGh+u60Lk4tzzpIgDs3jr6/KnUGPTybqdhidQk2mleCg
1zrkd1cTgayXderxvVCVyNwA29QcBE0JBvkCaoLs0pnbkX+xmXiUcM5wXVlzCz8I
sXviPJwLh0p2lux/rdrDh/VSG8VXn/kqOQ0k/T7sH3ofwVfWubFCFieCLsNRo1cE
iWnLbI+c8YYKcttni2kSBrq469HfeAGq5i7+yw0s6wGwMQn2qxJmM7OSQUgIn2mo
g71w+p3/3rBR//QyxUD3PUw473iovHguTKzl3RuXc4iUJEHZGPMxqMvtL3vOyBZv
66tYc4CHEYpb9QRMjQuwPhLqhAewzH33yo5u/BLDHAHv2cRp/C3/owJzf9HVcfLh
UtpZGYq52ru9Ng2Rk8hWhW2WPyaHsTukV3THGQvsQW/JwEy7xB8SGss50fH6djC+
LxBo8jZpdeTgweqyJHerydfhUd62etplflt0L0EcFRtGO/i0bNA=
=waBK
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
