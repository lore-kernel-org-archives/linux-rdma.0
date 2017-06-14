From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Wed, 14 Jun 2017 11:39:40 -0600
Message-ID: <20170614173940.GA15278@obsidianresearch.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-4-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB143340@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BArF5U49WQ2PcYjpSbPpQmyubJQ6vKKUer_L05QBQpT0w@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1436F6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1436F6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 14, 2017 at 05:25:42PM +0000, Hefty, Sean wrote:
> > Let's start from the root of the parsing tree. at the top level we
> > have the root of the parsing tree ("uverbs_spec_root"). The root has
> > several "type_groups", one for each "namespace".
> > Currently, two "namespace"s are declared - common and driver
> > ("vendor_chain" here, should be changed to "driver").
> > Each "type_group" contains a few "type"s. "type" has several
> > "action_group"s, one for each "namespace". Each "action_group"
> > contains several "action"s.
> > Each "action" contains groups of "attr_spec", one for each namespace.
> > Finally, "attr_spec" contains attributes ("attrs").
> > Each attribute is of one of the following classes: ptr_in, ptr_out,
> > idr or fd (in the future, we might add a few more like "flags").
> 
> Again, I think the approach looks good.  I can see *how* the
> relationships between structures are defined by looking at the
> struct definitions.  What's not clear is *why* those relationships
> exist.  I really do think trying to use standard object-oriented
> terminology helps convey the latter.

I think it will help a lot as well.

> > > type_group -> namespace (?)
> > 
> > I currently use "namespace" term to differentiate between the groups
> > of the entities. For example, in each layer of the hierarchy we
> > (possibly) have a namespace of common entities and driver-specific
> > entities.

Why do we even need this concept to have a name? At the end of the day
I thought it was just restricting what ID ranges are usable in
different parts of the code?

Just calling the numbers assigned to the driver 'driver specific ids's
woudl seem to be an improvement..

> > > type -> class or obj_class
> > 
> > I use the term "class" for the nature of the actual attributes
> > ("attrs"). Each attribute is one of the following classes: idr, fd,
> > ptr_in or ptr_out.

Those would be commonly called types..

> > > action_group -> operations or methods or functions
> > > action -> op_def or method_def or func_def
> > > attr_spec_group -> param_list or op_param_list or func_param_list
> > ...
> > 
> > I used the term "group" to emphasize that these aren't just a random
> > collection of params in a lit.
> > Grouping this entities together has a specific meaning.
>
> But *what* is that meaning?  That's what I'd like the name to
> convey.  I thought the grouping was because the attributes were a
> set of parameters being passed into a single
> function/operation/action/method.

Me too..

> > > common_chain -> common_params
> > > vendor_chain -> vendor_params
> > 
> > I agree the term "chain" is problematic. Regarding the drawing above -
> > "common_params" and "driver_params" seems fine.

.. again, remove vendor from everything, these are driver specific
things..
 
> > > TYPE_IDR -> TYPE_KOBJ (kernel object)
> > >
> > What about fds (like completion_channel)? They're KOBJs too.
> 
> How about KSTRUCT or IDR_OBJ?  The fact that we're using an IDR
> seems like an internal implementation detail of the framework.

I think it is trying to say TYPE_OBJECT_ID, TYPE_FD_NUM, etc ?

Eg it informs the user what the attribute is. In our system an object
id is a 32 bit unsigned value with ~0 as the invalid, fd is a signed
integer open fd with -1 as invalid, etc

> > >>  enum uverbs_attr_type {
> > >>       UVERBS_ATTR_TYPE_NA,
> > >> +     UVERBS_ATTR_TYPE_PTR_IN,
> > >> +     UVERBS_ATTR_TYPE_PTR_OUT,
> > >>       UVERBS_ATTR_TYPE_IDR,
> > >
> > > This is really indicating that we're dealing with a kernel object of
> > some sort, not the actual indexer.
> > >
> > 
> > Yeah, but FDs could represent kernel objects too. The meaning here are
> > kernel objects that resides in the idr.
> > What do you propose?

UVERBS_ATTR_TYPE_OBJECT_ID ?

> > >> +enum uverbs_attr_spec_flags {
> > >> +     UVERBS_ATTR_SPEC_F_MANDATORY    = 1U << 0,
> > >> +     /* Support extending attributes by length */
> > >> +     UVERBS_ATTR_SPEC_F_MIN_SZ       = 1U << 1,
> > >> +};
> > >
> > > Don't use named enums for bit flags.  The result of ORing flags ends
> > up as a non-enum value.
> > >
> > 
> > Sure

Isn't this common place in the kernel now? The enum should be
anonymous for this usage though.

There are advantages to using enums vs #define for constants..

> > >> +struct uverbs_action {
> > >> +     struct uverbs_attr_spec_group **attr_groups;

Please make sure you get your consts right so stuff can live in
rodata.. I would expect this to be const??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
