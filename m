From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-rc 4/6] RDMA/bnxt_re: Synchronize destroy_qp with
 poll_cq
Date: Fri, 16 Feb 2018 17:51:46 +0200
Message-ID: <20180216155146.GN2197@mtr-leonro.local>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
 <1518758413-20850-5-git-send-email-selvin.xavier@broadcom.com>
 <20180216073802.GM2197@mtr-leonro.local>
 <CA+sbYW1=9G1YHDZQyCKeTfus9FLd-w7FZzHFUnCCPALB3ciw_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="95puKF9o0QNvO5PE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW1=9G1YHDZQyCKeTfus9FLd-w7FZzHFUnCCPALB3ciw_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--95puKF9o0QNvO5PE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 16, 2018 at 05:09:15PM +0530, Selvin Xavier wrote:
> On Fri, Feb 16, 2018 at 1:08 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Thu, Feb 15, 2018 at 09:20:11PM -0800, Selvin Xavier wrote:
> >> Avoid system crash when destroy_qp is invoked while
> >> the driver is processing the poll_cq. Synchronize these
> >> functions using the cq_lock.
> >>
> >> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 39 +++++++++++++++++++++++++++++---
> >>  drivers/infiniband/hw/bnxt_re/ib_verbs.h |  2 ++
> >>  drivers/infiniband/hw/bnxt_re/qplib_fp.c | 21 +++++------------
> >>  drivers/infiniband/hw/bnxt_re/qplib_fp.h |  4 +++-
> >>  4 files changed, 47 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> index b7eb104..9cb9928 100644
> >> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> @@ -786,20 +786,51 @@ int bnxt_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
> >>       return 0;
> >>  }
> >>
> >> +static unsigned long bnxt_re_lock_cqs(struct bnxt_re_qp *qp)
> >> +     __acquires(&qp->scq->cq_lock) __acquires(&qp->rcq->cq_lock)
> >> +{
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&qp->scq->cq_lock, flags);
> >> +     if (qp->rcq != qp->scq)
> >> +             spin_lock(&qp->rcq->cq_lock);
> >> +     else
> >> +             __acquire(&qp->rcq->cq_lock);
> >
> > Sorry for naive question, why do you need __acquire/__release? And why
> > can't spin_is_locked(&qp->rcq->cq_lock) be used for unlock code?
> >
> I used __acquire and __release for satisfying the sparse. Sparse used to
> give warnings  "context  imbalance - wrong count at exit" since the locking
> and unlocking happens from two different functions. seen similar implementation
> in other drivers too.

I see, actually I think that sparse complain was right and you went to
far by wrapping standard calls. I see that it is very popular in bnxt_re
code and the problem with that, that it makes very hard to refactor such
code in case of some global change/improvement.

>
> I feel spin_is_locked also can be used.. but it doesn't avoid the RCQ
> != SCQ check.
> Also, if feel the code symmetry is better in this way.
> >
> >> +
> >> +     return flags;
> >> +}
> >> +
> >> +static void bnxt_re_unlock_cqs(struct bnxt_re_qp *qp,
> >> +                            unsigned long flags)
> >> +     __releases(&qp->scq->cq_lock) __releases(&qp->rcq->cq_lock)
> >> +{
> >> +     if (qp->rcq != qp->scq)
> >> +             spin_unlock(&qp->rcq->cq_lock);
> >> +     else
> >> +             __release(&qp->rcq->cq_lock);
> >> +     spin_unlock_irqrestore(&qp->scq->cq_lock, flags);
> >> +}
> >> +
> >
> > Thanks

--95puKF9o0QNvO5PE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqG/hIACgkQ5GN7iDZy
WKfaEQ/+O5ubGTlCEK0YqU7Tq4plxVcZlJkVFCTWLdZ6JZK6z6uMS4yCAHvS4gxa
aU28QaZ8lh8UObBOfnugN+51rq0LIBlZr6DRC7fkCHfAtUy+eweDSQQ7v74u0igA
fMl8/Havplkj52vrBBjsXFE8NWaWQFuT+99uZuAPfRNG94ErYNGfOG6CshhX7/oT
IPM9v77qFH5x0xd6FgNcjZfEyIB1KpfhnHEuWp5hmz6XwiokblwuQIQPMZJxENwy
PNTLCaGSH6+d2L3NS7Gxw5cMJ3OYmbwT0blwY1F9QMQfexPdIvzjfTQswF7dtUg0
X4GSRVYCo7Hbzqt3JGBvGcwG1iXtH1xZf6sHHkxZSGWlasvq7fCA0PvMmCHYyvct
thcc9ypr3zdyCD5dPIczCGVPNkLHO8DstVkt/Q1X9IaiOVTGWCugZ9ybludtFJW7
eWm2pUEgz83CSBIB1JEAUx2wjb819LYMgxCFyCXwayWXXJI/SwZnKy3cNILOPxrV
okO1WflyBs5CABPmroxBFElPkhZlAjGC6DnZ+PVcJSn+YIP/Z7MFLsnKP7OQ9QE6
IkCEWn/Y4J5gymX42CG0M/xoTTCN6knDV2Awy05CE24e400OHoZe7VqFyFDetG5f
0YBfUmZIMiHa5JFIAo0+2lNa31ZnFXI2Vd+TldYdeHMdmGHEs9w=
=/iAP
-----END PGP SIGNATURE-----

--95puKF9o0QNvO5PE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
