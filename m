From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Sun, 8 Aug 2010 20:19:03 +0200
Message-ID: <AANLkTinKsLNoia96AVDA6fP9Es5_2Rq_wTgY=z6wk_FE@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	<adafwz4g98j.fsf@roland-alpha.cisco.com>
	<AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
	<20100727182046.GT7920@obsidianresearch.com>
	<AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g@mail.gmail.com>
	<adavd7mz8m9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavd7mz8m9.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 7, 2010 at 6:32 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote=
:
> Not sure that I follow the problem you're worried about. =A0A given
> tasklet can only be running on one CPU at any one time -- if an
> interrupt occurs and reschedules the tasklet then it just runs again
> when it exits.
>
> Also I'm not sure I understand why this is special for IB hardware --
> standard practice is for interrupt handlers to clear the interrupt
> source and reenable interrupts, so I don't see why the same thing you
> describe can't happen with any interrupt-generating device that defer=
s
> work to a tasklet.

One of the applications I have been looking at is adding blk-iopoll
support in ib_srp and to make it possible to enable and disable
blk-iopoll at runtime via sysfs. A naive implementation could look
e.g. as follows:

/* Poll the IB receive queue once. Returns zero if this function
should be called again. */
static int srp_recv_poll(struct ib_cq *cq, struct srp_target_port *targ=
et)
{
	struct ib_wc wc;

	do {
		if (ib_poll_cq(cq, 1, &wc) > 0) {
			if (wc.status =3D=3D IB_WC_SUCCESS) {
				srp_handle_recv(target, &wc);
				return 0;
			} else {
				shost_printk(KERN_ERR, target->scsi_host,
					     PFX "failed receive status %d\n",
					     wc.status);
				target->qp_in_error =3D 1;
			}
		}
	} while (ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP
				  | IB_CQ_REPORT_MISSED_EVENTS) > 0);
	return -1;
}

/* blk-iopoll callback function, which is invoked on tasklet context. *=
/
static int srp_iopoll(struct blk_iopoll *iop, int budget)
{
	struct srp_target_port *target;
	int processed;

	target =3D container_of(iop, struct srp_target_port, iopoll);
	for (processed =3D 0; processed < budget; processed++) {
		if (srp_recv_poll_once(target->recv_cq, target) !=3D 0) {
			blk_iopoll_complete(iop);
			break;
		}
	}
	return processed;
}

/* receive completion queue notification callback function, which is
typically invoked on IRQ context. */
static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
{
	struct srp_target_port *target =3D target_ptr;

	if (target->iopoll_enabled
	    && blk_iopoll_sched_prep(&target->iopoll) =3D=3D 0)
		blk_iopoll_sched(&target->iopoll);
	else
		while (srp_recv_poll_once(cq, target) =3D=3D 0)
			;
}

/* sysfs callback function that shows the current value of
target->blk_iopoll_enabled */

/* sysfs callback function that allows to set the value of
target->blk_iopoll_enabled */

As far as I can see with the above implementation enabling blk-iopoll
mode would be fine, but disabling not, because while disabling
blk-iopoll mode it could e.g. happen that srp_iopoll() is still
polling the receive completion queue on one CPU in tasklet context and
srp_recv_completion() starts polling the receive queue simultaneously
on another CPU in IRQ context. This can happen independently of
whether loop (1) or loop (2) is used to poll the IB receive completion
queue (see also http://www.spinics.net/lists/linux-rdma/msg05003.html
for the definitions of loop (1) and (2)). Although it is possible to
wait for completion of a tasklet by calling tasklet_disable(), I don't
think it is safe to call this function from IRQ context because that
might trigger a deadlock.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
