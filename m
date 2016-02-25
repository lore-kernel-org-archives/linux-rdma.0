From: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: staging/rdma/hfi1: Add support for enabling/disabling PCIe ASPM
Date: Wed, 24 Feb 2016 22:00:48 -0500
Message-ID: <tnm1t60xd334v.fsf@phwtpriv05.ph.intel.com>
References: <20160203223302.5923.92377.stgit@scvm10.sc.intel.com>
	<20160223115728.GA6058@smile.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160223115728.GA6058-XvqNBM/wLWRrdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Andy Shevchenko's
	message of "Tue, 23 Feb 2016 04:57:28 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Shevchenko, Andriy" <andriy.shevchenko-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 23 2016 at 06:57:28 AM, Andy Shevchenko <andriy.shevchenko@=
linux.intel.com> wrote:
>> +/* ASPM processing for each receive context interrupt */
>> +static inline void aspm_ctx_disable(struct hfi1_ctxtdata *rcd)
>> +{
>> +	bool restart_timer;
>> +	bool close_interrupts;
>> +	unsigned long flags;
>> +	ktime_t now, prev;
>> +
>> +	/* Quickest exit for minimum impact */
>> +	if (!rcd->aspm_intr_supported)
>> +		return;
>> +
>> +	spin_lock_irqsave(&rcd->aspm_lock, flags);
>> +	/* PSM contexts are open */
>> +	if (!rcd->aspm_intr_enable)
>> +		goto ret;
>> +
>> +	prev =3D rcd->aspm_ts_last_intr;
>> +	now =3D ktime_get();
>> +	rcd->aspm_ts_last_intr =3D now;
>> +
>> +	/* An interrupt pair close together in time */
>> +	close_interrupts =3D ktime_to_ns(ktime_sub(now, prev)) <
>> ASPM_TRIGGER_NS;
>> +
>> +	/* Don't push out our timer till this much time has elapsed
>> */
>> +	restart_timer =3D ktime_to_ms(ktime_sub(now, rcd-
>> >aspm_ts_timer_sched)) >
>> +				ASPM_RESCHED_TIMER_MS;
>
>> +	restart_timer =3D restart_timer && close_interrupts;
>> +
>> +	/* Disable ASPM and schedule timer */
>> +	if (rcd->aspm_enabled && close_interrupts) {
>> +		aspm_disable_inc(rcd->dd);
>> +		rcd->aspm_enabled =3D false;
>> +		restart_timer =3D true;
>> +	}
>> +
>> +	if (restart_timer) {
>> +		mod_timer(&rcd->aspm_timer,
>> +			=C2=A0=C2=A0jiffies +
>> msecs_to_jiffies(ASPM_TIMER_MS));
>> +		rcd->aspm_ts_timer_sched =3D now;
>> +	}
>
> What about the following changes (mostly about replacing divisions by
> multiplications)?
>
>
> ktime_t eta, restart;
>
> eta =3D ktime_add_ns(rcd->aspm_ts_last_intr, ASPM_TRIGGER_NS);
>
> rcd->aspm_ts_last_intr =3D ktime_get();
>
> /* Close interrupts? */
> if (ktime_before(now, eta)) {
> =C2=A0 /* Disable ASPM? */
> =C2=A0 if (rcd->aspm_enabled) {
> =C2=A0 =C2=A0
> aspm_disable_inc(rcd->dd);
> =C2=A0 =C2=A0 rcd->aspm_enabled =3D false;
> =C2=A0 } else {
> =C2=A0 =C2=A0
> restart =3D ktime_add_ms(rcd->aspm_ts_timer_sched,
> ASPM_RESCHED_TIMER_MS);
> =C2=A0 =C2=A0 if (ktime_before(rcd->aspm_ts_last_intr,
> restart))
> =C2=A0 =C2=A0 =C2=A0 goto exit_unlock;
> =C2=A0 }
>
> =C2=A0 /* Restart timer */
> =C2=A0 mod_timer(&rcd->aspm_timer, jiffies + msecs_to_jiffies(ASPM_TI=
MER_MS));
> =C2=A0 rcd->aspm_ts_timer_sched =3D rcd->aspm_ts_last_intr;
> }

There are no divisions in the code segment above. We discussed it
internally and there is agreement to leave the patch as is.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
