From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 11/13] IB/srp: Make HCA completion vector configurable
Date: Mon, 15 Jul 2013 05:06:05 -0600
Message-ID: <51E3D79D.9070808@acm.org>
References: <51D41C03.4020607@acm.org> <51D41FFC.6070105@acm.org> <51E272A4.5030707@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E272A4.5030707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14/07/2013 3:43, Sagi Grimberg wrote:
> On 7/3/2013 3:58 PM, Bart Van Assche wrote:
>> Several InfiniBand HCA's allow to configure the completion vector
>> per queue pair. This allows to spread the workload created by IB
>> completion interrupts over multiple MSI-X vectors and hence over
>> multiple CPU cores. In other words, configuring the completion
>> vector properly not only allows to reduce latency on an initiator
>> connected to multiple SRP targets but also allows to improve
>> throughput.
>
> Hey Bart,
> Just wrote a small patch to allow srp_daemon spread connection across
> HCA's completion vectors.
> But re-thinking on this, is it really a good idea to give the user
> control over completion
> vectors for CQs he doesn't really owns. This way the user must retrieve
> the maximum completion
> vectors from the ib_device and consider this when adding a connection
> and In addition will need to set proper IRQ affinity.
>
> Perhaps the driver can manage this on it's own without involving the
> user, take the mlx4_en driver for
> example, it spreads it's CQs across HCAs completion vectors without
> involving the user. the user that
> opens a socket has no influence of the underlying cq<->comp-vector
> assignment.
>
> The only use-case I can think of is where the user will want to use only
> a subset of the completion-vectors
> if the user will want to reserve some completion-vectors for native IB
> applications but I don't know
> how common it is.
>
> Other from that, I think it is always better to spread the CQs across
> HCA completion-vectors, so perhaps the driver
> just assign connection CQs across comp-vecs without getting args from
> the user, but simply iterate over comp_vectors.
>
> What do you think?

Hello Sagi,

Sorry but I do not think it is a good idea to let srp_daemon assign the 
completion vector. While this might work well on single-socket systems 
this will result in suboptimal results on NUMA systems. For certain 
workloads on NUMA systems, and when a NUMA initiator system is connected 
to multiple target systems, the optimal configuration is to make sure 
that all processing that is associated with a single SCSI host occurs on 
the same NUMA node. This means configuring the completion vector value 
such that IB interrupts are generated on the same NUMA node where the 
associated SCSI host and applications are running.

More in general, performance tuning on NUMA systems requires system-wide 
knowledge of all applications that are running and also of which 
interrupt is processed by which NUMA node. So choosing a proper value 
for the completion vector is only possible once the system topology and 
the IRQ affinity masks are known. I don't think we should build 
knowledge of all this in srp_daemon.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
