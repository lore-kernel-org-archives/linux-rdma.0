From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Flush warning
Date: Sun, 13 Aug 2017 09:46:51 +0300
Message-ID: <20170813064651.GR24282@mtr-leonro.local>
References: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com>
 <9bc142de-b8ba-acb6-5ea1-2ccdbb578655@grimberg.me>
 <003401d30f91$c7e2a3f0$57a7ebd0$@opengridcomputing.com>
 <00ff01d3112b$94142350$bc3c69f0$@opengridcomputing.com>
 <20170809162749.GA4069@obsidianresearch.com>
 <011601d3112d$fa305b70$ee911250$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5FetH82qe0Z6y/zI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <011601d3112d$fa305b70$ee911250$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5FetH82qe0Z6y/zI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2017 at 11:38:49AM -0500, Steve Wise wrote:
> > On Wed, Aug 09, 2017 at 11:21:38AM -0500, Steve Wise wrote:
> >
> > > > I don't know.  I read the workqueue doc on WQ_MEM_RECLAIM, but I don't
> > know
> > > > how
> > > > to tell if iw_cm needs this or not.  Can you give me an example of a
> workqueue
> > > > that _does_ need WQ_MEM_RECLAIM?  I _think_ it means your workqueue is
> > > > required
> > > > to run something that would get triggered by the oom OS code, but I don't
> know
> > > > if that would include rdma CMs or not...
> > >
> > > Many of the workqueues in infiniband/core use WQ_MEM_RECLAIM: cma, iwcm,
> > mad,
> > > multicast, sa_query, and ucma.
> > >
> > > Hey Sean, do you have any insight into whether the CMA modules really need
> > > WQ_MEM_RECLAIM for their workqueues?
> > >
> > > Does anyone else know?
> >
> > Consider that the ib_core can be used to back storage. Ie consider a
> > situation where iSER/NFS/SRP needs to reconnect to respond to kernel
> > paging/reclaim.
> >
> > On the surface it seems reasonable to me that these are on a reclaim
> > path?
> >
> > Jason
>
> hmm.  That seems reasonable.  Then I would think the nvme_rdma would also need
> to be using a reclaim workqueue.
>
> Sagi, Do you think I should add a private workqueue with WQ_MEM_RECLAIM to
> nvme_rdma vs using the system_wq?  nvme/target probably needs one also...

The workqueue which frees the memory and doesn't allocate memory during execution
is supposed to be marked as WQ_MEM_RECLAIM. This flag will cause to priority increase
for such workqueue during low memory conditions.

I don't remember it for sure, but I think that shrinker will call to
such workqueue in these conditions. In normal conditions, it won't
change a lot.

Thanks

>
> Steve.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--5FetH82qe0Z6y/zI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmP9dsACgkQ5GN7iDZy
WKcoxxAAzMWxrw4CoIUvF/7w3joFU4j+mzO/E0X6A9ZjVdMudfo1ookTm40zg2IP
Iq9rjtr56erpsi/8wjN5Th8OPAcASHhZ621jFKjODfUGwFXFlNPvW7LAruxPA4w6
BNl5TMmjdCdZlAwJAwF7/Co3t/rAkZgmsu5+2W2QWxji6akBLlymMXQP8sN+YxRz
mH8QEgqPvihXUWqxetlRKghlUpIbP87hBAAZRHxF7xe46tMDVQowPhGU8TfuTojv
UI2JrH9C6rdJ9TijR95Ct4uiZTiyvWBeQJyN9zN7jcv+HflPoMsHsGXDEExKfgdx
mhMjnZFJ6GmOO2In9JK/eQx1PGObRCxLT+HIiDntRRT1R3lvLNIX+86lsLgKLkXU
2q0HT9HBpsmZ/7kPBnJYx+ddKr/oHByqananoiGrgDMQZP//Db31+vKrLjBzmpql
KdxTIpmDB2L4gyojQaMj6CIhUOy1ipLE8aL12HIIgqn6a1q0IRmmcCJ1uLXE6R2j
kGRMAKB/jZF+m6yrCKHBDJ+/j4DFxqYpSJvBF2m/VlGPZuogH2ZcqGAQtHwUzpoJ
YdhWgWsGAWNwds4XGRKPmJrYTfyXiKGMdY0CHf9zXK1bact3ruf9x82ZC+u2nYNw
odD9ksHo21QieAdB2Dpc/mIvC+/kIrTW29SoFJE8u2W287qVyDo=
=eF5E
-----END PGP SIGNATURE-----

--5FetH82qe0Z6y/zI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
