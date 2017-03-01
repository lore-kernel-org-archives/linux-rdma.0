From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Tue, 28 Feb 2017 19:10:24 -0500
Message-ID: <20170301001023.GA3001@phlsvsds.ph.intel.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2017 at 06:08:41PM +0200, Alex Rosenbaum wrote:
> Introduction
> 
> --------------------------------------------------------------------------------
> 
> Hotplug [1] is the method in which new hardware becomes available in the system
> 
> or is being removed from it. User space applications would like to continue
> 
> operation while hardware is being changed in the system, without the need to
> 
> restart the process, lose its current state and lose open sessions (at least on
> 
> other available hardware).
> 
> 
> 
> The problem
> 
> --------------------------------------------------------------------------------
> 
> Today the IB device list is returned by ibv_get_device_list() from libibverbs.
> 
> This IB device list is created by scanning of the /sys/class/infiniband_verbs
> 
> [2]. The list is cached and never updated, no matter if there were hardware
> 
> changes in the system.


After the call it occurred to me that we may be missing a bigger picture with
this discussion.  In the past we have discussed in the past what exactly a
"struct ib_device" is within the context of the kernel.

Should we also consider "port hotplug"?

For example what happens if a Mellanox port is unplugged from an IB port and
plugged into an Ethernet port?  Is that considered a "device" hot plug?  What
happens if this is a dual port device and only one of the 2 IB ports are
changed?  So many things like AH, Path Records, etc are tied to the "device"
but really they should be tied to the port.

To be clear I am not opposed to this change at this time.  But I think we
should consider shifting the model away from devices and toward ports as we
continue.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
