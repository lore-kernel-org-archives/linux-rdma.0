From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-core v3 5/9] libbnxt_re: Allow apps to poll for flushed
 completions
Date: Sun, 19 Mar 2017 10:12:58 +0200
Message-ID: <20170319081258.GR2079@mtr-leonro.local>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
 <1489574253-20300-6-git-send-email-devesh.sharma@broadcom.com>
 <20170315192028.GI2079@mtr-leonro.local>
 <CANjDDBgPrPPDBOy9N4X=XdU9AUTFpL2pE9-9kPvqAcYj09vDLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2IUIi54rL+LZyXu+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBgPrPPDBOy9N4X=XdU9AUTFpL2pE9-9kPvqAcYj09vDLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2IUIi54rL+LZyXu+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 16, 2017 at 08:52:27PM +0530, Devesh Sharma wrote:
> On Thu, Mar 16, 2017 at 12:50 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed, Mar 15, 2017 at 06:37:29AM -0400, Devesh Sharma wrote:
> >> This patch adds support for reporting flush completions.
> >> following is the overview of the algorithm used.
> >>
> >> Step-1: Poll a completion from h/w CQ.
> >> Step-2: check the status, if it is error goto step3 else report
> >>         completion to user based on the con_idx reported.
> >> Step-3: Report the completion with actual error to consumer, and
> >>         without bothering about the con_idx reported in the
> >>         completion do following:
> >>         3a. Add this QP to the CQ flush list if it was not there
> >>             already. If this is req-error, add the QP to send-flush
> >>             list, else add it to recv-flush-list.
> >>         3b. Change QP-soft-state to ERROR if it was not in error
> >>             already.
> >>
> >> Step-4: If next CQE is TERM CQE, extract this CQE. make sure this CQE
> >>         is not reported to the consumer. Do the following steps as
> >>         further processing:
> >>         4a. Add this QP to both send-flush-list and recv-flush-list
> >>             if QP is absent from any of the flush lists.
> >>         4b. Change QP-soft-state to ERROR if it was not in error
> >>             already.
> >> Step5: Continue polling from both h/w CQ and flush-lists until
> >>        all the queues are empty.
> >>
> >> The QP is removed from the flush list during destroy-qp.
> >>
> >> Further, it adds network to host format conversion on
> >> the received immediate data.
> >>
> >> This patch also takes care of Hardware specific requirement
> >> to skip reporting h/w flush error CQEs to consumer but ring
> >> the CQ-DB for them.
> >>
> >> v1->v2
> >>  -- Used ccan/list.h instead.
> >>
> >> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  providers/bnxt_re/flush.h  |  85 ++++++++++++++++
> >>  providers/bnxt_re/main.c   |   5 +
> >>  providers/bnxt_re/main.h   |   6 ++
> >>  providers/bnxt_re/memory.h |   5 +
> >>  providers/bnxt_re/verbs.c  | 243 ++++++++++++++++++++++++++++++++++++++++-----
> >>  5 files changed, 320 insertions(+), 24 deletions(-)
> >>  create mode 100644 providers/bnxt_re/flush.h
> >>
> >> diff --git a/providers/bnxt_re/flush.h b/providers/bnxt_re/flush.h
> >> new file mode 100644
> >> index 0000000..a39ea71
> >> --- /dev/null
> >> +++ b/providers/bnxt_re/flush.h
> >> @@ -0,0 +1,85 @@
> >> +/*
> >> + * Broadcom NetXtreme-E User Space RoCE driver
> >> + *
> >> + * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
> >> + * Broadcom refers to Broadcom Limited and/or its subsidiaries.
> >> + *
> >> + * This software is available to you under a choice of one of two
> >> + * licenses.  You may choose to be licensed under the terms of the GNU
> >> + * General Public License (GPL) Version 2, available from the file
> >> + * COPYING in the main directory of this source tree, or the
> >> + * BSD license below:
> >> + *
> >> + * Redistribution and use in source and binary forms, with or without
> >> + * modification, are permitted provided that the following conditions
> >> + * are met:
> >> + *
> >> + * 1. Redistributions of source code must retain the above copyright
> >> + *    notice, this list of conditions and the following disclaimer.
> >> + * 2. Redistributions in binary form must reproduce the above copyright
> >> + *    notice, this list of conditions and the following disclaimer in
> >> + *    the documentation and/or other materials provided with the
> >> + *    distribution.
> >> + *
> >> + * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
> >> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
> >> + * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
> >> + * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
> >> + * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> >> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> >> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> >> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
> >> + * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
> >> + * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
> >> + * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> >> + *
> >> + * Description: A few wrappers for flush queue management
> >> + */
> >> +
> >> +#ifndef __FLUSH_H__
> >> +#define __FLUSH_H__
> >> +
> >> +#include <ccan/list.h>
> >> +
> >> +struct bnxt_re_fque_node {
> >> +     uint8_t valid;
> >> +     struct list_node list;
> >> +};
> >> +
> >> +static inline void fque_init_node(struct bnxt_re_fque_node *node)
> >> +{
> >> +     list_node_init(&node->list);
> >> +     node->valid = false;
> >> +}
> >> +
> >> +static inline void fque_add_node_tail(struct list_head *head,
> >> +                                   struct bnxt_re_fque_node *new)
> >> +{
> >> +     list_add_tail(head, &new->list);
> >> +     new->valid = true;
> >> +}
> >> +
> >> +static inline void fque_del_node(struct bnxt_re_fque_node *entry)
> >> +{
> >> +     entry->valid = false;
> >> +     list_del(&entry->list);
> >> +}
> >> +
> >
> > I don't see the point of these wrappers.
>
> Wanted to keep "entry->valid" as a property of list element rather
> mixing it in the QP structure to keep things clean. Thus, could not
> resist to keep those.

