From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Tue, 23 Jan 2018 14:50:54 -0800
Message-ID: <20180123225054.GK3741@linux.vnet.ibm.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
 <20180123152142.GB30619@mellanox.com>
 <1516723456.3339.3.camel@wdc.com>
 <20180123220337.GE3741@linux.vnet.ibm.com>
 <1516746545.3339.46.camel@wdc.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516746545.3339.46.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 10:29:06PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-23 at 14:03 -0800, Paul E. McKenney wrote:
> > On Tue, Jan 23, 2018 at 04:04:17PM +0000, Bart Van Assche wrote:
> > > It would be great if Paul could provide feedback. The comment in
> > > include/linux/rcupdate.h seems to contradict the following paragraph from
> > > Documentation/RCU/Design/Requirements/Requirements.html for statically
> > > allocated objects:
> > > 
> > > 	The corresponding <tt>rcu_head</tt> structures that are
> > > 	dynamically allocated are automatically tracked, but
> > > 	<tt>rcu_head</tt> structures allocated on the stack
> > > 	must be initialized with <tt>init_rcu_head_on_stack()</tt>
> > > 	and cleaned up with <tt>destroy_rcu_head_on_stack()</tt>.
> > > 	Similarly, statically allocated non-stack <tt>rcu_head</tt>
> > > 	structures must be initialized with <tt>init_rcu_head()</tt>
> > > 	and cleaned up with <tt>destroy_rcu_head()</tt>.
> > 
> > And this is the intent.  What breaks when you do that?
> 
> Hello Paul,
> 
> I inserted a init_rcu_head() call in the ib_srpt driver for a dynamically
> allocated object and that triggers a linker error with
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y. I just verified that the ib_srpt driver still
> works fine if the init_rcu_head() calls are removed from that driver. However,
> the following part of the comment in include/linux/rcupdate.h above
> init_rcu_head() seems confusing to me: "rcu_head structures allocated
> dynamically in the heap or defined statically don't need any initialization."
> Should that comment perhaps be updated such that it matches
> Documentation/RCU/Design/Requirements/Requirements.html?

Good catch!!!  How about the patch below?

							Thanx, Paul

------------------------------------------------------------------------

commit 2ccdd2a8f0ba33b71dab24da408fda79ed2ee063
Author: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Tue Jan 23 14:48:33 2018 -0800

    rcu: Fix init_rcu_head() comment.
    
    The current (and implicit) comment header for init_rcu_head() and
    destroy_rcu_head() incorrectly says that they are not needed for
    statically allocated rcu_head structures.  This commit therefore
    fixes this comment.
    
    Reported-by: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
    Signed-off-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 043d04784675..36360d07f25b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -214,10 +214,12 @@ do { \
 #endif
 
 /*
- * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
- * initialization and destruction of rcu_head on the stack. rcu_head structures
- * allocated dynamically in the heap or defined statically don't need any
- * initialization.
+ * The init_rcu_head_on_stack() and destroy_rcu_head_on_stack() calls
+ * are needed for dynamic initialization and destruction of rcu_head
+ * on the stack, and init_rcu_head()/destroy_rcu_head() are needed for
+ * dynamic initialization and destruction of statically allocated rcu_head
+ * structures.  However, rcu_head structures allocated dynamically in the
+ * heap don't need any initialization.
  */
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
 void init_rcu_head(struct rcu_head *head);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
