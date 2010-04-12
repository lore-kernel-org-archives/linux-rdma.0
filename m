From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: IPoIB performance benchmarking
Date: Mon, 12 Apr 2010 15:25:30 -0700
Message-ID: <alpine.LFD.1.10.1004121502340.21537@topaz.mv.qlogic.com>
References: <4BC367DD.30606@utah.edu> <alpine.LFD.1.10.1004121317270.21537@topaz.mv.qlogic.com> <4BC3882B.4070200@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BC3882B.4070200-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Dale Haymore <brian.haymore-wbocuHtxKic@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 12 Apr 2010, Tom Ammon wrote:
| Thanks for the pointer. I thought it was running in connected mode, and 
| looking at that variable that you mentioned confirms it:


| [root@gateway3 ~]# ifconfig ib0
| ib0       Link encap:InfiniBand  HWaddr 
| 80:00:00:02:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
|            inet addr:192.168.23.253  Bcast:192.168.23.255  Mask:255.255.254.0
|            RX packets:2319010 errors:0 dropped:0 overruns:0 frame:0
|            TX packets:4512605 errors:0 dropped:33011 overruns:0 carrier:0

That's a lot of packets dropped on the tx side.

If you have the qlogic software installed, running ipathstats -c1 while
you are running the test would be useful, otherwise perfquery -r at
start and another perfquery at the end on both nodes might point to
something.

Oh, and depending on your tcp stack tuning, setting the receive and/or
send buffer size might help.   These are all ddr results, on a more
or less OFED 1.5.1 stack (completely unofficial, blah blah).

And yes, multi-thread will bring the results up (iperf, rather than netperf).

# netperf -H ib-host TCP_STREAM -- -m 65536      
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to ib-host (172.29.9.46) port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  65536  65536    10.03    5150.24   
# netperf -H ib-host TCP_STREAM -- -m 65536 -S 131072
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to ib-host (172.29.9.46) port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

262144  65536  65536    10.03    5401.83   

# netperf -H ib-host TCP_STREAM -- -m 65536 -S 262144
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to ib-host (172.29.9.46) port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

524288  65536  65536    10.01    5478.28   


Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