It looks like list == NULL can do the trick.

Thanks

--2IUIi54rL+LZyXu+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljOPYoACgkQ5GN7iDZy
WKe5VQ/9HctaroCVItF+Ir3vJjbn8+jVsWV0SS5T2cAb1fnKLNBmmmmhbgT3ooSI
90np9jvDYy9Aeh5y0SStwH8Tmb/rY2f4VjwLDWRRzbC4zhNAizgakG940MyoYkl7
XRI9crqQ4CrhSeqaog72i6oH5bGg2Ce/VtT2P3assaZINH4aFoHckTeRxlHbFue1
RNQGEYO0lirlkJ4UK8uRAyRmt6wwbHLdGC/gZs5g8sOtjPGKyeD5RYDfEKfBzhpq
Dvp1ClE3cZnxufruNLY4kGU4Rhq4igqfk3+FZg5GoxSbUwSL85hU6VW8rkvGdhC0
AGFFhjeA7JCV19oYVy/tAd/Qav7sediL4eEsPLz6xyjlTIS/sCQa7aJv/3p+ZsBS
zWR4EcCW05bDMhaFufs7WCgt4Vn5qTlXszu3Y1kiAR86WZEN5GpyexcFiSXVMHtY
+66cbv5uz7dqyCGYaUgGSeB9jouw44bVrqPNeSj99HFB5zfks8Se9uXe8dPHdX0s
q6Vy2uLIvhGc8S/e1fRAN7iq5334PE21tCxokp52thUQwOBRqcAvm+9PIEpFXrEo
OZXMhdzXRnl6lCenpiI9QNQ10BAyah5MpwEtMgXzmyCuyCf/Mqwfql6fewODPFGR
BTjtI2aIopYuG48yPDnqGBuF9dFJ94r1RRY+4Fy816+OPPSJqw4=
=iut8
-----END PGP SIGNATURE-----

--2IUIi54rL+LZyXu+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
