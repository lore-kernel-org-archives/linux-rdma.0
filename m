From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: ibv_fork_init() question
Date: Mon, 27 Feb 2012 13:54:53 -0600
Message-ID: <4F4BDF8D.7070902@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

I'm experimenting with doing RDMA operations from a child process and I have a question.  My application calls 
ibv_fork_init() at startup (first thing in main())  and it succeeds, and I see, for instance, that libibverbs has 
initialized mm_root.  Next my application registers page-aligned memory that is 8KB in size.  The memory was allocated 
with memalign().  Then the app sets up a connection to an RDMA peer.  Next the application calls fork().  The parent 
does a wait() and the child does an rdma read operation into this registered memory from a valid mr of the peer.  The 
read succeeds from the rdma device perspective.  But when the child process tries to read the memory (to verify the rdma 
operation worked), I get a seg fault.

Q: Am I doing something incorrect here?  I can't find much documentation on how this all should work.

Thanks!

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
