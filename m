From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Thu, 21 Apr 2016 11:24:28 -0600
Message-ID: <20160421172428.GA5102@obsidianresearch.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB044043-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 21, 2016 at 01:35:53PM +0000, Hefty, Sean wrote:
> > The kernel common code side is pretty straightforward, just a bunch of
> > tables of function pointers, templates and idrs for each object_type.
> 
> This is the part where the intent and implementation are not clear
> to me.  I see value in generic user space handle validation, but I
> prefer they map to driver specific resources.  For example, I don't
> want a user space allocation of a QP to result in this:

When we had our telephone call I did raise this as a discussion topic,
framed a little differently than you:

  Do we need any 'common' calls or should 'everything' be driver
  specific?

This is based on the observation that the current uverbs code does
very little beyond just calling a driver function pointer. So why
marshal the userspace information into common uAPI information then
marshall it again into hardware/driver information when the uAPI side
could just format it directly for hardware consumption?

** And to answer my own question: there is actually a good reason to
   continue the 'common' API - internally the uverbs/drivers use the
   kAPI to do most of the work. An incremental API transformation
   requires us to continue to provide that basic flow or face a
   daunting task of radically upgrading every single driver!

> monstrosity being allocated in the kernel.  The size and layout of
> this sort of structure impacts scalability and performance.  This is
> where I want to make sure there's alignment on the overall
> architecture.

Your observation that uAPI users don't need the kapi struct ib_qp is
along the same lines and very valid. Could the driver build a more
efficient struct?

The flip side is that the entire kAPI related to a verbs qp in the
driver becomes duplicated, one side presents the kAPI verbs and the
other side presents the driver-specific ioctl uAPI for the same
functionality.

Obviously this is a radical direction away from the uapi we have
today. Today they all code share and the uverbs translates the uAPI to
the kAPI and back again so drivers only have to implement the kAPI to
get u/k verbs support.

Within the basic sketch I presented there are two basic ways to
address this:
  1) Allow the driver to override RDMA uAPI object call backs
     directly.
     A driver could replace the entire uAPI QP object with its
     own code. The default implementation would be the existing scheme
     that translates the uAPI to the kAPI.
     The driver code could do whatever it wants and isn't required to
     implement the 'struct ib_qp' to get there.
     In this case the driver must still implement the common uAPI for
     verbs QP objects.
  2) Allow the driver to provide a 'driver specific QP' object which
     does not follow the common uAPI. This is a new object that would
     only be used by the driver specific library, and like the above
     totally bypasses all of the standard kAPI design.

That said - there are clearly some important services that core code
is providing, locking, idrs, hot-removal, auto-deletion, things like
comp channels, etc. These are object agnostic and even if you have a
driver specific object they still have to be cared for.

I'm guessing some hybrid is going to be best, eg simple objects like a
verbs PD could be handled through common code calling the kAPI for all
drivers and complex very driver-specific objects like MRs, AHs or QPs
are better routed directly to the driver without using the kapi.

