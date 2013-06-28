From: David Dillow <dillow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 12/14] IB/srp: Make HCA completion vector configurable
Date: Fri, 28 Jun 2013 08:04:01 -0400
Message-ID: <1372421041.28740.14.camel@haswell.thedillows.org>
References: <51B87501.4070005@acm.org> <51B87904.1070803@acm.org>
	 <1372368256.32164.41.camel@frustration.ornl.gov> <51CD46F0.60301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD46F0.60301-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-06-28 at 10:18 +0200, Bart Van Assche wrote:
> On 06/27/13 23:24, David Dillow wrote:
> > Shouldn't there be some documentation about how to set this? What
> > happens when you try to set it on an HCA that doesn't support this how
> > does the user know what's wrong?
> 
> Hello Dave,
> 
> HCA drivers that support only one completion vector ignore the 
> comp_vector parameter. See e.g. c2_create_cq() in 
> drivers/infiniband/hw/amso1100/c2_provider.c for an example. The third 
> argument of that function, called "vector", is ignored.
> 
> What will happen if an out-of-range value is chosen for this parameter 
> depends on the HCA driver. This is how the mlx4 driver handles the 
> comp_vector parameter:
> 	vector = dev->eq_table[vector % ibdev->num_comp_vectors];
> So an out-of-range value for comp_vector won't cause a failure. And if 
> ever a HCA driver would be added to the kernel tree that causes 
> create_cq() to fail if the comp_vector parameter is out of range then 
> the ib_srp driver will propagate the error code returned by 
> ib_create_cq() to the process that wrote into the add_target sysfs 
> attribute.

I understand that the error code will unwind to the process, at which
point the user gets an EINVAL without any indication as to why. Our
error handling here sucks, but that's for another day; it shouldn't hold
up the patch -- I was more wondering if there was a specific error code
that would let us know we screwed up the vector, or if it wasn't
supported, and it appears the answer is no. Somewhat of a bummer, that.

> The procedure for choosing a value for this parameter is as follows:
> * Look up the interrupt numbers that have been assigned to each HCA
>    completion vector, e.g. via grep mlx4-ib- /proc/interrupts.
> * Decide which CPU to bind each interrupt to and update
>    /proc/irq/$irq/smp_affinity.
> * Decide which CPU and completion vector should be used for processing
>    SRP completions and specify that completion vector number in the SRP
>    login string.
> 
> To me this looks like a standard procedure that applies to any HCA that 
> supports multiple MSI-X vectors ?

To you and I, sure, this is relatively standard. And now that google has
it, newcomers will be able to find it. However, this changes the login
string and so Documentation/ABI/stable/sysfs-driver-ib_srp needs to be
updated, with at least minimal text.

Thanks,
Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
