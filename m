From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 5 Sep 2012 13:09:53 -0400
Message-ID: <3F476926-8618-4233-A150-C5D487B55C68@ornl.gov>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
 <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sep 5, 2012, at 11:51 AM, Christoph Lameter wrote:

> On Wed, 29 Aug 2012, Atchley, Scott wrote:
> 
>> I am benchmarking a sockets based application and I want a sanity check
>> on IPoIB performance expectations when using connected mode (65520 MTU).
>> I am using the tuning tips in Documentation/infiniband/ipoib.txt. The
>> machines have Mellanox QDR cards (see below for the verbose ibv_devinfo
>> output). I am using a 2.6.36 kernel. The hosts have single socket Intel
>> E5520 (4 core with hyper-threading on) at 2.27 GHz.
>> 
>> I am using netperf's TCP_STREAM and binding cores. The best I have seen
>> is ~13 Gbps. Is this the best I can expect from these cards?
> 
> Sounds about right, This is not a hardware limitation but
> a limitation of the socket I/O layer / PCI-E bus. The cards generally can
> process more data than the PCI bus and the OS can handle.
> 
> PCI-E on PCI 2.0 should give you up to about 2.3 Gbytes/sec with these
> nics. So there is like something that the network layer does to you that
> limits the bandwidth.

First, thanks for the reply.

I am not sure where are are getting the 2.3 GB/s value. When using verbs natively, I can get ~3.4 GB/s. I am assuming that these HCAs lack certain TCP offloads that might allow higher Socket performance. Ethtool reports:

# ethtool -k ib0
Offload parameters for ib0:
rx-checksumming: off
tx-checksumming: off
scatter-gather: off
tcp segmentation offload: off
udp fragmentation offload: off
generic segmentation offload: on
generic-receive-offload: off

There is no checksum support which I would expect to lower performance. Since checksums need to be calculated in the host, I would expect faster processors to help performance some.

So basically, am I in the ball park given this hardware?

> 
>> What should I expect as a max for ipoib with FDR cards?
> 
> More of the same. You may want to
> 
> A) increase the block size handled by the socket layer

Do you mean altering sysctl with something like:

# increase TCP max buffer size setable using setsockopt()
net.core.rmem_max = 16777216 
net.core.wmem_max = 16777216 
# increase Linux autotuning TCP buffer limit 
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
# increase the length of the processor input queue
net.core.netdev_max_backlog = 30000

or something increasing the SO_SNFBUF and SO_RCVBUF sizes or something else?

> B) Increase the bandwidth by using PCI-E 3 or more PCI-E lanes.
> 
> C) Bypass the socket layer. Look at Sean's rsockets layer f.e.

We actually want to test the socket stack and not bypass it.

Thanks again!

Scott

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
