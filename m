From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/hfi1: Handle packets in the theaded handler only
Date: Wed, 11 Oct 2017 16:07:45 -0300
Message-ID: <20171011190745.GF3503@kernel.org>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-3-acme@kernel.org>
 <3003fbfd-6d34-a968-1264-7c16580d5ce6@intel.com>
 <20171010191529.GP28623@kernel.org>
 <20171011104456.mlewocqc6ghi3fev@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171011104456.mlewocqc6ghi3fev-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Julia Cartwright <julia-acOepvfBmUk@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Em Wed, Oct 11, 2017 at 12:44:56PM +0200, Sebastian Andrzej Siewior escreveu:
> On 2017-10-10 16:15:29 [-0300], Arnaldo Carvalho de Melo wrote:
> > This may not even be needed, i.e. Sebastian Siewior said that recent
> > rt patches already identify the way this driver uses threaded interrupts
> > and automagically does the right thing, Sebastian?
> > 
> > He mentioned this in this message:
> > 
> > https://marc.info/?l=linux-rt-users&m=150722087514307&w=2
> > 
> > But I replied to Mike and don't recall getting an answer to my last
> > question.
> 
> correct, since 4.1.7-rt8
>   https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/commit/?h=v4.1.7-rt8-patches&id=7461758b9e982e4ea6280ce9308492e7cceda2ed

Ouch, it seems I looked at the wrong place, as patches-4.11.12-rt14
doesn't have this one, right?

Off I go trying to make sense of this...

- Arnaldo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
