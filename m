From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Wed, 24 Jan 2018 13:51:18 -0800
Message-ID: <20180124215118.GM3741@linux.vnet.ibm.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
 <20180123152142.GB30619@mellanox.com>
 <1516723456.3339.3.camel@wdc.com>
 <20180123220337.GE3741@linux.vnet.ibm.com>
 <1516746545.3339.46.camel@wdc.com>
 <20180123225054.GK3741@linux.vnet.ibm.com>
 <1516748369.3339.59.camel@wdc.com>
 <20180124064337.GB1393@mtr-leonro.local>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180124064337.GB1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 24, 2018 at 08:43:37AM +0200, Leon Romanovsky wrote:
> On Tue, Jan 23, 2018 at 10:59:30PM +0000, Bart Van Assche wrote:
> > On Tue, 2018-01-23 at 14:50 -0800, Paul E. McKenney wrote:
> > >
> > >     rcu: Fix init_rcu_head() comment.
> > >
> > >     The current (and implicit) comment header for init_rcu_head() and
> > >     destroy_rcu_head() incorrectly says that they are not needed for
> > >     statically allocated rcu_head structures.  This commit therefore
> > >     fixes this comment.
> > >
> > >     Reported-by: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
> > >     Signed-off-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > >
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index 043d04784675..36360d07f25b 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -214,10 +214,12 @@ do { \
> > >  #endif
> > >
> > >  /*
> > > - * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
> > > - * initialization and destruction of rcu_head on the stack. rcu_head structures
> > > - * allocated dynamically in the heap or defined statically don't need any
> > > - * initialization.
> > > + * The init_rcu_head_on_stack() and destroy_rcu_head_on_stack() calls
> > > + * are needed for dynamic initialization and destruction of rcu_head
> > > + * on the stack, and init_rcu_head()/destroy_rcu_head() are needed for
> > > + * dynamic initialization and destruction of statically allocated rcu_head
> > > + * structures.  However, rcu_head structures allocated dynamically in the
> > > + * heap don't need any initialization.
> > >   */
> > >  #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> > >  void init_rcu_head(struct rcu_head *head);
> >
> > Thanks!
> >
> > Feel free to add:
> >
> > Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> 
> Paul,
> 
> Are you going to send it through your tree?

It is currently queued for v4.17 -- didn't seem horribly urgent.

> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied, thank you!

							Thanx, Paul

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
