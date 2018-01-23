From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Tue, 23 Jan 2018 14:03:37 -0800
Message-ID: <20180123220337.GE3741@linux.vnet.ibm.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
 <20180123152142.GB30619@mellanox.com>
 <1516723456.3339.3.camel@wdc.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516723456.3339.3.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 04:04:17PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-23 at 08:21 -0700, Jason Gunthorpe wrote:
> > /*
> >  * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
> >  * initialization and destruction of rcu_head on the stack. rcu_head structures
> >  * allocated dynamically in the heap or defined statically don't need any
> >  * initialization.
> >  */
> > 
> > The commit that introduced init_rcu_head is
> > 546a9d8519ed137b2804a3f5a3659003039dd49c which suggests it exists only
> > to help the slab allocators, although curiously the allocators never
> > call it these days..
> > 
> > Maybe Paul can confirm?
> 
> It would be great if Paul could provide feedback. The comment in
> include/linux/rcupdate.h seems to contradict the following paragraph from
> Documentation/RCU/Design/Requirements/Requirements.html for statically
> allocated objects:
> 
> 	The corresponding <tt>rcu_head</tt> structures that are
> 	dynamically allocated are automatically tracked, but
> 	<tt>rcu_head</tt> structures allocated on the stack
> 	must be initialized with <tt>init_rcu_head_on_stack()</tt>
> 	and cleaned up with <tt>destroy_rcu_head_on_stack()</tt>.
> 	Similarly, statically allocated non-stack <tt>rcu_head</tt>
> 	structures must be initialized with <tt>init_rcu_head()</tt>
> 	and cleaned up with <tt>destroy_rcu_head()</tt>.

And this is the intent.  What breaks when you do that?

							Thanx, Paul

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
