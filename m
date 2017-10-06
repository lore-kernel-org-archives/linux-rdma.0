From: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Fri, 6 Oct 2017 11:23:30 +0200
Message-ID: <20171006092329.jkx33hgw3z7bqcnp@linutronix.de>
References: <20170925144949.GP29668@kernel.org>
 <20170925211447.GL29872@jcartwri.amer.corp.natinst.com>
 <32E1700B9017364D9B60AED9960492BC3441B3BD@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3441B3BD@fmsmsx120.amr.corp.intel.com>
Sender: linux-rt-users-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Julia Cartwright <julia@ni.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>, "Luick, Dean" <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, "Wan, Kaike" <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, "Sanchez, Sebastian" <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 2017-09-26 14:10:52 [+0000], Marciniszyn, Mike wrote:
> > My first question would be: is disabling preemption here really
> > necessary?
> > 
> 
> The motivation for the preempt manipulation has nothing to do with the counter.
> 
> The buffer allocation returns a set of ringed write-combining 64B MMIO buffers.   The allocate lock is then dropped right after allocation to allow parallel allocates.
> 
> The hardware keeps track of the buffer fill across multiple CPUs, so that after the oldest buffer is copied the ring is advanced.
> 
> The idea was to minimize the time from the drop of the allocate lock to the end of the copy to insure the highest rate of copy to the ring from multiple cores.

So on -RT we would like to get rid of that preempt_disable() section. Do
you have any numbers that say that this does any good?
If so, by how much and how much does is differ compared to a !PREEMPT
kernel if I may ask.

Sebastian
