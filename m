From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Wed, 23 Dec 2015 18:15:25 -0500
Message-ID: <20151223231525.GA22759@phlsvsds.ph.intel.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 22, 2015 at 02:38:10PM +0200, Moni Shoua wrote:
> Hi,
> 
> In the past months the need for a kernel module that implements the InfiniBand
> transport in software and unify all the InfiniBand software drivers has
> been raised. Since then, nobody has submitted any design proposal that satisfy
> the initial thoughts and can serve various back-ends.

I'm not sure I understand what you mean.  Denny has posted several high level
emails similar to this one and has asked for public feedback.  We have been
addressing all the feedback as it has come in and we continue to work toward
this common layer.

To that end we have been asking for you to identify any place you see an
incompatibility with the rdmavt layer for SoftRoCE.  Patches and comments to
rdmavt are encouraged and we have already incorporated patches from outside
Intel.

We are very sensitive to the fact that other drivers will want to use this
layer in the future.  But I don't think this layer is set in stone.  To
that end, any functionality which is specific to SoftRoCE should be added when
SoftRoCE is submitted to the kernel.  To date I have not seen any show stopper
objections except Sagi's comment on the lack of IB_WR_LOCAL_INV which we will
drop in the next submission.

Also, please be aware that we are being very careful with this work to not
sacrifice the performance of either qib or hfi1.  There are a couple of items
you mention below which seem to indicate you would like a more "pure"
separation of the driver.  I hope you understand that any work in this area
which affects our performance must be accounted for and may not result in as
"pure" a separation as you may like.  If that is a show stopper for SoftRoCE
lets work through the specific examples.

More inline.

> 
> The following is a RFC that presents a solution made of a single
> generic InfiniBand
> driver and many hardware specific back-end drivers. The RFC defines
> the requirements
> and the interfaces that have to be part of any generic InfiniBand driver.
> A generic InfiniBand driver that is not compliant with this RFC wouldn't be able
> to serve different back-ends and therefore would miss its target.
> 
> ================================================================================
> 
> A. Introduction
> --------------------------------------------------------------------------------
> In Linux kernel, the responsibility to implement the InfiniBand protocol is
> roughly divided between 2 elements. The first are the core drivers which expose
> an abstract verbs interface to the upper layer as well as interfaces to some
> common IB services like MAD, SA and CM. The second are vendor drivers and
> hardware which implement the abstract verbs interface.
> 
> A high level view of the model is in Figure A1
> 
>          +-----------------+
>          |                 |
>          |    IB core      |
>          |    drivers      |
>          |                 |
>          +--------+--------+
>                   |                 Common
> --------------------------------------------
>                   |                 Vendor
>          +--------+--------+
>          |                 |
>          |  Hardware       |
>          |  drivers        |
>          |                 |
>          +--------+--------+
>          |                 |
>          |  Hardware       |
>          |                 |
>          +-----------------+
> 
> A1 - IB implementation model in Linux kernel
> 
> In the vendor part of the model, the devision of work between software and
> hardware is undefined and is usually one of the two below
> 
> - Context and logic are  managed in software. Hardware role is limited to
>   lower layer protocols (depending on the link layer) and maybe some offloads
> - Context and logic are managed in hardware while software role is to create
>   or destroy a context in the hardware and gets notified when hardware reports
>   about a completions tasks.
> 
> The following examples demonstrates the difference between the approaches above.
> 
> - Send flow: application calls post_send() with QP and a WR. In the software
>   based approach the QP context is retrieved, the WR is parsed and a proper IB
>   packet is formed to be put in hardware buffers. In hardware based approach the
>   driver puts the WR in hardware buffers with a handle to the QP and hardware
>   does the rest.

I'm glad you brought this up but I'm a bit confused.  For anything that sends
more than a single packet I think this is an oversimplification.[1]  Do you
perhaps mean WQE rather than packet?

If you are referring to a WQE we were thinking the same thing but have not
gotten the send code posted yet.

