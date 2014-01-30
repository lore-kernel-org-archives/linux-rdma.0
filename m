From: Hannes Weisbach <hannes.weisbach-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Subject: RDMA read does not update local memory
Date: Thu, 30 Jan 2014 19:45:31 +0100
Message-ID: <03D88C61-964C-4FDE-B072-C96AC658701F@tu-dresden.de>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello all,

I=92m developing an (userspace) RDMA-application under Linux and came
across a problem, I=92m not able to solve.

On machine A I had a chunk of memory registered with rdma_reg_read(),
so others can read from that memory later.
 Machine B has memory which is also registered with rdma_reg_read().
Machine B tells machine A about that memory and the rkey.
 Machine A rdma_post_read()s then from that memory on machine B in
it=92s own memory.  The problem now is, that - although no error is
reported - the contents of machine A=92s memory does not change.  I
memset() it to 0x55 before the rdma_post_read() for debugging
purposes and instead of having the contents I expect (an ASCII
string), the memory is still 0x55 after the work completion is
signaled.

Thus, I=92ve allocated different chunks of memory using malloc() and
posix_memalign() with different sizes and registered them with
rdma_reg_read(), to see if that makes a difference.  The
rdma_post_read() works on all tested memory, except one chunk.

I don=92t know what is different about that memory, where my mistake
might be or how to debug this.

Please note, that I check all return values for errors (there are
none) and also the work completion reports IBV_SUCCESS.
I hope you can give me some hints on how to proceed.
I apologize if my problem description was too brief; please ask for
details if I left important information out.

Best regards,
Hannes Weisbach--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
