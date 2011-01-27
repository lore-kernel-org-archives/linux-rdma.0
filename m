From: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: Infiniband Shared Memory Segment
Date: Thu, 27 Jan 2011 11:37:58 -0500
Message-ID: <AANLkTik6h8t0+hBzFZ=eWXKiS2kV8CFuODUNCm_-VqR0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I sent this e-mail to the OFED ewg list but I figured someone on the
Linux mailing list might know about this as well, since it's fairly
low level details.

I was hoping someone could answer a few questions for me, or point to
where the answers might be. I dug through the formal IBA specification
V1.2 but could not find the relevant information.

If I run an Infiniband program, say the ibv_rc_pingpong 'test'
program, and look in /proc/<pid>/fd the following file descriptors
appear:

lrwx------ 1 kerrg kerrg 64 Jan 26 13:02 3 -> /dev/infiniband/uverbs0
lr-x------ 1 kerrg kerrg 64 Jan 26 13:02 4 -> infinibandevent:

And if I look in /proc/<pid>/maps:
2b6f3379f000-2b6f337a0000 -w-s 00000000 00:11 7797
 /dev/infiniband/uverbs0

I'm assuming those are file descriptors which are mapped to the HCA
and used to send commands to it. I noticed that the cmd_fd field of
the ibv_context data structure pointed to to fd 3.

What kind of data might be located within the memory pointed to by the
FD? I.e. Could there be configuration information for the connection
and/or HCA? Could there be the data waiting to be sent (although I
don't believe the HCA buffers)? Would it just be the command sent to
the HCA?

Thanks,

Greg Kerr
Northeastern University
High Performance Computing Lab
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