[1] For example a 1MB RDMA write will require many packets.


> - Receive flow: a data packet is received and put in hardware buffers (assume
>   that the destination is a RC QP). In software based approach the packet is
>   handed to the driver. The driver retrieves the context by QPN, decides if
>   ACK/NACK packet is required (if so, generates it) and decides if CQE is
>   required on the CQ of the QP. In the other approach the hardware compares
>   the packet to the state in the context, generates the ACK/NACK and raises an
>   event to the driver that CQE is ready for reading.

Again I wonder if you are speaking of WQE's rather than packets.  If you are
speaking of WQEs then I think we are exactly on the same page.  The low level
drivers need to handle processing of the WQEs to allow for any hardware assist
which may be available.


> 
> Figure A2 illustrates hardware/software relationship in the implementation of a
> IB transport solution in the software based approach.
> 
>           +----------------------------+
>           |  IB transport              |
>           |  capable driver            |
>           |                            |
>           |  +----------------------+  |
>           |  |Context (deep)        |  |
>           |  |                      |  |
>           |  +----------------------+  |
>           |                            |
>           |  +----------------------+  |
>           |  | Logic (IB transport) |  |
>           |  |                      |  |
>           |  +----------------------+  |
>           |                            |
>           |  +----------------------+  |
>           |  | Interface            |  |
>           |  |                      |  |
>           |  +----------------------+  |
>           +----------------------------+
>                         |
>                         |
>           +----------------------------+
>           |  +----------------------+  |
>           |  | Interface            |  |
>           |  |                      |  |
>           |  +----------------------+  |
>           |                            |
>           |  +----------------------+  |
>           |  | Context (shallow)    |  |
>           |  |                      |  |
>           |  +----------------------+  |
>           |                            |
>           |  +----------------------+  |
>           |  | Logic (link layer)   |  |
>           |  |                      |  |
>           |  +----------------------+  |
>           |                            |
>           |  IB transport              |
>           |  incapable NIC             |
>           +----------------------------+
> A2 - software based approach for IB transport implementation
> 
> The rest of this paper is focused on IB transport solutions that are based on
> software
> 
> B. Common software based IB transport solution
> --------------------------------------------------------------------------------
> In hardware based solutions the software driver implementation is tightly tied
> to the hardware. Therefore, for different hardware types there is hardly a
> common part to all software driver. In software based solutions things are
> different. For such, since hardware capabilities are limited and implement only
> the lower layer(s) of the OSI model and transport layer is done in the software.

Again this is an oversimplification.  There are significant differences in the
hardware capabilities within the qib and hfi1 hardware (as I would expect for
SoftRoCE device as well).  As you say elsewhere in this mail the ability for
the drivers to override functionality is necessary and is being accounted for
in rdmavt.

> In that case the common part between all drivers is quite large and is actually
> the implementation of the InfiniBand transport specification.
> The immediate conclusion is that we can take one software driver and
> theoretically match it to any hardware with some (obvious and less obvious)
> adjustments.

I agree that there is a lot of shared code here.  And that is exactly what we
are working toward with rdmavt.

> Taking this one step forward yields another conclusion that only one
> IB transport software driver can be designed to work with all types of
> hardware back-ends, if we supply a well defined abstract interface
> between the IB
> transport driver and a theoretical model of hardware that all real hardware can
> fit to.


The idea of making a "theoretical model" is nice but we can not be asked to
sacrifice the performance of our hardware for a "theoretical model of
hardware".  One only has to look at a comparison of qib and hfi1 to see that
hardware differences affect performance.  We will not sacrifice performance to
support a nice "theoretical model" of hardware.

