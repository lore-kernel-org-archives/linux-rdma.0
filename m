From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: how to debug (mlx4) CQ overrun
Date: Fri, 23 Sep 2011 14:15:30 -0700
Message-ID: <CABgxfbHAMu9Lvd1j8nJF8DdTk0UYQOuxN70Z73XJv3VuLSk7-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have a test program that does RDMA read-write as the following:

node A: server listens and handles connection requests
               setup a piece of memory initialized to "0"
node B: two processes parent & child

child:
  1. setup a new channel with server, including a CQ with 1024 entries
                (ibv_create_cq(ctx, 1024, NULL, channel, 0);)
  2. RDMA sequential write (8192 bytes a time) to server memory
  4. sync with parent

parent:
   1. setup the new channel with server, including a CQ with 1024 entries
                  (ibv_create_cq(ctx, 1024, NULL, channel, 0);)
    3. RDMA sequential read (8192 byes a time) to the same piece of
memory from server
                 - check the buffer contents.
                 - if memory content is still zero, re-read
    4. sync with child

The parent hangs (but child finishes its write) after the following
pops up in /var/log/messages:
 mlx4_core 0000:06:00.0: CQ overrun on CQN 000087

I have my own counters that restrict the read (and write) to 512 max.
Both write and read are blocking (i.e. cq is polled after each
read/write). I suspect I do not have the cq poll logic correct. The
question here is .. is there any diag tool available to check on the
internal counters (and /or states) of ibverbs library and/or kernel
drivers (to help RDMA applications debug) ? In my case, it hangs
around 14546 block (i.e. after 14546*8192 byes).

Thanks,
Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
