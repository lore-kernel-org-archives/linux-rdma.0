From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 12/14] IB/srp: Make HCA completion vector configurable
Date: Fri, 28 Jun 2013 10:18:56 +0200
Message-ID: <51CD46F0.60301@acm.org>
References: <51B87501.4070005@acm.org> <51B87904.1070803@acm.org> <1372368256.32164.41.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372368256.32164.41.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/27/13 23:24, David Dillow wrote:
> On Wed, 2013-06-12 at 15:35 +0200, Bart Van Assche wrote:
>> Several InfiniBand HCA's allow to configure the completion vector
>> per queue pair. This allows to spread the workload created by IB
>> completion interrupts over multiple MSI-X vectors and hence over
>> multiple CPU cores. In other words, configuring the completion
>> vector properly not only allows to reduce latency on an initiator
>> connected to multiple SRP targets but also allows to improve
>> throughput.
>
> Shouldn't there be some documentation about how to set this? What
> happens when you try to set it on an HCA that doesn't support this how
> does the user know what's wrong?

Hello Dave,

HCA drivers that support only one completion vector ignore the 
comp_vector parameter. See e.g. c2_create_cq() in 
drivers/infiniband/hw/amso1100/c2_provider.c for an example. The third 
argument of that function, called "vector", is ignored.

What will happen if an out-of-range value is chosen for this parameter 
depends on the HCA driver. This is how the mlx4 driver handles the 
comp_vector parameter:
	vector = dev->eq_table[vector % ibdev->num_comp_vectors];
So an out-of-range value for comp_vector won't cause a failure. And if 
ever a HCA driver would be added to the kernel tree that causes 
create_cq() to fail if the comp_vector parameter is out of range then 
the ib_srp driver will propagate the error code returned by 
ib_create_cq() to the process that wrote into the add_target sysfs 
attribute.

The procedure for choosing a value for this parameter is as follows:
* Look up the interrupt numbers that have been assigned to each HCA
   completion vector, e.g. via grep mlx4-ib- /proc/interrupts.
* Decide which CPU to bind each interrupt to and update
   /proc/irq/$irq/smp_affinity.
* Decide which CPU and completion vector should be used for processing
   SRP completions and specify that completion vector number in the SRP
   login string.

To me this looks like a standard procedure that applies to any HCA that 
supports multiple MSI-X vectors ?

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
