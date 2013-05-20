From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rockets feedbacks?
Date: Mon, 20 May 2013 20:39:20 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD295BB@ORSMSX109.amr.corp.intel.com>
References: <CAJZOPZJXPHVe1qHwwqsV-pFKruv6kPcZ_GBnFE7m8EvmsWPPvg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736FD29531@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZKya_2jiNP73SffZ-0J415Zw5FU_usOjsewfUMR6YAe7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKya_2jiNP73SffZ-0J415Zw5FU_usOjsewfUMR6YAe7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So if you were pushing these private conversations to linux-rdma, more
> have been known on rsockets for the benefit of all... oh well. I think
> you mentioned something re Intel HPC group, or I am wrong?

rsockets will continue to be supported by myself and Intel going forward.  The rsocket work originated from HPC related work done that I was doing with Xeon Phi, and targeted Intel MPI and OSU MPI as its initial application.  The Xeon Phi processors are slower than the traditional Xeon cores; I believe I mentioned that this was a problem, since the socket API requires data copies in practice.  So, extensions to the rsocket API is needed to support zero-copy data transfers.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