I'm also very concerned to give driver authors a 'free reign' to
design their driver-specific uAPIs, because historically it has been
proven across the kernel that driver authors do a bad job of that kind
of work :( Thus encouraging drivers to stick with the #1 approach as
much as possible should be encouraged, and all examples of #2 has to
be reviewed by the core maintainer group (eg to ensure someone doesn't
try to access EEPROM over this interface :P )

> More specifically, I would switch the existing uABI commands to
> ioctl's, leaving the code paths mostly unchanged, but marking them
> as legacy.  Then add the new ioctls that you suggested, with future
> drivers hooking directly into the ioctl framework.

In an ideal world, I would like to not retain the existing uABI in the
current format. We may decide that is just too much work, but as a
goal..

We already have to maintain it exactly as is (with write) for a long
time, adding another copy that is ioctl based and has to live forever
doesn't seem great :( Maybe the compromise is to use this scheme to
carry the existing struct as the base attribute?

The reason is a little nuanced - I see #1 as the desired path, so we
still have to define this common uAPI for the industry-standard
objects. If we migrate to it then the kernel side can be optimized at
our leisure and there is a very nice incremental transition. Further,
we have only one set of code to maintain in the kernel, and the kernel
uAPI/kAPI default implementation becomes the necessary reference for
driver authors seeking the optimize it.

I think some coding experiments are going to be needed to qualify the
various options.

As a starting point, I am thinking of something along the lines of:

struct ib_device {
   [ .. ] 
   /* During 'ib_device_register' this array is allocated. The driver
      provided ops and common ops merged into one table for
      performance. */
   struct rdma_uapi_class *class_data;
}

struct rdma_uapi_object_data {
   struct .. idr ..
   .. locking ..
   etc
};

struct rdma_uapi_context {
    struct rdma_uapi_object_data *object_data; // Indexed same as class_data
}

typedef int (*rdma_uapi_cb)(struct rdma_uapi_context *,const rdma_object_hdr *imsg,omsg);
struct rdma_uapi_class {
    rdma_uapi_cb create_object;
    rdma_uapi_cb query_object;
    rdma_uapi_cb modify_object;
    rdma_uapi_cb destroy_object;
    rdma_uapi_cb object_specific[4];
    rdma_uapi_cb driver_specific[4];
    uint32_t class_id;
};

core/uapi_verbs.c:

static const struct rdma_uapi_class verbs_uapi_ops[] {
  {.class_id = RDMA_OBJECT_DEVICE, driver_query},
  {.class_id = RDMA_OBJECT_PORT, port_query},
  {.class_id = RDMA_OBJECT_QP, qp_create,qp_query,qo_modify,qp_destroy},
  {.class_id = RDMA_OBJECT_PD, pd_create,qp_query,qp_modify,qp_destroy},
};

/* And perhaps if necessary have common, ib, iwarp, rocee, opa
   versions of these functions for optimal performance */

core/uapi_XXXX.c:

// Future new multi-vendor uAPI
static const struct rdma_uapi_class XXX_uapi_ops[] {
  {.class_id = RDMA_OBJECT_XXX1, },
  {.class_id = RDMA_OBJECT_XXX2, },
};

hw/driver.c:

static const struct rdma_uapi_class driver_uapi_ops[] {
  // Override what uapi_verbs is providing
  {.class_id = RDMA_OBJECT_QP, driver_create,driver_query,driver_modfiy,driver_destroy},
  {.class_id = RDMA_OBJECT_PD}, // NULL, use standard
};

hw/drivers/hfi1.c

// Replaces the char dev:
static const struct rdma_uapi_class hfi_uapi_ops[] {
  // Driver directly provides its own object
  {.class_id = RDMA_OBJECT_HFI1_CTXT,
   .create_object = assign_ctxt,
   .query_object = get_ctxt_info,
   .destroy_object = hfi1_cmd_ctxt_reset,
   .object_specific = {
       [HFI1_CMD_RECV_CTRL] = ...,
       ..
   },
  },
}

core/uapi_common.c:

static const struct rdma_uapi_class common_uapi_ops[] {
  /* Format the content of class_data so userspace can figure out what
     the kernel supports. */
  {.class_id = RDMA_OBJECT_INTERFACE, query_classes},
}

int fops_ioctl(... )
{
	const struct rdma_object_hdr *hdr = copy_from_user(udata)
	struct rdma_uapi_context *ctx = fops->private_data;

	if (hdr->class_id >= ctx->device->class_data_len ||
	    hdr->op_id >= MAX_OP_ID)
	    return EOPNOTSUPP;

        const struct rdma_uapi_class *class = ctx->device->class_data[hdr->class_id];
        // Direct-index the labeled function pointer scheme as an array for performance
        rdma_uapi_cb target = ((rdma_uapi_cb)class)[hdr->op_id];
	if (target == NULL)
	    return EOPNOTSUPP;

        /* There should probably be a little bit more support here,
	   eg common code to access the object-specific IDR, hold
	   things like the rw sem for hot-removal, basic parse and validate
	   the message. But this is the basic idea */
        return target(ctx,....);
}

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