> 
> The structure of the generic InfiniBand driver and its placement in the IB
> stack layer model is as Figure B1 describes
> 
> +-----------------------------------------------+
> |                                               |
> |  IB core drivers                              |
> |                                               |
> +------------^-----------+--+--+----------------+
>              |           |  |  |
>  ib_register_device()    |  |  | Abstract interface
>              |           |  |  |
> +------------+-----------v--v--v----------------+
> |  Gneric IB         +--------------+           |
> |  driver            |Abstract      |           |
> |                    |interface     |           |
> |  +--------------+  |implementation|           |
> |  | Context &    |  +--------------+           |
> |  | Logic        |                             |
> |  |              |                             |
> |  +--------------+                             |
> +-----^-----------------------------^--------+--+
>       |        |                    |        |
>       |        |                API |        | Abstract interface
>       |        |                    |        |
>       |        |                    |        |
>       |        |                    |        |
> +-----+--------v------+   +---------+--------v--+
> | HW device driver A  |   | HW device driver B  |
> | (specific)          |   | (specific)          |
> |                     |   |                     |
> +---------------------+   +---------------------+
> 
> B1 - Generic InfiniBand driver structure & layout
> 
> To the layer above it, ib_core, the generic driver registers a new
> ib_device and implements all the mandatory verbs(as in
>  ib_device_check_mandatory()). To the layer below, the thin hardware
> specific driver, the generic driver declares an abstract interface that
> supplies API functions as we will describe later in this document.

I agree. rdmavt does this.

> 
> In addition, all SW providers may share a single common user-space provider,
> since there is no direct interaction between user-space and HW.

I agree, libipathverbs and libhfi1verbs should be merged.  Is there a lib
"softroce" as well?  At this point however, there is no reason we have to do
this merge.

> 
> C. Requirements from the generic InfiniBand driver
> -----------------------------------------------------------------------------
> To achieve its goal, be a single IB transport implementation for any back-end
> driver, the generic driver is required to the following
> 
> - Offer in implementation to the  InfiniBand Architecture Specification as
>   described in chapters 9 (TRANSPORT LAYER) and 10 (SOFTWARE TRANSPORT
>   INTERFACE)
> - Offer an implementation to the to the  ib_core abstract interface as
>   described in InfiniBand Architecture Specification chapter 11 (SOFTWARE
>   TRANSPORT VERBS)

Agree... and again rdmavt does this.

> - Have the ability to build and validate network and link layer headers as
>   described in the InfiniBand Architecture Specification chapters 7 (LINK LAYER)
>   and 8 (NETWORK LAYER) and as described in Annex A16 (RoCE) and Annex A17
>   (RoCEv2)

I disagree.  The specifics of the link layer should be in the hardware driver.
Why would you want this to be in the software driver?  Each hardware layer has
specific packet formatting requirements.  Which is exactly why there is a low
level hardware driver.

> - Define an abstract interface that a hardware driver needs to implement. This
>   interface needs to be general enough in the functions it requires all to
>   implement but flexible enough in the functions it allows to implement.

Agree and again rdmavt allows for functions to be overridden by the hardware
driver.

> - Supply an interface for hardware  drivers for the  opposite direction
>   interaction

Agree and again rdmavt allows for this.

> 
> Note: at the time when this RFC was written there are 3 software based IB
> transport solutions: QIB, hfi1 and SoftRoCE.

Agree and each one has different packet formatting requirements.

> 
> D. The abstract back-end driver
> -----------------------------------------------------------------------------
> Before we proceed to define the interface between the generic driver and the
> hardware driver we should understand what the hardware is capable of and
> what it is not. In fact, since hardware can offer many offloading features
> that we can't predict now we need categorize the functions in the abstract
> interface to two, those that must be implemented by the back-end drive and
> those that may be implemented. The most simple back-end driver, the one that
> doesn't have any offloading capabilities, will implement only the set of
> mandatory functions. Back-end driver that have some kind of offloads or require
> more complex flows can implement some of the  optional functions and notify the
> generic driver  about that.

Agree and again rdmavt allows for the low level drivers to override various
functions to allow for this.  Of course no one can predict everything which may
be needed so we do anticipate additional functions or hooks to be implemented
as those features become available.

