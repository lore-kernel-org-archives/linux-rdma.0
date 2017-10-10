From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 2/2] IB/hfi1: Handle packets in the theaded handler only
Date: Tue, 10 Oct 2017 16:15:29 -0300
Message-ID: <20171010191529.GP28623@kernel.org>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-3-acme@kernel.org>
 <3003fbfd-6d34-a968-1264-7c16580d5ce6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3003fbfd-6d34-a968-1264-7c16580d5ce6@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: bigeasy@linutronix.de, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, Julia Cartwright <julia@ni.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

Em Tue, Oct 10, 2017 at 03:06:00PM -0400, Dennis Dalessandro escreveu:
> On 10/3/2017 11:49 AM, Arnaldo Carvalho de Melo wrote:
> > Cc: Clark Williams <williams@redhat.com>
> > Cc: Dean Luick <dean.luick@intel.com>
> > Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: Julia Cartwright <julia@ni.com>
> > Cc: Kaike Wan <kaike.wan@intel.com>
> > Cc: Leon Romanovsky <leonro@mellanox.com>
> > Cc: linux-rdma@vger.kernel.org
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>
> > Cc: Sebastian Sanchez <sebastian.sanchez@intel.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Mike has been working with these developers off list and has provided a
> slightly different approach. I'm going to let them drive that before I add
> an RB/Ack here.

This may not even be needed, i.e. Sebastian Siewior said that recent
rt patches already identify the way this driver uses threaded interrupts
and automagically does the right thing, Sebastian?

He mentioned this in this message:

https://marc.info/?l=linux-rt-users&m=150722087514307&w=2

But I replied to Mike and don't recall getting an answer to my last
question.

Meanwhile a kernel with these two patches survived the original bug
reported at Red Hat's bugzilla.

- Arnaldo
