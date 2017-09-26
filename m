From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Tue, 26 Sep 2017 15:28:00 -0300
Message-ID: <20170926182800.GA10741@kernel.org>
References: <20170925144949.GP29668@kernel.org>
 <20170925161528.52d34769@vmware.local.home>
 <20170926131529.GB25735@kernel.org>
 <32E1700B9017364D9B60AED9960492BC3441B8C5@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3441B8C5@fmsmsx120.amr.corp.intel.com>
Sender: linux-rt-users-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>, "Luick, Dean" <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, "Wan, Kaike" <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, "Sanchez, Sebastian" <sebastian.sanchez@intel.com>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Em Tue, Sep 26, 2017 at 05:55:45PM +0000, Marciniszyn, Mike escreveu:
> > > No, the correct solution is to convert the preempt_disable into a
> > > local_lock(), which will be a preempt_disable when PREEMPT_RT is not
> > > set. Look for other patches that convert preempt_disable() into
> > > local_lock()s for examples.
> > 
> > Thanks, I had seen a patch patch by Sebastian for random.c doing that,
> > will continue in that direction.
> > 
> 
> I'm assuming you want to end up with common driver code base?
> 
> Will there eventually be a wrapper upstream to allow that?
> 
> Or will the rt patch handle those issues?

So what happens is that infrastructure in the rt patch eventually lands
upstream, then this difference ceases to exist.

Steven, are there plans for local locks to go upstream?

Well, back to trying to learn about them and use in this case to see how
it ends up...

- Arnaldo