> For example, if a network driver has an optimization for sending small packets
> it can implement a set of functions for a small packet flow (we leave the
> question what this flow is made of unanswered here) that the generic driver will
> use. Of course, any function in the abstract interface, even if it is optional,
> should be as general as can be so it would fit as many as other
> hardware drivers.

Agree.  But how is the architecture you are presenting different from what
rdmavt is already implementing?  Every function has the ability to be
overridden.  So each of the verbs calls could be overridden with optimized
versions for the hardware in question.

> 
> Among the common capabilities that a hardware driver must implement we find
> - Detect new hardware on the PCI bus
> - Put a packet on the wire from a buffer
> - Receive a packet from the wire to a buffer
> - Capture hardware events

- processing MAD packets to monitor/configure the hardware
  	(How does softroce handle QP0/1 and MADs?  Does it?)

> 
> E. The generic InfiniBand driver lower interface
> --------------------------------------------------------------------------------
> After discussing the general model of the back-end driver we are ready to define
> the interface. From the generic driver to the hardware driver the
> interface should
> be abstracti, i.e. the generic driver defines what he expects from the driver to
> implement,mandatory or optional.
> From the hardware driver to the  generic driver the relation is many to one and
> therefore the interface should have the form of an API.  Tablas  E1 and E2 lists
> the interfaces
> 
> +------------------+---------------------------------------------------+
> | Name             | Description                                       |
> |==================|===================================================|
> |register()        |tell generic driver that new hardware is present   |

rvt_register_device

> |------------------|---------------------------------------------------|
> |unregister()      |tell generic driver that hardware was removed      |

rvt_unregister_device

> |------------------|---------------------------------------------------|
> |receive()         |receive a packet from the wire                     |

Again I am confused by what you mean by packet.  Do you mean WQE?

I think the confusion here is that what has been discussed is still very high
level and Denny has not posted the recv code yet.  We absolutely agree that the
low level driver needs to notify the upper level that something has arrived.
But how this is done needs to be in a performant manner and a simple function
may be insufficient.

> |------------------|---------------------------------------------------|
> |handle_event()    |notify about hardware event                        |

I'm not sure if this is completely necessary.  If we need to isolate the low
level drivers from the verbs core we can, but currently it seems reasonable to
use the existing event infrastructure which is already defined.

> +----------------------------------------------------------------------+
>
> 
> Table E1 - The  back-end to generic driver interface
> 
> +------------------+---------------------------------------------------+
> | Name             | Description                                       |
> |==================|===================================================|
> |send()            |put packet on the wire                             |

Struct rvt_dev_info -> struct rvt_driver_provided -> do_send

> |------------------|---------------------------------------------------|
> |query_link()      |report link state and properties                   |

What are the properties here?  Originally we also thought this was necessary
but so far we have not needed this functionality.  So it has not been added.
Does SoftRoCE report the same information about the link as IB?  Are you saying
that for SoftRoCE the rdmavt layer will need to "manufacture" link information
to make it compatible with the IB core?  If so then yes we can surely add this
when SoftRoCE is added and we see what those details are.

> +----------------------------------------------------------------------+
> |node_guid()       |get GUID of node                                   |
> +-----------------------------------------------------------------------
> |port_guid()       |get GUID of port                                   |

I agree this information needs to be available to the upper layer but with
rdmavt we have chosen to simply have the low level drivers fill in these
details in the rdmavt structure.  This is similar to the discussion on the list
right now about removing the query_device call.  If we are removing that call
why would we need calls like this in this layer?

> +-----------------------------------------------------------------------
> |mcast_add()       |register multicast address                         |
> +-----------------------------------------------------------------------
> |mcast_del()       |unregister multicast address                       |

rdmavt will have to handle these differently for for SoftRoCE as both hfi1 and
qib join multicast groups the "Verbs Way", in that they post MAD to a QP which
gets sent to the SM.  So the joining of multicast groups is no different than
sending a UD Verbs message.  I see no reason to have rdmavt nor the low level
drivers handle any of that special from what is currently done by the ib_sa
module.

