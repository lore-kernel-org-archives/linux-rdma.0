From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: RE: [PATCH v3 05/13] SoftiWarp application interface
Date: Tue, 23 Jan 2018 18:07:39 +0000
Message-ID: <OF7390EC15.6C2741F2-ON0025821E.0062D222-0025821E.00639402@notes.na.collabserv.com>
References: <012901d3946e$41044a70$c30cdf50$@opengridcomputing.com>,<20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-6-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <012901d3946e$41044a70$c30cdf50$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



-----"Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote: -----

>To: "'Bernard Metzler'" <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>,
><linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>Date: 01/23/2018 06:19PM
>Subject: RE: [PATCH v3 05/13] SoftiWarp application interface
>
>> 
>> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/siw/siw_ae.c    |  120 +++
>>  drivers/infiniband/sw/siw/siw_verbs.c | 1876
>> +++++++++++++++++++++++++++++++++
>>  drivers/infiniband/sw/siw/siw_verbs.h |  119 +++
>>  include/uapi/rdma/siw_user.h          |  216 ++++
>>  4 files changed, 2331 insertions(+)
>>  create mode 100644 drivers/infiniband/sw/siw/siw_ae.c
>>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.c
>>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.h
>>  create mode 100644 include/uapi/rdma/siw_user.h
>> 
>> diff --git a/drivers/infiniband/sw/siw/siw_ae.c
>> b/drivers/infiniband/sw/siw/siw_ae.c
>> new file mode 100644
>> index 000000000000..eac55ce7f56d
>> --- /dev/null
>> +++ b/drivers/infiniband/sw/siw/siw_ae.c
>> @@ -0,0 +1,120 @@
>> +/*
>> + * Software iWARP device driver
>> + *
>> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> + *
>> + * Copyright (c) 2008-2017, IBM Corporation
>> + *
>> + * This software is available to you under a choice of one of two
>> + * licenses. You may choose to be licensed under the terms of the
>GNU
>> + * General Public License (GPL) Version 2, available from the file
>> + * COPYING in the main directory of this source tree, or the
>> + * BSD license below:
>> + *
>> + *   Redistribution and use in source and binary forms, with or
>> + *   without modification, are permitted provided that the
>following
>> + *   conditions are met:
>> + *
>> + *   - Redistributions of source code must retain the above
>copyright
>notice,
>> + *     this list of conditions and the following disclaimer.
>> + *
>> + *   - Redistributions in binary form must reproduce the above
>copyright
>> + *     notice, this list of conditions and the following
>disclaimer in
>the
>> + *     documentation and/or other materials provided with the
>distribution.
>> + *
>> + *   - Neither the name of IBM nor the names of its contributors
>may be
>> + *     used to endorse or promote products derived from this
>software
>without
>> + *     specific prior written permission.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
>> OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
>> HOLDERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
>AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
>> IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>> THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/types.h>
>> +#include <linux/net.h>
>> +#include <linux/scatterlist.h>
>> +#include <linux/highmem.h>
>> +#include <net/sock.h>
>> +#include <net/tcp_states.h>
>> +#include <net/tcp.h>
>> +
>> +#include <rdma/iw_cm.h>
>> +#include <rdma/ib_verbs.h>
>> +#include <rdma/ib_smi.h>
>> +#include <rdma/ib_user_verbs.h>
>> +
>> +#include "siw.h"
>> +#include "siw_obj.h"
>> +#include "siw_cm.h"
>> +
>> +void siw_qp_event(struct siw_qp *qp, enum ib_event_type etype)
>> +{
>> +	struct ib_event event;
>> +	struct ib_qp	*base_qp = &qp->base_qp;
>> +
>> +	/*
>> +	 * Do not report asynchronous errors on QP which gets
>> +	 * destroyed via verbs interface (siw_destroy_qp())
>> +	 */
>> +	if (qp->attrs.flags & SIW_QP_IN_DESTROY)
>> +		return;
>> +
>> +	event.event = etype;
>> +	event.device = base_qp->device;
>> +	event.element.qp = base_qp;
>> +
>> +	if (base_qp->event_handler) {
>> +		siw_dbg_qp(qp, "reporting event %d\n", etype);
>> +		(*base_qp->event_handler)(&event, base_qp->qp_context);
>> +	}
>> +}
>> +
>> +void siw_cq_event(struct siw_cq *cq, enum ib_event_type etype)
>> +{
>> +	struct ib_event event;
>> +	struct ib_cq	*base_cq = &cq->base_cq;
>> +
>> +	event.event = etype;
>> +	event.device = base_cq->device;
>> +	event.element.cq = base_cq;
>> +
>> +	if (base_cq->event_handler) {
>> +		siw_dbg(cq->hdr.sdev, "reporting CQ event %d\n", etype);
>> +		(*base_cq->event_handler)(&event, base_cq->cq_context);
>> +	}
>> +}
>> +
>
>The rdma provider must ensure that event upcalls are serialized per
>object.
>Is this being done somewhere?  See "Callbacks" in
>Documentation/infiniband/core_locking.txt.
>

