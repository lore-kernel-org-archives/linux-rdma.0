From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] nvmet-rdma: SRQ per completion vector
Date: Sat, 18 Nov 2017 16:40:42 +0200
Message-ID: <20171118144042.GU18825@mtr-leonro.local>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
 <263c6c9d-0dd2-da4f-12a9-efefd361e592@grimberg.me>
 <a8e2be0b-deb7-8cc1-92ce-fc5dea3e241a@mellanox.com>
 <20171118125229.GT18825@mtr-leonro.local>
 <935af437-d69e-e258-c00a-8bf9a04f9988@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FaN7meinlZJ33acO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <935af437-d69e-e258-c00a-8bf9a04f9988-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FaN7meinlZJ33acO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 18, 2017 at 03:57:15PM +0200, Max Gurtovoy wrote:
>
>
> On 11/18/2017 2:52 PM, Leon Romanovsky wrote:
> > On Fri, Nov 17, 2017 at 09:32:42PM +0200, Max Gurtovoy wrote:
> > >
> > >
> > > On 11/16/2017 8:36 PM, Sagi Grimberg wrote:
> > > >
> > > > > Since there is an active discussion regarding the CQ pool
> > > > > architecture, I decided to push
> > > > > this feature (maybe it can be pushed before CQ pool).
> > > > >
> > > > > This is a new feature for NVMEoF RDMA target,
> > > >
> > > > Any chance having this for the rest? isert, srpt, svcrdma?
> > > >
> > >
> > > We can implement it for isert, but I think it's better to see how the CQ
> > > pool will be defined first.
> > > It can bring a big benefit and improvement for ib_srpt (similar to NVMEoF
> > > target) but I'm not sure if I can commit for that one soon..
> >
> > Too bad, but I don't see inclusion of generic SRQ pool code in RDMA
> > subsystem without actual conversion of existing ULP clients.
> >
> > Thanks
> >
>
> This patchset adds this feature to NVMEoF target so actually there are ULPs
> that use it. Same issue we have with mr_pool that only RDMA rw.c use it (Now
> we're adding it to NVMEoF initiators too - in review).

The difference between your code and mr_pool is that mr_pool is part of
RDMA/core and in use by RDMA/core (rw.c), which in use by all ULPs.

However if you insist, we can remove EXPORT_SYMBOL from mr_pool
implementation, because of being part of RDMA/core and it blows
symbols map without need. Should I?

In your case, you are proposing generic interface, which supposed to be
good fit for all ULPs but without those ULPs.

> I can add srq_pool to iSER target code but I don't want to re-write it again
> in few weeks, when the CQ pool will be added.

So, please finalize interface in RFC stage and once you are ready, proceed to
the actual patches.

> Regarding other ULPs, we don't have a testing environment for them so I
> prefer not to commit on their implementation in the near future.

You are not expected to have all testing environment, it is their (ULPs
maintainers) responsibility to test your conversion, because you are
doing conversion to generic interface.

>
> I don't know why we can't add this feature "as is".
> Other ULPs maintainers might use it once it will be pushed.

Sorry, but it is not how kernel development process works.
"You propose -> you do" and not "You propose -> they do".

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--FaN7meinlZJ33acO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloQRmoACgkQ5GN7iDZy
WKfs1hAApZoeISeRFbcKqFWqk8Tfl1zneZGVbchtKB19nOxPgvZb8TPD1a4B2kX/
ruWktIzX1YK6b+6L7jTNTfbZHGxcfTMFHfiACfRQGuiotxkyJNa3wMxkUVPLJBCD
5iKnU+UbC1pYBDe7/N0re7k/6DU6RfAWTD4c8EVpLdrJ9nOshYGrd1A+7NjbFEi0
fjsrBJfVyHfA5+Fbd7Lth2SatwVFOnx6YgKSIGwPbBA3fA4NufqwtH44yMCrPxuT
LK9+ijN3An4xZx+k4OUswdVodFxJ+ucK+o+8efTcdtvw9al4ctA9FXY4AdIMFy2U
qhbUJZ+vvGSbtkjZG+xDQSEgkKSNVTQqRS2Gw98+p+PPYSs6ZjBC++DLCtFUqatF
cEu00a/fn/+bvSVhJoCoa2FfYyQqawXE15f8EsUCREzvs4U4pQjH4zLl7Mysf8Tr
I9qYySBC/R6qS86IhkWXFCFZ7mCU98au20DlF+P2J4hSc0WuBqrwjNAr02Fpo4tl
tXRwizEkfkK+alrMGSC2xGBgbUfXU/aB1ueBYXiDUZTHWFV6VaQtuKopqoPXJZsm
CBLKISo3UFyKHg8iTC4TosWJWn5nl68cpZWyDLEAF/V8Y+T+yLWxlHrLB/QNxMf7
xu0yISmD+hf+7tNqvG0nz0cgEiodW88PRVtaNGdn4OmdBBB/sos=
=mcFd
-----END PGP SIGNATURE-----

--FaN7meinlZJ33acO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
