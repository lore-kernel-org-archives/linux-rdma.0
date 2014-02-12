From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: qib_lookup_qpn() appears to leak pointer out of rcu_read_unlock()
Date: Tue, 11 Feb 2014 16:35:11 -0800
Message-ID: <20140212003511.GA27242@linux.vnet.ibm.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello!

The qib_lookup_qpn() function does RCU pointer traversals within RCU
read-side critical sections as required, but the qp pointer is returned
from this function after it does rcu_read_unlock().  One of the callers,
qib_rcv_hdrerr(), dereferences this pointer upon return.

This appears to me to be a bug.  From what I can see, the structure
pointed to by qp could be freed immediately after the rcu_read_unlock(),
which would result in a SEGV when qib_rcv_hdrerr() does its later
spin_lock(&qp->r_lock).

So what am I missing here?

							Thanx, Paul

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
