From: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: IBV Test Program
Date: Tue, 29 Mar 2011 12:48:42 -0400
Message-ID: <201103291248.42710.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, 

I've tried asking this question in a few different places with no luck, so I'm 
hoping you folks can help me. I'm an undergraduate research assistant learning 
how to use verbs and I had a question.

I want to modify rc_pingpong.c to loop and basically send data between the two 
nodes multiple times, instead of just once. The first time through, it 
successfuly completes the transmission. On the next iteration the call to 
ibv_post_recv fails.

The source code is here: 
http://pastebin.com/1mEu9x4f (server)
http://pastebin.com/k1NKdCSn (client)

Please forgive the debug code scattered in there.

I'm pretty sure it must be a simple problem, I just don't know what the 
problem is.  I can't imagine the queue overflowing after a second 
ibv_post_recv.

The relevant changes are around line 769.

-- 
Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
