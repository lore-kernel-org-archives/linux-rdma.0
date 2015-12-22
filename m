From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC] Generic InfiniBand transport done in software
Date: Tue, 22 Dec 2015 14:38:10 +0200
Message-ID: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

In the past months the need for a kernel module that implements the InfiniBand
transport in software and unify all the InfiniBand software drivers has
been raised. Since then, nobody has submitted any design proposal that satisfy
the initial thoughts and can serve various back-ends.

The following is a RFC that presents a solution made of a single
generic InfiniBand
driver and many hardware specific back-end drivers. The RFC defines
the requirements
and the interfaces that have to be part of any generic InfiniBand driver.
A generic InfiniBand driver that is not compliant with this RFC wouldn't be able
to serve different back-ends and therefore would miss its target.

================================================================================

A. Introduction
--------------------------------------------------------------------------------
In Linux kernel, the responsibility to implement the InfiniBand protocol is
roughly divided between 2 elements. The first are the core drivers which expose
an abstract verbs interface to the upper layer as well as interfaces to some
common IB services like MAD, SA and CM. The second are vendor drivers and
hardware which implement the abstract verbs interface.

A high level view of the model is in Figure A1

         +-----------------+
         |                 |
         |    IB core      |
         |    drivers      |
         |                 |
         +--------+--------+
                  |                 Common
--------------------------------------------
                  |                 Vendor
         +--------+--------+
         |                 |
         |  Hardware       |
         |  drivers        |
         |                 |
         +--------+--------+
         |                 |
         |  Hardware       |
         |                 |
         +-----------------+

A1 - IB implementation model in Linux kernel

In the vendor part of the model, the devision of work between software and
hardware is undefined and is usually one of the two below

- Context and logic are  managed in software. Hardware role is limited to
  lower layer protocols (depending on the link layer) and maybe some offloads
- Context and logic are managed in hardware while software role is to create
  or destroy a context in the hardware and gets notified when hardware reports
  about a completions tasks.

The following examples demonstrates the difference between the approaches above.

- Send flow: application calls post_send() with QP and a WR. In the software
  based approach the QP context is retrieved, the WR is parsed and a proper IB
  packet is formed to be put in hardware buffers. In hardware based approach the
  driver puts the WR in hardware buffers with a handle to the QP and hardware
  does the rest.
- Receive flow: a data packet is received and put in hardware buffers (assume
  that the destination is a RC QP). In software based approach the packet is
  handed to the driver. The driver retrieves the context by QPN, decides if
  ACK/NACK packet is required (if so, generates it) and decides if CQE is
  required on the CQ of the QP. In the other approach the hardware compares
  the packet to the state in the context, generates the ACK/NACK and raises an
  event to the driver that CQE is ready for reading.

Figure A2 illustrates hardware/software relationship in the implementation of a
IB transport solution in the software based approach.

          +----------------------------+
          |  IB transport              |
          |  capable driver            |
          |                            |
          |  +----------------------+  |
          |  |Context (deep)        |  |
          |  |                      |  |
          |  +----------------------+  |
          |                            |
          |  +----------------------+  |
          |  | Logic (IB transport) |  |
          |  |                      |  |
          |  +----------------------+  |
          |                            |
          |  +----------------------+  |
          |  | Interface            |  |
          |  |                      |  |
          |  +----------------------+  |
          +----------------------------+
                        |
                        |
          +----------------------------+
          |  +----------------------+  |
          |  | Interface            |  |
          |  |                      |  |
          |  +----------------------+  |
          |                            |
          |  +----------------------+  |
          |  | Context (shallow)    |  |
          |  |                      |  |
          |  +----------------------+  |
          |                            |
          |  +----------------------+  |
          |  | Logic (link layer)   |  |
          |  |                      |  |
          |  +----------------------+  |
          |                            |
          |  IB transport              |
          |  incapable NIC             |
          +----------------------------+
A2 - software based approach for IB transport implementation

The rest of this paper is focused on IB transport solutions that are based on
software

B. Common software based IB transport solution
--------------------------------------------------------------------------------
In hardware based solutions the software driver implementation is tightly tied
to the hardware. Therefore, for different hardware types there is hardly a
common part to all software driver. In software based solutions things are
different. For such, since hardware capabilities are limited and implement only
the lower layer(s) of the OSI model and transport layer is done in the software.
In that case the common part between all drivers is quite large and is actually
the implementation of the InfiniBand transport specification.
The immediate conclusion is that we can take one software driver and
theoretically match it to any hardware with some (obvious and less obvious)
adjustments.
Taking this one step forward yields another conclusion that only one
IB transport software driver can be designed to work with all types of
hardware back-ends, if we supply a well defined abstract interface
between the IB
transport driver and a theoretical model of hardware that all real hardware can
fit to.

