From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC+PATCH] Infiniband hfi1 + PREEMPT_RT_FULL issues
Date: Tue, 26 Sep 2017 17:11:56 -0400
Message-ID: <20170926171156.6f7e3b4b@vmware.local.home>
References: <20170925144949.GP29668@kernel.org>
        <20170925161528.52d34769@vmware.local.home>
        <20170926131529.GB25735@kernel.org>
        <32E1700B9017364D9B60AED9960492BC3441B8C5@fmsmsx120.amr.corp.intel.com>
        <20170926182800.GA10741@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20170926182800.GA10741@kernel.org>
Sender: linux-rt-users-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>, "Luick, Dean" <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, "Wan, Kaike" <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, "Sanchez, Sebastian" <sebastian.sanchez@intel.com>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 26 Sep 2017 15:28:00 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> So what happens is that infrastructure in the rt patch eventually lands
> upstream, then this difference ceases to exist.
> 
> Steven, are there plans for local locks to go upstream?
> 

Yes, but they don't make sense unless we get PREEMPT_RT (sleeping
spinlocks) upstream. Otherwise, they will just be another name for
preempt_disable().

That said, there is some rational for getting them upsteam before
sleeping spinlocks, and that is to annotate what a preempt_disable() is
trying to protect.

-- Steve
