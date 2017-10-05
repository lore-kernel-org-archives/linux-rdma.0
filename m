From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Thu, 5 Oct 2017 15:15:17 -0400
Message-ID: <20171005151517.0c948504@gandalf.local.home>
References: <20171003154920.31566-1-acme@kernel.org>
        <20171003154920.31566-2-acme@kernel.org>
        <20171005141744.GC21185@jcartwri.amer.corp.natinst.com>
        <20171005165305.GN25388@kernel.org>
        <20171005182900.GK647@jcartwri.amer.corp.natinst.com>
        <20171005185330.GP25388@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171005185330.GP25388@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Julia Cartwright <julia@ni.com>, bigeasy@linutronix.de, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, 5 Oct 2017 15:53:30 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Thu, Oct 05, 2017 at 01:29:00PM -0500, Julia Cartwright escreveu:
> > On Thu, Oct 05, 2017 at 01:53:05PM -0300, Arnaldo Carvalho de Melo wrote:  
> > > So __this_cpu_inc() checks preemption but this_cpu_inc() doesn't and
> > > thus we're ok here? Or am I getting lost in this maze of defines? :-)  
>  
> > I think I was the one lost in the maze.  You are correct.  Sorry for the
> > confusion.  
>  
> > My mind expected that the __ prefixed versions would be the "raw"
> > versions that are free of checks, with the checks made in the non
> > prefixed versions, but it is the other way around.  
>  
> > I'm happy to accept that the bug is within my mind.  
> 
> :-) 
> 
> Ok, now I'm taking the opportunity to read more about local locks, as
> Sebastian thinks are needed in this case, which I'm not entirely
> convinced from the discussion that took place here, and as you took part
> in that discussion and suggested using the nort variants of
> preempt_disable, do you still think this is the way to go?
>

Looking at
http://lkml.kernel.org/r/32E1700B9017364D9B60AED9960492BC3441B3BD@fmsmsx120.amr.corp.intel.com

I'm thinking it is fine to convert the preempt_disable() just to
preempt_disable_nort() (where it's a nop when PREEMPT_RT is enabled).
In the mentioned thread, the counters do not seem to be important to
the current CPU, just that they get incremented by "some" CPU.

Adding back the patch for Mike:

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 615be68e40b3..3a30bde9a07b 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1421,7 +1421,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 
 	/* there is enough room */
 
-	preempt_disable();
+	preempt_disable_nort();
 	this_cpu_inc(*sc->buffers_allocated);
 
 	/* read this once */
diff --git a/drivers/infiniband/hw/hfi1/pio_copy.c b/drivers/infiniband/hw/hfi1/pio_copy.c
index 03024cec78dd..c3f48f705c97 100644
--- a/drivers/infiniband/hw/hfi1/pio_copy.c
+++ b/drivers/infiniband/hw/hfi1/pio_copy.c
@@ -162,7 +162,7 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 
 	/* finished with this buffer */
 	this_cpu_dec(*pbuf->sc->buffers_allocated);
-	preempt_enable();
+	preempt_enable_nort();
 }
 
 /*
@@ -753,5 +753,5 @@ void seg_pio_copy_end(struct pio_buf *pbuf)
 
 	/* finished with this buffer */
 	this_cpu_dec(*pbuf->sc->buffers_allocated);
-	preempt_enable();
+	preempt_enable_nort();
 }


The above will only disable preemption when PREEMPT_RT is not enabled.
Honestly, if it's just an optimization, and the counters are not that
important, do we care on non PREEMPT_RT to disable preemption, and can
we just remove the preempt_disable() totally? Depending if it triggers
warnings using this_cpu_inc/dec() from preempt enabled regions.

-- Steve
