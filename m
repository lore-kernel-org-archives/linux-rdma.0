From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: Re: IPoIB performance benchmarking
Date: Mon, 12 Apr 2010 14:52:59 -0600
Message-ID: <4BC3882B.4070200@utah.edu>
References: <4BC367DD.30606@utah.edu> <alpine.LFD.1.10.1004121317270.21537@topaz.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.1.10.1004121317270.21537-vxnkQ4oxbxUi9g6yJnKVd0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Dale Haymore <brian.haymore-wbocuHtxKic@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dave,

Thanks for the pointer. I thought it was running in connected mode, and 
looking at that variable that you mentioned confirms it:

[root@gateway3 ~]# cat /sys/class/net/ib0/mode
connected

And the IP MTU shows up as:

[root@gateway3 ~]# ifconfig ib0
ib0       Link encap:InfiniBand  HWaddr 
80:00:00:02:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
           inet addr:192.168.23.253  Bcast:192.168.23.255  
Mask:255.255.254.0
           inet6 addr: fe80::211:7500:ff:6edc/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
           RX packets:2319010 errors:0 dropped:0 overruns:0 frame:0
           TX packets:4512605 errors:0 dropped:33011 overruns:0 carrier:0
           collisions:0 txqueuelen:256
           RX bytes:5450805352 (5.0 GiB)  TX bytes:154353169896 (143.7 GiB)


This is partly why I'm stumped - I've seen threads about how connected 
mode is supposed to improve IPoIB performance, but I'm not seeing as 
much performance as I'd like.

Tom

On 04/12/2010 02:19 PM, Dave Olson wrote:
> On Mon, 12 Apr 2010, Tom Ammon wrote:
> | I'm trying to do some performance benchmarking of IPoIB on a DDR IB
> | cluster, and I am having a hard time understanding what I am seeing.
> |
> | When I do a simple netperf, I get results like these:
> |
> | [root@gateway3 ~]# netperf -H 192.168.23.252
> | TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.23.252
> | (192.168.23.252) port 0 AF_INET
> | Recv   Send    Send
> | Socket Socket  Message  Elapsed
> | Size   Size    Size     Time     Throughput
> | bytes  bytes   bytes    secs.    10^6bits/sec
> |
> |   87380  65536  65536    10.01    4577.70
>
> Are you using connected mode, or UD?  Since you say you have a 4K MTU,
> I'm guessing you are using UD.  Change to use connected mode (edit
> /etc/infiniband/openib.conf), or as a quick test
>
> 	 echo connected>  /sys/class/net/ib0/mode
>
> and then the mtu should show as 65520.  That should help
> the bandwidth a fair amount.
>
>
> Dave Olson
> dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
>    

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