The structure of the generic InfiniBand driver and its placement in the IB
stack layer model is as Figure B1 describes

+-----------------------------------------------+
|                                               |
|  IB core drivers                              |
|                                               |
+------------^-----------+--+--+----------------+
             |           |  |  |
 ib_register_device()    |  |  | Abstract interface
             |           |  |  |
+------------+-----------v--v--v----------------+
|  Gneric IB         +--------------+           |
|  driver            |Abstract      |           |
|                    |interface     |           |
|  +--------------+  |implementation|           |
|  | Context &    |  +--------------+           |
|  | Logic        |                             |
|  |              |                             |
|  +--------------+                             |
+-----^-----------------------------^--------+--+
      |        |                    |        |
      |        |                API |        | Abstract interface
      |        |                    |        |
      |        |                    |        |
      |        |                    |        |
+-----+--------v------+   +---------+--------v--+
| HW device driver A  |   | HW device driver B  |
| (specific)          |   | (specific)          |
|                     |   |                     |
+---------------------+   +---------------------+

B1 - Generic InfiniBand driver structure & layout

To the layer above it, ib_core, the generic driver registers a new
ib_device and implements all the mandatory verbs(as in
 ib_device_check_mandatory()). To the layer below, the thin hardware
specific driver, the generic driver declares an abstract interface that
supplies API functions as we will describe later in this document.

In addition, all SW providers may share a single common user-space provider,
since there is no direct interaction between user-space and HW.

C. Requirements from the generic InfiniBand driver
-----------------------------------------------------------------------------
To achieve its goal, be a single IB transport implementation for any back-end
driver, the generic driver is required to the following

- Offer in implementation to the  InfiniBand Architecture Specification as
  described in chapters 9 (TRANSPORT LAYER) and 10 (SOFTWARE TRANSPORT
  INTERFACE)
- Offer an implementation to the to the  ib_core abstract interface as
  described in InfiniBand Architecture Specification chapter 11 (SOFTWARE
  TRANSPORT VERBS)
- Have the ability to build and validate network and link layer headers as
  described in the InfiniBand Architecture Specification chapters 7 (LINK LAYER)
  and 8 (NETWORK LAYER) and as described in Annex A16 (RoCE) and Annex A17
  (RoCEv2)
- Define an abstract interface that a hardware driver needs to implement. This
  interface needs to be general enough in the functions it requires all to
  implement but flexible enough in the functions it allows to implement.
- Supply an interface for hardware  drivers for the  opposite direction
  interaction

Note: at the time when this RFC was written there are 3 software based IB
transport solutions: QIB, hfi1 and SoftRoCE.

D. The abstract back-end driver
-----------------------------------------------------------------------------
Before we proceed to define the interface between the generic driver and the
hardware driver we should understand what the hardware is capable of and
what it is not. In fact, since hardware can offer many offloading features
that we can't predict now we need categorize the functions in the abstract
interface to two, those that must be implemented by the back-end drive and
those that may be implemented. The most simple back-end driver, the one that
doesn't have any offloading capabilities, will implement only the set of
mandatory functions. Back-end driver that have some kind of offloads or require
more complex flows can implement some of the  optional functions and notify the
generic driver  about that.
For example, if a network driver has an optimization for sending small packets
it can implement a set of functions for a small packet flow (we leave the
question what this flow is made of unanswered here) that the generic driver will
use. Of course, any function in the abstract interface, even if it is optional,
should be as general as can be so it would fit as many as other
hardware drivers.

Among the common capabilities that a hardware driver must implement we find
- Detect new hardware on the PCI bus
- Put a packet on the wire from a buffer
- Receive a packet from the wire to a buffer
- Capture hardware events

E. The generic InfiniBand driver lower interface
--------------------------------------------------------------------------------
After discussing the general model of the back-end driver we are ready to define
the interface. From the generic driver to the hardware driver the
interface should
be abstracti, i.e. the generic driver defines what he expects from the driver to
implement,mandatory or optional.
>From the hardware driver to the  generic driver the relation is many to one and
therefore the interface should have the form of an API.  Tablas  E1 and E2 lists
the interfaces