How does SoftRoCE handle mcast joins now?

It sounds like you should patch rdmavt to add this function and have qib/hfi1
set this to NULL so that rdmavt ignores that functionality just like any other
call can be overridden.


> +-----------------------------------------------------------------------
> |alloc_qpn()       |allocate a new QP number                           |

Again rdmavt is flexible enough to let you over ride this if you want... 

> +-----------------------------------------------------------------------
> |get_send_buffer() |allocate a buffer for send operation               |

Qib and hfi1 have DMA engines to send the data directly out of the supplied
buffer.  It sounds like you need this to get an sk_buff?  If so, this is yet
another difference which will need to be added when SoftRoCE is added.  But it
will not be implemented or used by qib/hfi1.  So at this time I don't see a
need for this function.

Thanks for the feedback,
Ira


> +-----------------------------------------------------------------------
> 
> Table E2 - The generic driver to back-end driver interface
> 
> Following is a detailed description for the functions above
> 
> +---------------------------------------------------------------------------------+
> |Name:          |register
>            |
> |---------------------------------------------------------------------------------|
> |Description:   |notify about a new instance of the hardware.
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |- pointer to hardware description struct
>            |
> |               |- pointers to abstract interface implementation
> struct           |
> |---------------------------------------------------------------------------------|
> |Output         |- registration handle
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name:          |unregister
>            |
> |---------------------------------------------------------------------------------|
> |Description:   |notify that hardware instance is gone
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |registration handle
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name:          |receive
>            |
> |---------------------------------------------------------------------------------|
> |Description:   |get a packet from the wire. When done notify the
> caller          |
> |---------------------------------------------------------------------------------|
> |Input:         |-buffer for the packet
>            |
> |               |-buffer length
>            |
> |               |-pointer to receive done function
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name:          |handle_event
>            |
> |---------------------------------------------------------------------------------|
> |Description:   |pass hardware event for processing
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |-registration handle of the device
>            |
> |               |-event type
>            |
> |               |-event data struct
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name:          |send
>            |
> |---------------------------------------------------------------------------------|
> |Description:   |transmit one packet. When done, notify the caller
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |- pointer to headers buffer
>            |
> |               |- headers buffer length
>            |
> |               |- pointer to scatter gather struct
>            |
> |               |- pointer to xmit_done() function
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name:          |query_link
>            |
> |---------------------------------------------------------------------------------|
> |Description:   |query link state
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |- device identifier
>            |
> |               |- port index
>            |
> |---------------------------------------------------------------------------------|
> |Output         |- pointer to port state struct
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name           |node_guid()
>            |
> |---------------------------------------------------------------------------------|
> |Description    |get 64 bit node guid
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |-device identifier
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |node GUID
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name           |port_guid
>            |
> |---------------------------------------------------------------------------------|
> |Description    |get 64 bit
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |-device identifier
>            |
> |               |-port index
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |port GUID
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name           |mcast_add
>            |
> |---------------------------------------------------------------------------------|
> |Description    |open device for multicast address
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |-device identifier
>            |
> |               |-address
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name           |mcast_del
>            |
> |---------------------------------------------------------------------------------|
> |Description    |close device for multicast address
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |-device identifier
>            |
> |               |-address
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |success/failure
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name           |alloc_qpn
>            |
> |---------------------------------------------------------------------------------|
> |Description    |get unique QP number
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |QP number
>            |
> +---------------------------------------------------------------------------------+
> 
> +---------------------------------------------------------------------------------+
> |Name           |get_send_buffer
>            |
> |---------------------------------------------------------------------------------|
> |Description    |allocate buffer that will be used to send a patcket
>            |
> |---------------------------------------------------------------------------------|
> |Input:         |-length
>            |
> |---------------------------------------------------------------------------------|
> |Output         |
>            |
> |---------------------------------------------------------------------------------|
> |Return         |pointer to a buffer
>            |
> +---------------------------------------------------------------------------------+
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
