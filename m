From: Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Performance of RDMA atomic CS and FA over InfiniBand
Date: Sun, 16 Apr 2017 23:59:12 -0400
Message-ID: <1E0007DB-A0F7-4D37-B604-C57BB4653E51@umich.edu>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

I have a question regarding performance of RDMA atomic operations (i.e., =
compare-and-swap (CS) and fetch-and-add (FA)).

I have been working on a project that requires data manipulation using =
RDMA atomic operations on 64-bit data objects.
When I tested two scenarios:
	(1) multiple threads concurrently perform CS on data objects. =
each thread only touches objects it owns. each CS operation always =
succeeds.
	(2) multiple threads concurrently perform FA on data objects. =
each thread only touches objects it owns. each FA operation always =
succeeds.

I expected (2) to perform better as I thought FA is faster operation =
than CS, but surprisingly (1) demonstrated better latency and throughput =
than (2) with about 10~20% margin.
I measured the latency of each operation by calculating the time =
difference between making ibv_post_send() call and receiving its work =
completion via ibv_poll_cq().

Can CS be actually faster than FA? or could it be a hardware-specific =
issue (we have Mellanox HCAs in our cluster) or more likely to be an =
implementation problem of my own?
Any help would be greatly appreciated and I am more than happy to =
provide any extra information necessary to answer this question.

Thanks,
Dong Young

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
