From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 15:53:30 -0300
Message-ID: <20171005185330.GP25388@kernel.org>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-2-acme@kernel.org>
 <20171005141744.GC21185@jcartwri.amer.corp.natinst.com>
 <20171005165305.GN25388@kernel.org>
 <20171005182900.GK647@jcartwri.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171005182900.GK647-ew3lsbMjNqt5wtABiV/Xjqyly8cj88Ttqxv4g6HH51o@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Cartwright <julia-acOepvfBmUk@public.gmane.org>
Cc: bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Em Thu, Oct 05, 2017 at 01:29:00PM -0500, Julia Cartwright escreveu:
> On Thu, Oct 05, 2017 at 01:53:05PM -0300, Arnaldo Carvalho de Melo wrote:
> > So __this_cpu_inc() checks preemption but this_cpu_inc() doesn't and
> > thus we're ok here? Or am I getting lost in this maze of defines? :-)
 
> I think I was the one lost in the maze.  You are correct.  Sorry for the
> confusion.
 
> My mind expected that the __ prefixed versions would be the "raw"
> versions that are free of checks, with the checks made in the non
> prefixed versions, but it is the other way around.
 
> I'm happy to accept that the bug is within my mind.

:-) 

Ok, now I'm taking the opportunity to read more about local locks, as
Sebastian thinks are needed in this case, which I'm not entirely
convinced from the discussion that took place here, and as you took part
in that discussion and suggested using the nort variants of
preempt_disable, do you still think this is the way to go?

- Arnaldo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
