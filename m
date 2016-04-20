From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Further thoughts on uAPI
Date: Tue, 19 Apr 2016 19:25:26 -0600
Message-ID: <20160420012526.GA25508@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thinking more deeply about what Liran presented, we can go a bit
further and multiplex on the object type as well as the action.

Specifically, let's have generic ioctl of the form:

  create_object
  query_object
  modify_object
  delete_object

Generically taking the same common struct:

  struct {
     u32 length;
     u32 object_type; // Eg QP,PD,etc
     u32 user_handle; // in/out
     u32 reserved;
     u64 data[];
  };

Where data follows some kind of structured attribute format like Liran
was exploring ala netlink.

>From this point we can obviously capture nearly all of the verbs
objects, but this also can become a clean way for us to allow drivers
to export driver-specific objects as well. (eg object_type & (1<<31)
== driver specific)

With one more entry point (call_driver_on_object) this would cover a
lot of cases. Maybe we have many such entry points for performance.

>From there we'd probably have to define a few other common up calls.

Study of objects:
 'device','port' - Pre-existing and read-only, query_object returns
                   information like we have today
 'pd','mr','mw','cq','srq','qp','ah' - Basic objects, not all have a modify/query
 'flow','xrc',etc - extra objects
  
Additional entry points:
 poll_cq/req_notify_cq - These are high speed, so simple ioctls, or
                         driver specific
 post recv/send - drivers implement these via call_driver_on_object
 attach/detach mcast - Could be 'modify' a qp, or could be new ioctls
 async_event - Should be an ioctl
 get_fd - Convert the object to a fd (eg async_fd, comp_channel, etc)
 
I think this would substantially address the concern that the uapi is
'verbs' or 'qp' specific. Clearly there is space here for any number
of object families related to RDMA devices.

It is also discoverable since we can have a query_object that returns
all 'object_types' the device driver supports.

Sean, is this more agreeable to you than the unstructured fd idea?

The kernel common code side is pretty straightforward, just a bunch of
tables of function pointers, templates and idrs for each object_type.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
