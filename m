From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Wed, 20 Apr 2016 04:54:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB043A73@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160420012526.GA25508-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Specifically, let's have generic ioctl of the form:
> 
>   create_object
>   query_object
>   modify_object
>   delete_object
> 
> Generically taking the same common struct:
> 
>   struct {
>      u32 length;
>      u32 object_type; // Eg QP,PD,etc
>      u32 user_handle; // in/out
>      u32 reserved;
>      u64 data[];
>   };
> 
> Where data follows some kind of structured attribute format like Liran
> was exploring ala netlink.
> 
> From this point we can obviously capture nearly all of the verbs
> objects, but this also can become a clean way for us to allow drivers
> to export driver-specific objects as well. (eg object_type & (1<<31)
> == driver specific)
> 
> With one more entry point (call_driver_on_object) this would cover a
> lot of cases. Maybe we have many such entry points for performance.
> 
> From there we'd probably have to define a few other common up calls.
> 
> Study of objects:
>  'device','port' - Pre-existing and read-only, query_object returns
>                    information like we have today
>  'pd','mr','mw','cq','srq','qp','ah' - Basic objects, not all have a
> modify/query
>  'flow','xrc',etc - extra objects
> 
> Additional entry points:
>  poll_cq/req_notify_cq - These are high speed, so simple ioctls, or
>                          driver specific
>  post recv/send - drivers implement these via call_driver_on_object
>  attach/detach mcast - Could be 'modify' a qp, or could be new ioctls
>  async_event - Should be an ioctl
>  get_fd - Convert the object to a fd (eg async_fd, comp_channel, etc)
> 
> I think this would substantially address the concern that the uapi is
> 'verbs' or 'qp' specific. Clearly there is space here for any number
> of object families related to RDMA devices.
> 
> It is also discoverable since we can have a query_object that returns
> all 'object_types' the device driver supports.
> 
> Sean, is this more agreeable to you than the unstructured fd idea?

I need to give this more thought, but the general outline seems reasonable.  And I like the generic structure of the ioctl's.

The architecture I was envisioning was something along the lines of having an "rdma_uabi" module.  (And I honestly don't care what things are called; we're abusing names all over.  I'm avoiding the term uverbs because the functionality and structure is different.)  Drivers would plug _directly_ into that module.  This is separate from whatever kernel interfaces that the driver plugs into.  IOCTL dispatch would then go directly to the drivers.  A driver could set its ioctl dispatch to some common kernel function, call core functionality, or just implement what it needs.

Basically, I'm viewing the rdma_uabi as a generic mechanism to export hardware specific interfaces -- be it queue pairs, command queues, or whatever, versus exporting a kernel software interface, like umad or rdma_ucm do.  For better or worse, each hardware driver could independently export their device capabilities.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
