From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and fork
Date: Tue, 14 Aug 2012 11:18:09 -0700
Message-ID: <1344968289.2101.36.camel@oc1677441337.ibm.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
	 <502A9039.4090505@us.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A89125-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2012-08-14 at 17:56 +0000, Hefty, Sean wrote:
> > Yes. it is also using rsockets.
> > The second session always hangs after sending a fixed number of bytes
> > (38469632).
> > rsend() blocks waiting for the CQ event.
> 
> Can you send me the parameters that you use for testing?

This test is using Mellanox 10Gb RoCEE with MTU set to 9000

Server is started using
  # ldr netserver -D

2 clients are started in 2 windows as follows. 

# ldr netperf -v2 -c -C -H 192.168.0.22 -l10
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.22 (192.168.0.22) port 0 AF_INET
Recv   Send    Send                          Utilization       Service Demand
Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
Size   Size    Size     Time     Throughput  local    remote   local   remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB

 87380  65536  65536    10.00      9679.80   2.58     2.59     0.349   0.351  

Alignment      Offset         Bytes    Bytes       Sends   Bytes    Recvs
Local  Remote  Local  Remote  Xfered   Per                 Per
Send   Recv    Send   Recv             Send (avg)          Recv (avg)
    8       8      0       0 12101877760  65536.00    184660   21967.51 550899

Maximum
Segment
Size (bytes)
  4096

# ldr netperf -v2 -c -C -H 192.168.0.22 -l10
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.22 (192.168.0.22) port 0 AF_INET
Recv   Send    Send                          Utilization       Service Demand
Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
Size   Size    Size     Time     Throughput  local    remote   local   remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB

 87380  65536  65536    10.00        30.69   2.27     2.78     96.892  118.616 

Alignment      Offset         Bytes    Bytes       Sends   Bytes    Recvs
Local  Remote  Local  Remote  Xfered   Per                 Per
Send   Recv    Send   Recv             Send (avg)          Recv (avg)
    8       8      0       0 38469632  65536.00       587   21360.15   1801

Maximum
Segment
Size (bytes)
  4096


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
