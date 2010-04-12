From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: IPoIB performance benchmarking
Date: Mon, 12 Apr 2010 12:35:09 -0600
Message-ID: <4BC367DD.30606@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Brian Haymore <brian.haymore-wbocuHtxKic@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm trying to do some performance benchmarking of IPoIB on a DDR IB 
cluster, and I am having a hard time understanding what I am seeing.

When I do a simple netperf, I get results like these:

[root@gateway3 ~]# netperf -H 192.168.23.252
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.23.252 
(192.168.23.252) port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  65536  65536    10.01    4577.70


Which is disappointing since it is simply two DDR IB-connected nodes 
plugged in to a DDR switch - I would expect much higher throughput than 
that. When I do a test with ibv_srq_pingpong (using the same message 
size reported above), here's what I get:

[root@gateway3 ~]# ibv_srq_pingpong 192.168.23.252 -m 4096 -s 65536
   local address:  LID 0x012b, QPN 0x000337, PSN 0x19cc85
   local address:  LID 0x012b, QPN 0x000338, PSN 0x956fc2
...
[output omitted]
...
   remote address: LID 0x0129, QPN 0x00032e, PSN 0x891ce3
131072000 bytes in 0.08 seconds = 12763.08 Mbit/sec
1000 iters in 0.08 seconds = 82.16 usec/iter

Which is much closer to what I would expect with DDR.

The MTU on both of the QLogic DDR HCAs is set to 4096, as it is on the 
QLogic switch.

I know the above is not completely apples-to-apples, since the 
ibv_srq_pingpong is layer2 and is using 16 QPs. So I ran it again with 
only a single QP, to make it more roughly equivalent of my single-stream 
netperf test, and I still get almost double the performance:

[root@gateway3 ~]# ibv_srq_pingpong 192.168.23.252 -m 4096 -s 65536 -q 1
   local address:  LID 0x012b, QPN 0x000347, PSN 0x65fb56
   remote address: LID 0x0129, QPN 0x00032f, PSN 0x5e52f9
131072000 bytes in 0.13 seconds = 8323.22 Mbit/sec
1000 iters in 0.13 seconds = 125.98 usec/iter


Is there something that I am not understanding, here? Is there any way 
to make single-stream TCP IPoIB performance better than 4.5Gb/s on a DDR 
network? Am I just not using the benchmarking tools correctly?

Thanks,

Tom

-- 

--------------------------------------------------------------------
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
