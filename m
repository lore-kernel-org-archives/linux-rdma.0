From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: qib_lookup_qpn() appears to leak pointer out of rcu_read_unlock()
Date: Wed, 12 Feb 2014 13:50:18 -0800
Message-ID: <20140212215017.GF4250@linux.vnet.ibm.com>
References: <20140212003511.GA27242@linux.vnet.ibm.com>
 <32E1700B9017364D9B60AED9960492BC211F3D24@FMSMSX107.amr.corp.intel.com>
 <20140212145543.GY4250@linux.vnet.ibm.com>
 <32E1700B9017364D9B60AED9960492BC211F3D75@FMSMSX107.amr.corp.intel.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211F3D75-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 12, 2014 at 02:57:14PM +0000, Marciniszyn, Mike wrote:
> BTW, I am considering eliminating the atomic_inc() in favor of widening the scope of the rcu lock expanse.

As long as the newly included code doesn't block, that should work fine.
(If it does block, another option is SRCU.)

							Thanx, Paul

> Mike
> 
> > -----Original Message-----
> > From: Paul E. McKenney [mailto:paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org]
> > Sent: Wednesday, February 12, 2014 9:56 AM
> > To: Marciniszyn, Mike
> > Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Hefty, Sean; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: qib_lookup_qpn() appears to leak pointer out of rcu_read_unlock()
> > 
> > On Wed, Feb 12, 2014 at 01:59:30PM +0000, Marciniszyn, Mike wrote:
> > > > So what am I missing here?
> > > >
> > >
> > > The atomic increment of a reference count:
> > 
> > Got it, thank you, apologies for the noise!
> > 
> > 							Thanx, Paul
> > 
> > > struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn) {
> > >         struct qib_qp *qp = NULL;
> > >
> > >         rcu_read_lock();
> > >         if (unlikely(qpn <= 1)) {
> > >                 if (qpn == 0)
> > >                         qp = rcu_dereference(ibp->qp0);
> > >                 else
> > >                         qp = rcu_dereference(ibp->qp1);
> > >                 if (qp)
> > >                         atomic_inc(&qp->refcount); <--------------------------
> > >         } else {
> > >                 struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
> > >                 unsigned n = qpn_hash(dev, qpn);
> > >
> > >                 for (qp = rcu_dereference(dev->qp_table[n]); qp;
> > >                         qp = rcu_dereference(qp->next))
> > >                         if (qp->ibqp.qp_num == qpn) {
> > >                                 atomic_inc(&qp->refcount); <---------------------
> > >                                 break;
> > >                         }
> > >         }
> > >         rcu_read_unlock();
> > >         return qp;
> > > }
> > >
> > > Mike
> > >
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