+------------------+---------------------------------------------------+
| Name             | Description                                       |
|==================|===================================================|
|register()        |tell generic driver that new hardware is present   |
|------------------|---------------------------------------------------|
|unregister()      |tell generic driver that hardware was removed      |
|------------------|---------------------------------------------------|
|receive()         |receive a packet from the wire                     |
|------------------|---------------------------------------------------|
|handle_event()    |notify about hardware event                        |
+----------------------------------------------------------------------+

Table E1 - The  back-end to generic driver interface

+------------------+---------------------------------------------------+
| Name             | Description                                       |
|==================|===================================================|
|send()            |put packet on the wire                             |
|------------------|---------------------------------------------------|
|query_link()      |report link state and properties                   |
+----------------------------------------------------------------------+
|node_guid()       |get GUID of node                                   |
+-----------------------------------------------------------------------
|port_guid()       |get GUID of port                                   |
+-----------------------------------------------------------------------
|mcast_add()       |register multicast address                         |
+-----------------------------------------------------------------------
|mcast_del()       |unregister multicast address                       |
+-----------------------------------------------------------------------
|alloc_qpn()       |allocate a new QP number                           |
+-----------------------------------------------------------------------
|get_send_buffer() |allocate a buffer for send operation               |
+-----------------------------------------------------------------------

Table E2 - The generic driver to back-end driver interface

Following is a detailed description for the functions above

+---------------------------------------------------------------------------------+
|Name:          |register
           |
|---------------------------------------------------------------------------------|
|Description:   |notify about a new instance of the hardware.
           |
|---------------------------------------------------------------------------------|
|Input:         |- pointer to hardware description struct
           |
|               |- pointers to abstract interface implementation
struct           |
|---------------------------------------------------------------------------------|
|Output         |- registration handle
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name:          |unregister
           |
|---------------------------------------------------------------------------------|
|Description:   |notify that hardware instance is gone
           |
|---------------------------------------------------------------------------------|
|Input:         |registration handle
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name:          |receive
           |
|---------------------------------------------------------------------------------|
|Description:   |get a packet from the wire. When done notify the
caller          |
|---------------------------------------------------------------------------------|
|Input:         |-buffer for the packet
           |
|               |-buffer length
           |
|               |-pointer to receive done function
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name:          |handle_event
           |
|---------------------------------------------------------------------------------|
|Description:   |pass hardware event for processing
           |
|---------------------------------------------------------------------------------|
|Input:         |-registration handle of the device
           |
|               |-event type
           |
|               |-event data struct
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name:          |send
           |
|---------------------------------------------------------------------------------|
|Description:   |transmit one packet. When done, notify the caller
           |
|---------------------------------------------------------------------------------|
|Input:         |- pointer to headers buffer
           |
|               |- headers buffer length
           |
|               |- pointer to scatter gather struct
           |
|               |- pointer to xmit_done() function
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name:          |query_link
           |
|---------------------------------------------------------------------------------|
|Description:   |query link state
           |
|---------------------------------------------------------------------------------|
|Input:         |- device identifier
           |
|               |- port index
           |
|---------------------------------------------------------------------------------|
|Output         |- pointer to port state struct
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name           |node_guid()
           |
|---------------------------------------------------------------------------------|
|Description    |get 64 bit node guid
           |
|---------------------------------------------------------------------------------|
|Input:         |-device identifier
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |node GUID
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name           |port_guid
           |
|---------------------------------------------------------------------------------|
|Description    |get 64 bit
           |
|---------------------------------------------------------------------------------|
|Input:         |-device identifier
           |
|               |-port index
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |port GUID
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name           |mcast_add
           |
|---------------------------------------------------------------------------------|
|Description    |open device for multicast address
           |
|---------------------------------------------------------------------------------|
|Input:         |-device identifier
           |
|               |-address
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name           |mcast_del
           |
|---------------------------------------------------------------------------------|
|Description    |close device for multicast address
           |
|---------------------------------------------------------------------------------|
|Input:         |-device identifier
           |
|               |-address
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |success/failure
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name           |alloc_qpn
           |
|---------------------------------------------------------------------------------|
|Description    |get unique QP number
           |
|---------------------------------------------------------------------------------|
|Input:         |
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |QP number
           |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Name           |get_send_buffer
           |
|---------------------------------------------------------------------------------|
|Description    |allocate buffer that will be used to send a patcket
           |
|---------------------------------------------------------------------------------|
|Input:         |-length
           |
|---------------------------------------------------------------------------------|
|Output         |
           |
|---------------------------------------------------------------------------------|
|Return         |pointer to a buffer
           |
+---------------------------------------------------------------------------------+
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