That says, if multiple QP's etc. contribute to a CQ, only one
CQ event handler is allowed to run? That's not there, I would have
to make a lock around...
>
>
>> +void siw_srq_event(struct siw_srq *srq, enum ib_event_type etype)
>> +{
>> +	struct ib_event event;
>> +	struct ib_srq	*base_srq = &srq->base_srq;
>> +
>> +	event.event = etype;
>> +	event.device = base_srq->device;
>> +	event.element.srq = base_srq;
>> +
>> +	if (base_srq->event_handler) {
>> +		siw_dbg(srq->pd->hdr.sdev, "reporting SRQ event %d\n",
>> etype);
>> +		(*base_srq->event_handler)(&event, base_srq->srq_context);
>> +	}
>> +}
>> +

...


>> +	/*
>> +	 * Try to acquire QP state lock. Must be non-blocking
>> +	 * to accommodate kernel clients needs.
>> +	 */
>> +	if (!down_read_trylock(&qp->state_lock)) {
>> +		*bad_wr = wr;
>> +		return -ENOTCONN;
>> +	}
>> +
>
>Under what conditions does down_read_trylock() return 0?  This seems
>like a
>kernel ULP that has multiple threads posting to the sq might get an
>error
>due to lock contention?  

This lock is only taken if the QP is to be transitioned into
another state. If we are here, we assume to be in RTS state.
If the lock is not available, someone else just moves the QP out
of RTS and we should not do much here.

We do trylock() since we cannot sleep in some of our contexts...

>
>> +	if (unlikely(qp->attrs.state != SIW_QP_STATE_RTS)) {
>> +		up_read(&qp->state_lock);
>> +		*bad_wr = wr;
>> +		return -ENOTCONN;
>> +	}
>
>NOTCONN is inappropriate here too.  Also, I relaxed iw_cxgb4 to
>support
>ib_drain_qp().  Basically if the kernel QP is in ERROR,  a post will
>be
>completed via a CQE inserted with status IB_WC_WR_FLUSH_ERR.  See how
>ib_drain_qp() works for details.  The reason I bring this up, is that
>both
>iser and nvmf ULPs use ib_drain_sq/rq/qp() so you might want to
>support
>them.  There is an alternate solution though.  ib_drain_sq/rq()
>allows the
>low level driver to have its own drain implementation.  See those
>functions
>for details.
>

Ok, will look into it.

siw has methods to drain send and receive queue
(siw_sq_flush()/siw_rq_flush())

If this is a requirement, and an immediate error is not appropriate,
we could put the failing work request at the CQ for later draining.

>
>> +	if (wr && !qp->kernel_verbs) {
>> +		siw_dbg_qp(qp, "wr must be empty for user mapped sq\n");
>> +		up_read(&qp->state_lock);
>> +		*bad_wr = wr;
>> +		return -EINVAL;
>> +	}

...


>> +#define SIW_MAX_INLINE	(sizeof(struct siw_sge) * (SIW_MAX_SGE -
>1))
>> +
>> +#if SIW_MAX_SGE < 2
>> +#error "SIW_MAX_SGE must be at least 2"
>> +#endif
>
>This could be done with BUILD_BUG_ON().
>

Right. will do!

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
