From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 5 Sep 2012 14:30:47 -0400
Message-ID: <78D8717C-0505-408B-8625-A9124AB33C9E@ornl.gov>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
 <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com>
 <3F476926-8618-4233-A150-C5D487B55C68@ornl.gov>
 <0000013997a928ab-36ad5a02-3c82-4daf-8e8a-a86c65e92376-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000013997a928ab-36ad5a02-3c82-4daf-8e8a-a86c65e92376-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sep 5, 2012, at 2:20 PM, Christoph Lameter wrote:

> On Wed, 5 Sep 2012, Atchley, Scott wrote:
> 
>> # ethtool -k ib0
>> Offload parameters for ib0:
>> rx-checksumming: off
>> tx-checksumming: off
>> scatter-gather: off
>> tcp segmentation offload: off
>> udp fragmentation offload: off
>> generic segmentation offload: on
>> generic-receive-offload: off
>> 
>> There is no checksum support which I would expect to lower performance.
>> Since checksums need to be calculated in the host, I would expect faster
>> processors to help performance some.
> 
> K that is a major problem. Both are on by default here. What NIC is this?

These are Mellanox QDR HCAs (board id is MT_0D90110009). The full output of ibv_devinfo is in my original post.

>>> A) increase the block size handled by the socket layer
>> 
>> Do you mean altering sysctl with something like:
> 
> Nope increase mtu. Connected mode supports up to 64k mtu size I believe.

Yes, I am using the max MTU (65520).

>> or something increasing the SO_SNFBUF and SO_RCVBUF sizes or something else?
> 
> That does nothing for performance. The problem is that the handling of the
> data by the kernel causes too much latency so that you cannot reach the
> full bw of the hardware.
> 
>> We actually want to test the socket stack and not bypass it.
> 
> AFAICT the network stack is useful up to 1Gbps and
> after that more and more band-aid comes into play.

Hmm, many 10G Ethernet NICs can reach line rate. I have not yet tested any 40G Ethernet NICs, but I hope that they will get close to line rate. If not, what is the point? ;-)

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
