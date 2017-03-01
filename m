From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Wed, 1 Mar 2017 23:21:04 +0200
Message-ID: <CAFgAxU-Vf6RLEo8N=oya0X+WbneRHE1xa_-5GY+TEqo1wyzpow@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170301001023.GA3001@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301001023.GA3001-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 1, 2017 at 2:10 AM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> After the call it occurred to me that we may be missing a bigger picture with
> this discussion.  In the past we have discussed in the past what exactly a
> "struct ib_device" is within the context of the kernel.
>
> Should we also consider "port hotplug"?
>
> For example what happens if a Mellanox port is unplugged from an IB port and
> plugged into an Ethernet port?  Is that considered a "device" hot plug?

Yes, this fis a 'device' hotplug.
Reconfiguring a ConnectX3 port from one link layer to another requires
full device plugout & plugin. And this needs to be done by the sys
admin.


> What happens if this is a dual port device and only one of the 2 IB ports are
> changed?  So many things like AH, Path Records, etc are tied to the "device"
> but really they should be tied to the port.

The newer ConnectX4 (and forward) devices expose a pci function per
port, so reconfiguring a port link layer will hotplug only that pci
function.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
