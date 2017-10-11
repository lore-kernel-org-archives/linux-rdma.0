From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 2/2] IB/hfi1: Handle packets in the theaded handler only
Date: Wed, 11 Oct 2017 10:42:02 -0300
Message-ID: <20171011134202.GR28623@kernel.org>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-3-acme@kernel.org>
 <3003fbfd-6d34-a968-1264-7c16580d5ce6@intel.com>
 <20171010191529.GP28623@kernel.org>
 <20171011104456.mlewocqc6ghi3fev@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171011104456.mlewocqc6ghi3fev@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, Julia Cartwright <julia@ni.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
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

Ok, I'll try backporting that change and will try without 2/2.

- Arnaldo
