From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/27] IB/rdmavt: Adding timer logic to rdmavt
Date: Sun, 12 Feb 2017 19:33:20 +0200
Message-ID: <20170212173320.GH14015@mtr-leonro.local>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
 <20170208132712.16442.57028.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o71xDhNo7p97+qVi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208132712.16442.57028.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--o71xDhNo7p97+qVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 05:27:13AM -0800, Dennis Dalessandro wrote:
> From: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> To move common code across target to rdmavt for code reuse.
>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c |  183 +++++++++++++++++++++++++++++++++++++
>  include/rdma/rdma_vt.h            |   19 ++++
>  include/rdma/rdmavt_qp.h          |    6 +
>  3 files changed, 206 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
> index 444b06c..db4315f 100644
> --- a/drivers/infiniband/sw/rdmavt/qp.c
> +++ b/drivers/infiniband/sw/rdmavt/qp.c
> @@ -55,6 +55,46 @@
>  #include "vt.h"
>  #include "trace.h"
>
> +static void rvt_rc_timeout(unsigned long arg);
> +
> +/*
> + * Convert the AETH RNR timeout code into the number of microseconds.
> + */
> +static const u32 ib_rvt_rnr_table[32] = {
> +	655360, /* 00: 655.36 */
> +	10,     /* 01:    .01 */
> +	20,     /* 02     .02 */
> +	30,     /* 03:    .03 */
> +	40,     /* 04:    .04 */
> +	60,     /* 05:    .06 */
> +	80,     /* 06:    .08 */
> +	120,    /* 07:    .12 */
> +	160,    /* 08:    .16 */
> +	240,    /* 09:    .24 */
> +	320,    /* 0A:    .32 */
> +	480,    /* 0B:    .48 */
> +	640,    /* 0C:    .64 */
> +	960,    /* 0D:    .96 */
> +	1280,   /* 0E:   1.28 */
> +	1920,   /* 0F:   1.92 */
> +	2560,   /* 10:   2.56 */
> +	3840,   /* 11:   3.84 */
> +	5120,   /* 12:   5.12 */
> +	7680,   /* 13:   7.68 */
> +	10240,  /* 14:  10.24 */
> +	15360,  /* 15:  15.36 */
> +	20480,  /* 16:  20.48 */
> +	30720,  /* 17:  30.72 */
> +	40960,  /* 18:  40.96 */
> +	61440,  /* 19:  61.44 */
> +	81920,  /* 1A:  81.92 */
> +	122880, /* 1B: 122.88 */
> +	163840, /* 1C: 163.84 */
> +	245760, /* 1D: 245.76 */
> +	327680, /* 1E: 327.68 */
> +	491520  /* 1F: 491.52 */
> +};
> +
>  /*
>   * Note that it is OK to post send work requests in the SQE and ERR
>   * states; rvt_do_send() will process them and generate error
> @@ -200,7 +240,8 @@ int rvt_driver_qp_init(struct rvt_dev_info *rdi)
>  	if (!rdi->driver_f.free_all_qps ||
>  	    !rdi->driver_f.qp_priv_alloc ||
>  	    !rdi->driver_f.qp_priv_free ||
> -	    !rdi->driver_f.notify_qp_reset)
> +	    !rdi->driver_f.notify_qp_reset ||
> +	    !rdi->driver_f.notify_restart_rc)
>  		return -EINVAL;
>
>  	/* allocate parent object */
> @@ -587,6 +628,7 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
>
>  		/* Let drivers flush their waitlist */
>  		rdi->driver_f.flush_qp_waiters(qp);
> +		rvt_stop_rc_timers(qp);
>  		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
>  		spin_unlock(&qp->s_lock);
>  		spin_unlock(&qp->s_hlock);
> @@ -594,7 +636,7 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
>
>  		/* Stop the send queue and the retry timer */
>  		rdi->driver_f.stop_send_queue(qp);
> -
> +		rvt_del_timers_sync(qp);
>  		/* Wait for things to stop */
>  		rdi->driver_f.quiesce_qp(qp);
>
> @@ -730,6 +772,11 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
>  			if (!qp->s_ack_queue)
>  				goto bail_qp;
>  		}
> +		/* initialize timers needed for rc qp */
> +		setup_timer(&qp->s_timer, rvt_rc_timeout, (unsigned long)qp);
> +		hrtimer_init(&qp->s_rnr_timer, CLOCK_MONOTONIC,
> +			     HRTIMER_MODE_REL);
> +		qp->s_rnr_timer.function = rvt_rc_rnr_retry;
>
>  		/*
>  		 * Driver needs to set up it's private QP structure and do any
> @@ -1906,3 +1953,135 @@ void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
>  	}
>  }
>  EXPORT_SYMBOL(rvt_rc_error);
> +
> +static inline unsigned long rvt_aeth_to_usec(u32 aeth)
> +{
> +	return ib_rvt_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
> +				  RVT_AETH_CREDIT_MASK];
> +}

No need to inline this function.
http://lxr.free-electrons.com/source/Documentation/CodingStyle#L861


> +
> +/*
> + *  rvt_add_retry_timer - add/start a retry timer
> + *  @qp - the QP
> + *  add a retry timer on the QP
> + */
> +void rvt_add_retry_timer(struct rvt_qp *qp)
> +{
> +	struct ib_qp *ibqp = &qp->ibqp;
> +	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
> +
> +	lockdep_assert_held(&qp->s_lock);
> +	qp->s_flags |= RVT_S_TIMER;
> +       /* 4.096 usec. * (1 << qp->timeout) */
> +	qp->s_timer.expires = jiffies + qp->timeout_jiffies +
> +			     rdi->busy_jiffies;
> +	add_timer(&qp->s_timer);
> +}
> +EXPORT_SYMBOL(rvt_add_retry_timer);
> +
> +/**
> + * rvt_add_rnr_timer - add/start an rnr timer
> + * @qp - the QP
> + * @aeth - aeth of RNR timeout, simulated aeth for loopback
> + * add an rnr timer on the QP
> + */
> +void rvt_add_rnr_timer(struct rvt_qp *qp, u32 aeth)
> +{
> +	u32 to;
> +
> +	lockdep_assert_held(&qp->s_lock);
> +	qp->s_flags |= RVT_S_WAIT_RNR;
> +	to = rvt_aeth_to_usec(aeth);
> +	hrtimer_start(&qp->s_rnr_timer,
> +		      ns_to_ktime(1000 * to), HRTIMER_MODE_REL);
> +}
> +EXPORT_SYMBOL(rvt_add_rnr_timer);
> +
> +/**
> + * rvt_stop_rc_timers - stop all timers
> + * @qp - the QP
> + * stop any pending timers
> + */
> +void rvt_stop_rc_timers(struct rvt_qp *qp)
> +{
> +	lockdep_assert_held(&qp->s_lock);
> +	/* Remove QP from all timers */
> +	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
> +		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
> +		del_timer(&qp->s_timer);
> +		hrtimer_try_to_cancel(&qp->s_rnr_timer);
> +	}
> +}
> +EXPORT_SYMBOL(rvt_stop_rc_timers);
> +
> +/**
> + * rvt_stop_rnr_timer - stop an rnr timer
> + * @qp - the QP
> + *
> + * stop an rnr timer and return if the timer
> + * had been pending.
> + */
> +static int rvt_stop_rnr_timer(struct rvt_qp *qp)
> +{
> +	int rval = 0;
> +
> +	lockdep_assert_held(&qp->s_lock);
> +	/* Remove QP from rnr timer */
> +	if (qp->s_flags & RVT_S_WAIT_RNR) {
> +		qp->s_flags &= ~RVT_S_WAIT_RNR;
> +		rval = hrtimer_try_to_cancel(&qp->s_rnr_timer);
> +	}
> +	return rval;
> +}
> +
> +/**
> + * rvt_del_timers_sync - wait for any timeout routines to exit
> + * @qp - the QP
> + */
> +void rvt_del_timers_sync(struct rvt_qp *qp)
> +{
> +	del_timer_sync(&qp->s_timer);
> +	hrtimer_cancel(&qp->s_rnr_timer);
> +}
> +EXPORT_SYMBOL(rvt_del_timers_sync);
> +
> +/**
> + * This is called from s_timer for missing responses.
> + */
> +static void rvt_rc_timeout(unsigned long arg)
> +{
> +	struct rvt_qp *qp = (struct rvt_qp *)arg;
> +	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->r_lock, flags);
> +	spin_lock(&qp->s_lock);
> +	if (qp->s_flags & RVT_S_TIMER) {
> +		qp->s_flags &= ~RVT_S_TIMER;
> +		del_timer(&qp->s_timer);
> +		if (rdi->driver_f.notify_restart_rc)
> +			rdi->driver_f.notify_restart_rc(qp,
> +							qp->s_last_psn + 1,
> +							1);
> +		rdi->driver_f.schedule_send(qp);
> +	}
> +	spin_unlock(&qp->s_lock);
> +	spin_unlock_irqrestore(&qp->r_lock, flags);
> +}
> +
> +/*
> + * This is called from s_timer for RNR timeouts.
> + */
> +enum hrtimer_restart rvt_rc_rnr_retry(struct hrtimer *t)
> +{
> +	struct rvt_qp *qp = container_of(t, struct rvt_qp, s_rnr_timer);
> +	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->s_lock, flags);
> +	rvt_stop_rnr_timer(qp);
> +	rdi->driver_f.schedule_send(qp);
> +	spin_unlock_irqrestore(&qp->s_lock, flags);
> +	return HRTIMER_NORESTART;
> +}
> +EXPORT_SYMBOL(rvt_rc_rnr_retry);
> diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
> index 861e23e..a69dee3 100644
> --- a/include/rdma/rdma_vt.h
> +++ b/include/rdma/rdma_vt.h
> @@ -335,6 +335,8 @@ struct rvt_driver_provided {
>  	/* Notify driver a mad agent has been removed */
>  	void (*notify_free_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
>
> +	/* Notify driver to restart rc */
> +	void (*notify_restart_rc)(struct rvt_qp *qp, u32 psn, int wait);
>  };
>
>  struct rvt_dev_info {
> @@ -483,6 +485,23 @@ static inline u16 rvt_get_pkey(struct rvt_dev_info *rdi,
>  	return qp;
>  }
>
> +/**
> + * rvt_mod_retry_timer - mod a retry timer
> + * @qp - the QP
> + * Modify a potentially already running retry timer
> + */
> +static inline void rvt_mod_retry_timer(struct rvt_qp *qp)
> +{
> +	struct ib_qp *ibqp = &qp->ibqp;
> +	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
> +
> +	lockdep_assert_held(&qp->s_lock);
> +	qp->s_flags |= RVT_S_TIMER;
> +	/* 4.096 usec. * (1 << qp->timeout) */
> +	mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies +
> +		  rdi->busy_jiffies);
> +}
> +
>  struct rvt_dev_info *rvt_alloc_device(size_t size, int nports);
>  void rvt_dealloc_device(struct rvt_dev_info *rdi);
>  int rvt_register_device(struct rvt_dev_info *rvd);
> diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
> index a92e7dc..0b1cbff 100644
> --- a/include/rdma/rdmavt_qp.h
> +++ b/include/rdma/rdmavt_qp.h
> @@ -370,6 +370,7 @@ struct rvt_qp {
>
>  	struct rvt_sge_state s_ack_rdma_sge;
>  	struct timer_list s_timer;
> +	struct hrtimer s_rnr_timer;
>
>  	atomic_t local_ops_pending; /* number of fast_reg/local_inv reqs */
>
> @@ -641,5 +642,10 @@ static inline u32 rvt_div_mtu(struct rvt_qp *qp, u32 len)
>  void rvt_comm_est(struct rvt_qp *qp);
>  int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
>  void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
> +enum hrtimer_restart rvt_rc_rnr_retry(struct hrtimer *t);
> +void rvt_add_rnr_timer(struct rvt_qp *qp, u32 aeth);
> +void rvt_del_timers_sync(struct rvt_qp *qp);
> +void rvt_stop_rc_timers(struct rvt_qp *qp);
> +void rvt_add_retry_timer(struct rvt_qp *qp);
>
>  #endif          /* DEF_RDMAVT_INCQP_H */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--o71xDhNo7p97+qVi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlignGAACgkQ5GN7iDZy
WKe5Fw//ckhwIUdkqKL3fnm+/BbFrLtTO248saPbAtZx+qm0cde9senOztS/B9Fn
ED4frnE13RH+loCBNU/d47P0MwhtkUPxSwjsPIPFOIoKzSQNmo0lSH2HAzvmbKpZ
JK7FmNwn+uj94gbM9zkGjTJU9L4iVN2GwIEWnJOmpAL0L4SouXyBbD7uaayFC8Jr
kDL0JmucsYelcy8a0ySq+NCphLg5QLyvgMoocecx5PM1QxGeWz+6CjwAY7iSJT9W
dUwXA/Ws4CvNTMVQXeemmursvuM3fXBsFGtumjrGNbqVjIvSI/LUOIO2CatDPTFn
RaX4xqoFYi0PZFh+iuxzFvOwlobWJu4UbwkmwOA4yBSUWLsGoAXCIEfPtEZVko0A
XuIWXmwHRjVzae8s6OfVZ0qHAcp23RWYoHQWViHnanFM4Nd1lGV0TysNmUkbbSGF
STsbseC+g2D6XMHwIDABvt9kjFyDx7wJoEAPCU9dXazgF7ohIewpIF3LvCm8ifZE
0IaAx+CN0tyP/5O3ujCbFRB+xSyu39qTnTw8hTAgN352kg9WYFGPWKJRkbgehOJ5
Q5q17gtOvFyf7qZOmfxsbhJkuyFGlsYL3u9txLrDaZvgTOfqQ0eP/hNzjHyVTo1O
ymVvGccFlKSZIXKUB1Lh/BeCPsg8tXv1oeNaUdsas1lFg7ZRElY=
=eP4z
-----END PGP SIGNATURE-----

--o71xDhNo7p97+qVi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
