From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 2/2] IB/hfi1: Handle packets in the theaded handler only
Date: Thu, 5 Oct 2017 18:27:31 +0200
Message-ID: <20171005162730.o4klsmkdcx6xr73g@linutronix.de>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-3-acme@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171003154920.31566-3-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Julia Cartwright <julia@ni.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On 2017-10-03 12:49:20 [-0300], Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> The hfi1 driver calls request_threaded_irq with two parameters:
> 
>       handler = receive_context_interrupt;
>       thread = receive_context_thread;
>       request_threaded_irq(me->msix.vector, handler, thread, 0, me->name, arg);
> 
> And tries to process packets on the hard irq one, receive_context_interrupt(),
> only waking up the thread (returning IRQ_WAKE_THREAD) when some threshold is
> crossed in the number of packets available in the NIC, trying to balance
> latency and bandwidth.
> 
> But in a CONFIG_PREEMPT_RT_FULL kernel it ends up calling spin locks from the
> hard irq handler (receive_context_interrupt) which causes BUGs like this:

If I am not mistaken current devel-tree of RT (and a few releases before
that) handle that case correctly and force-thread both threads.

Sebastian
