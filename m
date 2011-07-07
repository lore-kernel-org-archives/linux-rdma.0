From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 04/14] SIWv2: Module initialization: siw_main.c
Date: Thu, 07 Jul 2011 09:04:05 -0500
Message-ID: <4E15BCD5.7050801@opengridcomputing.com>
References: <OFECAC7AF5.E3ED2EF9-ONC12578BF.004E5934-C12578BF.005A012E@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFECAC7AF5.E3ED2EF9-ONC12578BF.004E5934-C12578BF.005A012E-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/30/2011 11:23 AM, Bernard Metzler wrote:
> Good point. I moved the three attributes to debugfs which
> looks much more appropriate.
>
> I also re-structured module initialization/device registration:
> The siw module now registers with the netdevice subsystem
> (register_netdevice_notifier()) to catch NETDEV_xx events,
> which now also handles device state changes and later
> device addition.
>
> Before posting it as a proposed patch I wanted to discuss the
> following. Currently, only NETDEV_REGISTER, NETDEV_UNREGISTER,
> NETDEV_UP, NETDEV_DOWN are handled as following:
> NETDEV_REGISTER:	Instantiate a siw device (ib_alloc_device()).
> NETDEV_UP:		Register to ib_core (ib_register_device()),
> 			if the device has an interface address.
> NETDEV_DOWN:	Unregister from ib_core (ib_unregister_device()).
> NETDEV_UNREGISTER:Deallocate device (ib_dealloc_device())
>
> Toggling the device UP and DOWN would end up un-/registering
> with the ib_core. Maybe thats not appropriate and the device
> should remain visible to ib_core? The CM appears to exclude
> DOWN devices from connection management. With that, a siw device
> would remain visible to ib_core until it gets UNREGISTERed.
>

I would keep it registered if the netdev device is registered.  Wouldn't a SIW connection survive an ifdown/ifup on the 
interface handling that connection? I would think so.  So I think NETDEV_REGISTER triggers rdma core alloc and 
registration, UP/DOWN trigger IB_EVENT_PORT_ACTIVE/IB_EVENT_PORT_ERR port events, and UNREGISTER triggers core 
unreg/dealloc.

My 2 centimes.


> Should the code handle other events such as NETDEV_CHANGEADDR?
>
>

This fires when a MAC address changes, yes?  Perhaps this should trigger a IB_EVENT_LID_CHANGE or something?  That would 
force the ib gid cache code to re-query your device for the updated MAC address  (see ib_cache_event() and friends). The 
chelsio drivers don't have this, but they probably need it.


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
