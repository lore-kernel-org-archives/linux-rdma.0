From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Tue, 12 Jun 2018 17:07:39 -0700
Message-ID: <20180613000739.GA32191@bombadil.infradead.org>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
 <20180612203322.GG6314@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180612203322.GG6314@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 12, 2018 at 02:33:22PM -0600, Jason Gunthorpe wrote:
> > @@ -377,13 +378,24 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
> >  		goto error4;
> >  	}
> >  
> > -	spin_lock_irq(&port_priv->reg_lock);
> > -	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
> > +	idr_preload(GFP_KERNEL);
> > +	idr_lock(&ib_mad_clients);
> > +	ret2 = idr_alloc_cyclic(&ib_mad_clients, mad_agent_priv, 0,
> > +			(1 << 24), GFP_ATOMIC);
> 
> I like this series, my only concern is this magic number here, at the
> very least it deserves a big comment explaining why it
> exists..

Yes, you're right.  Maybe something like this ...

/*
 * The mlx4 driver uses the top byte to distinguish which virtual function
 * generated the MAD, so we must avoid using it.
 */
#define AGENT_ID_LIMIT		(1 << 24)

...

	ret2 = idr_alloc_cyclic(&ib_mad_clients, mad_agent_priv, 0,
			AGENT_ID_LIMIT, GFP_ATOMIC);

> Let me see if I can get someone to give it some test time, I assume
> you haven't been able to test it it?

I don't have any IB hardware.  Frankly I'm scared of Infiniband ;-)

> > +#define idr_lock(idr)		xa_lock(&(idr)->idr_rt)
> > +#define idr_unlock(idr)		xa_unlock(&(idr)->idr_rt)
> > +#define idr_lock_irq(idr)	xa_lock_irq(&(idr)->idr_rt)
> > +#define idr_unlock_irq(idr)	xa_unlock_irq(&(idr)->idr_rt)
> > +#define idr_lock_irqsave(idr, flags) \
> > +				xa_lock_irqsave(&(idr)->idr_rt, flags)
> > +#define idr_unlock_irqrestore(idr, flags) \
> > +				xa_unlock_irqrestore(&(idr)->idr_rt, flags)
> > +
> 
> And you are Ok to take these through the rdma tree?

Yes, that's fine with me; I'm not planning on merging any IDR patches
this cycle.  Thanks!
