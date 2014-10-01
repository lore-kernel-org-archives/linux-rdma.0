From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Wed, 1 Oct 2014 14:55:31 +0300
Message-ID: <20141001115531.GA10035@yuval-lab>
References: <20140914184621.GA4283@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140914184621.GA4283@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 14, 2014 at 09:46:22PM +0300, Yuval Shaia wrote:
> Hi,
> Lately i was working on fixing an issue with IPoIB driver and i'd like to share the 
> details with you.
> 
> By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better performance.
> This MTU plus overhead puts the memory allocation for IP based packets at 32 4k pages
> (order 5), which have to be contiguous. When the system memory under pressure, it was
> observed that allocating 128k contiguous physical memory is difficult and causes serious
> errors (such as system becomes unusable).
> This enhancement resolve the issue by removing the physically contiguous memory requirement
> using Scatter/Gather feature that exists in Linux stack. In order to use Scatter/Gather
> feature in Linux IPoIB-CM driver, Linux IPoIB-CM must support IP checksum offload feature
> (requirements as per the current Linux N/W implementation). But IB HCA hardware does not
> support this feature and hence IPoIB cannot support the same.
> IPoIB Connected Mode driver uses RC (Reliable Connection) which guarantees the corruption
> free delivery of the packet. InfiniBand uses 32b CRC which provides stronger data integrity
> protection compare to 16b IP Checksum. So, there is no added value that IP Checksum provides
> in the IB world. The proposal is to tell to network stack that IPoIB-CM supports IP
> Checksum offload. This enables Linux IPoIB-CM driver to use Scatter/Gather feature. Network
> sends the IP packet without adding the IP Checksum to the header. On the receive side, IPoIB
> driver again tells the network stack that IP Checksum is good for the incoming packets and
> network stack avoids the IP Checksum calculations.
> During connection establishment the driver determine if the other end supports IB CRC
> as checksum. This is done so driver will be able to calculate checksum before transmitting
> the packet in case the other end does not support this feature.
> A support for fragmented skb is added to transmit path.
> 
> Please note that a "very welcome side-effect" of this feature is a high of degree performance 
> improvement as a result of the removal of csum calculation.
> I will be happy to share results with you if needed.
I ran a simple performance tests using iperf with the latest stable kernel.
Do not consider the results as *best results* it is just to sense the performance improvement.
For the test i used two servers, a "Sender" runs iperf client and "Receiver" runs iperf server.
>From the results we can see that benefits is with the "Receiver" side where we saved the time needed for checksum calculation.
On transmit checksum calculation is done while copying buffer from user-space so not much benefit.

Sender		Receiver	Results 
---------------------------------------
Legacy		Legacy		12 Gbps
Legacy		Patched		20 Gbps
Patched		Legacy		12 Gbps
Patched		Patched		20 Gbps

Legacy is a server which runs kernel without the patch.

I think we can't ignore 70% improvement in performances.
> 
> At present i have patch ready which was tested with an old kernel and i'm working to port 
> it to latest.
> 
> Please review and comment.
> 
> Yuval
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
