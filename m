From: akalia-OM76b2Iv3yLQjUSlxSEPGw@public.gmane.org
Subject: RDMA reads/writes per second
Date: Mon, 28 Oct 2013 20:05:12 -0400
Message-ID: <7eec6832a608f6a78639c833af1473fd.squirrel@webmail.andrew.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi.

I'm measuring the number of RDMA reads and writes per second. In my
experimental setup I have one server connected to several clients and I
want to extract the maximum IOs from the server. I had two questions
regarding this:

1. What is the expected number of small (16 byte values) RDMA reads for
ConnectX 3 cards? Currently, I've seen a maximum of 9 million reads per
second with my code. However, several websites report much higher messages
per second. For example,
http://www.marketwatch.com/story/mellanox-fdr-56gbs-infiniband-solutions-deliver-leading-application-performance-and-scalability-2013-06-17
talks about 137 messages per second.
http://www.mellanox.com/pdf/products/oem/RG_HP.pdf reports 40 million MPI
messages per second. What sort optimizations could I do to reach similar
numbers?

2. The number of IOPS drops when the size of the registered region
increases. For a 1 KB registered region, the maximum random reads per
second that the server can provide is around 9 million. It drops to 2
million when I increase the registered size to 1 GB.
What is the reason behind this? Does the HCA perform caching for reads?
That could be a possible explanation. Another possible reason is TLB
misses in the HCA.
Further, I'm seeing even greater variation with writes. I can think of 2
possible explanations for that:
a. As my writes are to random locations, there could be more TLB misses
for larger registered regions.
b. The HCA buffers writes locally and does not transfer them into the CPU
memory immediately (this can be done only for small registered regions).

Thanks for your time!

Anuj Kalia,
Carnegie Mellon University

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
