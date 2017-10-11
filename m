From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Use preempt_{dis,en}able_nort()
Date: Wed, 11 Oct 2017 10:43:00 -0300
Message-ID: <20171011134300.GS28623@kernel.org>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-2-acme@kernel.org>
 <1d06a3da-426f-c887-1da7-64b760c53425@intel.com>
 <20171010190218.GN28623@kernel.org>
 <20171011110355.ykyr7t6x5qy5gc3u@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171011110355.ykyr7t6x5qy5gc3u@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

Em Wed, Oct 11, 2017 at 01:03:55PM +0200, Sebastian Andrzej Siewior escreveu:
> On 2017-10-10 16:02:18 [-0300], Arnaldo Carvalho de Melo wrote:
> > 
> > Right, and so far there were no strong objection for this one to be
> > merged on the -rt tree, Sebastian, can you do it please? Adding Dennis'
> > reviewed-by, one of maintainers for this driver, ok?
> 
> I am still curious about the performance improvement that is with this
> preempt disable section compared to without it compared to !PREEMPT
> kernel..
> If that is important then migrate_disable() would do that on RT.

I can try that

> I guess that there were no splat with CONFIG_DEBUG_PREEMPT ?

I haven't tried that

> If that is all okay, please resend the patch with the explanation why
> this preempt_disable() does not matter and I pick it up.

I can just pick the explanation given by the authors and stash it there,
I guess.
 
> > > tree? Anyway, for this patch:
> > > 
> > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> 
> Sebastian
