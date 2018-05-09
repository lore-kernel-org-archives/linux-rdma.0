From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] net/mlx5: Fix mlx5_get_vector_affinity function
Date: Wed, 9 May 2018 15:19:06 -0700
Message-ID: <20180509221906.GA7548@roeck-us.net>
References: <20180505143838.GA12621@roeck-us.net>
 <alpine.DEB.2.21.1805060929540.1685@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1805060929540.1685@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 06, 2018 at 09:33:26AM +0200, Thomas Gleixner wrote:
> On Sat, 5 May 2018, Guenter Roeck wrote:
> 
> > On Thu, Apr 12, 2018 at 09:49:11AM +0000, Israel Rukshin wrote:
> > > Adding the vector offset when calling to mlx5_vector2eqn() is wrong.
> > > This is because mlx5_vector2eqn() checks if EQ index is equal to vector number
> > > and the fact that the internal completion vectors that mlx5 allocates
> > > don't get an EQ index.
> > > 
> > > The second problem here is that using effective_affinity_mask gives the same
> > > CPU for different vectors.
> > > This leads to unmapped queues when calling it from blk_mq_rdma_map_queues().
> > > This doesn't happen when using affinity_hint mask.
> > > 
> > Except that affinity_hint is only defined if SMP is enabled. Without:
> > 
> > include/linux/mlx5/driver.h: In function ‘mlx5_get_vector_affinity_hint’:
> > include/linux/mlx5/driver.h:1299:13: error:
> >         ‘struct irq_desc’ has no member named ‘affinity_hint’
> > 
> > Note that this is the only use of affinity_hint outside kernel/irq.
> > Don't other drivers have similar problems ?
> 
> Aside of that.
> 
> > >  static inline const struct cpumask *
> > > -mlx5_get_vector_affinity(struct mlx5_core_dev *dev, int vector)
> > > +mlx5_get_vector_affinity_hint(struct mlx5_core_dev *dev, int vector)
> > >  {
> > > -	const struct cpumask *mask;
> > >  	struct irq_desc *desc;
> > >  	unsigned int irq;
> > >  	int eqn;
> > >  	int err;
> > >  
> > > -	err = mlx5_vector2eqn(dev, MLX5_EQ_VEC_COMP_BASE + vector, &eqn, &irq);
> > > +	err = mlx5_vector2eqn(dev, vector, &eqn, &irq);
> > >  	if (err)
> > >  		return NULL;
> > >  
> > >  	desc = irq_to_desc(irq);
> > > -#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
> > > -	mask = irq_data_get_effective_affinity_mask(&desc->irq_data);
> > > -#else
> > > -	mask = desc->irq_common_data.affinity;
> > > -#endif
> > > -	return mask;
> > > +	return desc->affinity_hint;
> 
> NAK.
> 

The offending patch is upstream, breaking non-SMP test builds, and I have
not seen any feedback from the submitter. Any suggestion how to proceed ?

Guenter

> Nothing in regular device drivers is supposed to ever fiddle with struct
> irq_desc. The existing code is already a violation of that rule and needs
> to be fixed, but not in that way.
> 
> The logic here is completely screwed. affinity_hint is set by the driver,
> so the driver already knows what it is. If the driver does not set it, then
> the thing is NULL.
> 
> Thanks,
> 
> 	tglx
> 
