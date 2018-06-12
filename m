From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Tue, 12 Jun 2018 05:12:51 -0700
Message-ID: <20180612121251.GC19433@bombadil.infradead.org>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
 <20180612115046.00007213@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180612115046.00007213@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: jackm <jackm@dev.mellanox.co.il>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 12, 2018 at 11:50:46AM +0300, jackm wrote:
> On Fri,  8 Jun 2018 10:42:18 -0700
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > +		rcu_read_lock();
> > +		mad_agent = idr_find(&ib_mad_clients, hi_tid);
> > +		if (mad_agent
> > && !atomic_inc_not_zero(&mad_agent->refcount))
> > +			mad_agent = NULL;
> > +		rcu_read_unlock();
> 
> Hi Matthew,
> 
> I don't see the flow which can explain using atomic_inc_not_zero() here.
> 
> The refcount will go to zero only when unregister_mad_agent() is
> called (code below, see asterisks):
>         idr_lock(&ib_mad_clients);
>  ***    idr_remove(&ib_mad_clients, mad_agent_priv->agent.hi_tid);
>         idr_unlock(&ib_mad_clients);
> 
>         flush_workqueue(port_priv->wq);
>         ib_cancel_rmpp_recvs(mad_agent_priv);
> 
>  ***    deref_mad_agent(mad_agent_priv);
> 		[JPM] The call to idr_find in the interrupt context
> 		would need to occur here for the refcount to have a
> 		possibility of being zero.
> 		Shouldn't idr_find in the interrupt context fail, since
> 		idr_remove has already been invoked?

RCU is tricky.  Here's the flow:

CPU 0		CPU 1
rcu_read_lock();
mad_agent = idr_find(&ib_mad_clients, hi_tid);
		idr_lock(&ib_mad_clients);
		idr_remove(&ib_mad_clients, mad_agent_priv->agent.hi_tid);
		idr_unlock(&ib_mad_clients);
		flush_workqueue(port_priv->wq);
		ib_cancel_rmpp_recvs(mad_agent_priv);
		deref_mad_agent(mad_agent_priv);

Now, you're going to argue that CPU 0 is running in interrupt context, but
with virtualisation, it can have the CPU taken away from it at any time.
This window which looks like a couple of instructions long can actually
be seconds long.

> 	wait_for_completion(&mad_agent_priv->comp);
> 
> The refcount will be able to go to zero only after deref_mad_agent is
> called above.  Before this, however, idr_remove() has been called --
> so, if my understanding is correct, the idr_find call in
> find_mad_agent() should not succeed since the refcount can get to zero
> only AFTER the idr_remove call.
> 
> Could you please explain the flow which can result in idr_find
> succeeding (in the interrupt context) after idr_remove has been invoked
> (in the process context)?  Will idr_find succeed even after
> idr_remove, and only fail after kfree_rcu is invoked as well? (or,
> maybe after some garbage-collection delay?)

Ordering is weird in SMP systems.  You can appear to have causality
violations when you're operating locklessly (and rcu_read_lock()
is essentially lockless).  So we can absolutely observe the store to
agent->refcount before we observe the store to idr->agent.

Documentation/memory-barriers.txt has a LOT more information on this.
