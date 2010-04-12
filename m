From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: IPoIB performance benchmarking
Date: Mon, 12 Apr 2010 13:19:31 -0700
Message-ID: <alpine.LFD.1.10.1004121317270.21537@topaz.mv.qlogic.com>
References: <4BC367DD.30606@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BC367DD.30606-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Haymore <brian.haymore-wbocuHtxKic@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 12 Apr 2010, Tom Ammon wrote:
| I'm trying to do some performance benchmarking of IPoIB on a DDR IB 
| cluster, and I am having a hard time understanding what I am seeing.
| 
| When I do a simple netperf, I get results like these:
| 
| [root@gateway3 ~]# netperf -H 192.168.23.252
| TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.23.252 
| (192.168.23.252) port 0 AF_INET
| Recv   Send    Send
| Socket Socket  Message  Elapsed
| Size   Size    Size     Time     Throughput
| bytes  bytes   bytes    secs.    10^6bits/sec
| 
|   87380  65536  65536    10.01    4577.70

Are you using connected mode, or UD?  Since you say you have a 4K MTU,
I'm guessing you are using UD.  Change to use connected mode (edit 
/etc/infiniband/openib.conf), or as a quick test

	 echo connected > /sys/class/net/ib0/mode

and then the mtu should show as 65520.  That should help
the bandwidth a fair amount.


Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
