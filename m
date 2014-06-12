From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Comparison of RDMA read and write performance
Date: Thu, 12 Jun 2014 15:22:28 -0400
Message-ID: <CADPSxAjHctp6qG9n6E7pwiXEVYM6fiaqFnbEwfMFD6mAwue+jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

While working with RDMA, I have consistently observed that RDMA write
performance is significantly larger than RDMA read performance.

My experimental setup is the following. I use several "client"
machines to issue RDMA operations to one "server" machine, and I
record the total operations/second across the client machines. My goal
is to calculate the RDMA rate supported by the server machine's RDMA
adapter. I use small-sized transfers (around 64 bytes) and reliable
transport (RC).

Here are the approximate numbers (million operations per second) that
I get for two cards.

ConnectX-3, 353A with PCIe 2.0 x8: 20 Mops READ, 26 Mops WRITE
ConnectX-3, 313A (RoCE) with PCIe 2.0 x8: 20 Mops READ, 26 Mops WRITE
ConnectX-3, 354A with PCIe 3.0 x8: 23 Mops READ, 35 Mops WRITE

The WRITE message rate for the PCIe 3.0 system matches with the
advertized 35 million/second message rate for ConnectX-3 cards, but
the READ throughput is significantly smaller.

I have some adhoc explanations for this observation:

1. http://pdf.aminer.org/000/344/730/pvfs_over_infiniband_design_and_performance_evaluation.pdf:
this is a decade old paper, but its Figure 5 shows that writes
outperform reads.

2. PCIe write operations (posted) are cheaper than PCIe read
operations (non-posted), so this might help RDMA writes.

3. The number of oustanding RDMA reads on any queue pair is small (at
most 16 for CX-3). This reduces RDMA read performance.

However, none of these is completely convincing. I wonder if someone
else in the community has observed this or has a better explanation.

Although I have tried improving my RDMA-read code in many ways, and my
numbers match the ones in FaRM (
https://www.usenix.org/system/files/conference/nsdi14/nsdi14-paper-dragojevic.pdf),
I am also interested if someone has observed higher RDMA read
performance with these cards.

The advertized performance of Connect-IB is 137 million RDMA writes
per second. Is there an advertized number for RDMA reads per second?

Thanks and regards,
Anuj Kalia
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
