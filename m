From: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA Programming: Java vs. C
Date: Mon, 24 Nov 2014 22:01:04 +0000 (UTC)
Message-ID: <loom.20141124T224935-43@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello everyone.

I'm a newcomer to the world of InfiniBand and RDMA.
I started to write small programs in C to leverage RDMA features in databases.
I would like now to try out some of my ideas on
benchmarking  tools which are mostly written in Java.
So I was thinking maybe I should migrate to java to void 
reinventing the wheel and ending up writing the whole benchmarks in C by myself. 

So my questions are:

1- Is there any significant difference, performance-wise,
between RDMA programming in Java and C?
2- I have read on some blogs that  JDK has support for OFED 1.5.
Is that true? I'm currently working with OFED 2.3.1, and really do
not know which of the features I'm using are specific to this version.
3- Can you point me to a good starting point (libraries, ....) for
Java RDMA programming. Even a small example would be great.

Thanks. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
