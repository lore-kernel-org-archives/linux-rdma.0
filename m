From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 17:27:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710051726490.2083@nanos>
References: <20171003154920.31566-1-acme@kernel.org> <20171003154920.31566-2-acme@kernel.org> <20171005141744.GC21185@jcartwri.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171005141744.GC21185-ew3lsbMjNqt5wtABiV/Xjqyly8cj88Ttqxv4g6HH51o@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Cartwright <julia-acOepvfBmUk@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 5 Oct 2017, Julia Cartwright wrote:
> On Tue, Oct 03, 2017 at 12:49:19PM -0300, Arnaldo Carvalho de Melo wrote:
> > -	preempt_disable();
> > +	preempt_disable_nort();
> >  	this_cpu_inc(*sc->buffers_allocated);
> 
> Have you tried this on RT w/ CONFIG_DEBUG_PREEMPT?  I believe that the
> this_cpu_* operations perform a preemption check, which we'd trip.

Good point. Changing this to migrate_disable() would do the trick.

Thanks,

	tglx
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
