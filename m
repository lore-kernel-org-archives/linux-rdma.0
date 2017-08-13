From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Flush warning
Date: Sun, 13 Aug 2017 13:33:59 +0300
Message-ID: <20170813103359.GW24282@mtr-leonro.local>
References: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com>
 <9bc142de-b8ba-acb6-5ea1-2ccdbb578655@grimberg.me>
 <003401d30f91$c7e2a3f0$57a7ebd0$@opengridcomputing.com>
 <00ff01d3112b$94142350$bc3c69f0$@opengridcomputing.com>
 <20170809162749.GA4069@obsidianresearch.com>
 <011601d3112d$fa305b70$ee911250$@opengridcomputing.com>
 <20170813064651.GR24282@mtr-leonro.local>
 <90ada4f5-d6a1-2b93-5164-c593955c20cf@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZaW/dtY/7oMe/vLp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <90ada4f5-d6a1-2b93-5164-c593955c20cf-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZaW/dtY/7oMe/vLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 13, 2017 at 02:14:58AM -0700, Sagi Grimberg wrote:
>
> > > > > Does anyone else know?
> > > >
> > > > Consider that the ib_core can be used to back storage. Ie consider a
> > > > situation where iSER/NFS/SRP needs to reconnect to respond to kernel
> > > > paging/reclaim.
> > > >
> > > > On the surface it seems reasonable to me that these are on a reclaim
> > > > path?
>
> I'm pretty sure that ULP connect will trigger memory allocations, which
> will fail under memory pressure... Maybe I'm missing something.
>
> > > hmm.  That seems reasonable.  Then I would think the nvme_rdma would =
also need
> > > to be using a reclaim workqueue.
> > >
> > > Sagi, Do you think I should add a private workqueue with WQ_MEM_RECLA=
IM to
> > > nvme_rdma vs using the system_wq?  nvme/target probably needs one als=
o...
>
> I'm not sure, being unable to flush system workqueue from CM context is
> somewhat limiting... We could use a private workqueue for nvmet
> teardowns but I'm not sure we want to do that.
>
> > The workqueue which frees the memory and doesn't allocate memory during=
 execution
> > is supposed to be marked as WQ_MEM_RECLAIM. This flag will cause to pri=
ority increase
> > for such workqueue during low memory conditions.
>
> Which to my understanding means that CM workqueue should not use it as
> on each CM connect, by definition the ULP allocates memory (qp, cq etc).

=46rom my understanding too.
That workqueue was introduced in 2005, in a977049dacde
("[PATCH] IB: Add the kernel CM implementation"), it is not clear if it
was intentionally.

Hal,
do you remember the rationale there?


Thanks

--ZaW/dtY/7oMe/vLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmQKxcACgkQ5GN7iDZy
WKciPw/8C9Dz/aycC6i/BjUytYN5yvB4LhQ+Oa0lkRO7W26PhYqCNZXk4YvLack9
EdDBMs4/usyO2zB/m2C5aMm3RUESbo7evCkIw7tY4cGXNfxvihJoAid0uT7Df0Y+
8LPx5gG5Ts/saachxzyk/pHo4lyzpF5mCqz8bLih4MsM0e89JUniFUnDrUqtJ3ao
W/nNpC7b1ocNQVfHjcf1FkAPKS96aDzMz4bc3yZ2upZ5Ko8HhIZNU572p4pbaoYq
wYkwKhudXaaSJYPP+fRc4X45h6lZdUjA7Cj2AsfcphDM8keOs1Dyyn0B6z1XKP87
4BRjUPuWzrtMsFf5R+oXI4eS2ho6CEVLcm2i7aADqdUd0pxBRbY4ZAHh9d59RGqI
kcI3kWV1pXFHs8Scs8MROfrEA6QIDit6LvTzANXnHRkQkmRhQgJa+ZytsjybrZ5l
78XWbzdet1bZcSjJyTEGr2KyT9+ZrjacdNQBHkjOJhR8yPPK/JxPtvlkez6jRM7k
nNiUReRjaJrrfHGoeRB4G+y4N+fAxn7HEjBeI9LV9+PsEIPJJw7yfVbetRyX3yyD
6h6unC31DKm9hQpc1xdXDlP/2J4ZTKy4yrNt/91cW+sYzcphoM6zlNh9jfME/kbv
FfpXxbR1TkYWC2xCq62hvd80enNBDEDJwwYFLZ71HazlXv1geQU=
=hSl9
-----END PGP SIGNATURE-----

--ZaW/dtY/7oMe/vLp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
