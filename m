From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: staging/rdma/hfi1: Add support for enabling/disabling PCIe ASPM
Date: Tue, 23 Feb 2016 13:57:28 +0200
Message-ID: <20160223115728.GA6058@smile.fi.intel.com>
References: <20160203223302.5923.92377.stgit@scvm10.sc.intel.com>
Reply-To: "Shevchenko, Andriy" <andriy.shevchenko-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203223302.5923.92377.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dixit, Ashutosh" <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> +/* ASPM processing for each receive context interrupt */
> +static inline void aspm_ctx_disable(struct hfi1_ctxtdata *rcd)
> +{
> +	bool restart_timer;
> +	bool close_interrupts;
> +	unsigned long flags;
> +	ktime_t now, prev;
> +
> +	/* Quickest exit for minimum impact */
> +	if (!rcd->aspm_intr_supported)
> +		return;
> +
> +	spin_lock_irqsave(&rcd->aspm_lock, flags);
> +	/* PSM contexts are open */
> +	if (!rcd->aspm_intr_enable)
> +		goto ret;
> +
> +	prev =3D rcd->aspm_ts_last_intr;
> +	now =3D ktime_get();
> +	rcd->aspm_ts_last_intr =3D now;
> +
> +	/* An interrupt pair close together in time */
> +	close_interrupts =3D ktime_to_ns(ktime_sub(now, prev)) <
> ASPM_TRIGGER_NS;
> +
> +	/* Don't push out our timer till this much time has elapsed
> */
> +	restart_timer =3D ktime_to_ms(ktime_sub(now, rcd-
> >aspm_ts_timer_sched)) >
> +				ASPM_RESCHED_TIMER_MS;

> +	restart_timer =3D restart_timer && close_interrupts;
> +
> +	/* Disable ASPM and schedule timer */
> +	if (rcd->aspm_enabled && close_interrupts) {
> +		aspm_disable_inc(rcd->dd);
> +		rcd->aspm_enabled =3D false;
> +		restart_timer =3D true;
> +	}
> +
> +	if (restart_timer) {
> +		mod_timer(&rcd->aspm_timer,
> +			=A0=A0jiffies +
> msecs_to_jiffies(ASPM_TIMER_MS));
> +		rcd->aspm_ts_timer_sched =3D now;
> +	}

What about the following changes (mostly about replacing divisions by
multiplications)?


ktime_t eta, restart;

eta =3D ktime_add_ns(rcd->aspm_ts_last_intr, ASPM_TRIGGER_NS);

rcd->aspm_ts_last_intr =3D ktime_get();

/* Close interrupts? */
if (ktime_before(now, eta)) {
=A0 /* Disable ASPM? */
=A0 if (rcd->aspm_enabled) {
=A0 =A0
aspm_disable_inc(rcd->dd);
=A0 =A0 rcd->aspm_enabled =3D false;
=A0 } else {
=A0 =A0
restart =3D ktime_add_ms(rcd->aspm_ts_timer_sched,
ASPM_RESCHED_TIMER_MS);
=A0 =A0 if (ktime_before(rcd->aspm_ts_last_intr,
restart))
=A0 =A0 =A0 goto exit_unlock;
=A0 }

=A0 /* Restart timer */
=A0 mod_timer(&rcd->aspm_timer, jiffies + msecs_to_jiffies(ASPM_TIMER_M=
S));
=A0 rcd->aspm_ts_timer_sched =3D rcd->aspm_ts_last_intr;
}

> +ret:

Better naming is 'exit_unlock' or just 'unlock'.

> +	spin_unlock_irqrestore(&rcd->aspm_lock, flags);
> +}


--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki=20
Business Identity Code: 0357606 - 4=20
Domiciled in Helsinki=20

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
