From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] RDMA verbs transport design notes
Date: Mon, 2 Nov 2015 15:46:52 +0200
Message-ID: <CAG9sBKOEs_u-YVTwS=Gk2sxRCqV+Wsdh1PyNy+baf3EBSCSbTA@mail.gmail.com>
References: <20151029194129.GE26235@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151029194129.GE26235-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2015 at 9:41 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi Folks,
>
> I had previously posted a notice about the very beginnings of the rdmavt
> driver which is the software verbs consolidation for multiple drivers [1].
> I have  now pushed another set of updates to a GitHub repo [2] which
> contains more details.  What this latest batch of patches entail is a
> stubbed out version with annotations in the comments as to what the
> interaction between drivers and rdmavt will look like. Look for lines like:
>
Thanks Denny
We will pull from GitHub, learn the design and hopefully contribute.
Some minor comments below

> VT-DRIVER-API
>
> The following is a summary of the current posted code and the direction
> which we are thinking of going based on knowledge of qib and hfi1 drivers.
> Feedback and suggestions are welcome.
>
> Design Goals
> ------------
> - Remove duplication of software verbs code present in multiple drivers.
> - Do not regress performance.
>
> Registration and general code flow
> ----------------------------------
> Instead of registering directly with the IB core like they do now, drivers
> will register with the rdmavt, referred to as rvt in the code. Drivers will
> build up the ib_device_attr and pass in to the registration by way of the
> rvt_dev_info struct. This will also contain any other driver specific
> settings that rvt will need to know about.
>
> Currently allocation of the ib_device is done by the driver. This is merely
> a stepping stone, and eventually the allocation will move up to rvt. The
> driver should not need to know about the ib_device structure eventually,
> other than for those functions it chooses to override
>
> In addition to describing its properties, drivers will supply a mapping of
> function pointers for use by rvt. The idea is that most of the verbs code
> lives in rvt, but there are some device specific functions which drivers
> will need to perform, such as pushing packets to the wire. Rvt will
> accomplish its tasks by calling into the drivers for these.
>
> There are also times when drivers will need to call back into rvt. We should
> aim to limit this as much as possible. For things like a packet arriving
> from the wire we have no choice but for the driver to initiate the
> processing and call into (or signal in some way) rvt.
>
> Driver override
> ---------------
> Drivers need to be able to override functions that would normally be done by
> the rvt. In the current set of patches this is accomplished by filling in a
> value in the ib_device_attr function pointer map. If the value is NULL then
> rvt uses its function, otherwise rvt is bypassed by the core and the driver
> is called directly.  Performance optimizations could be one reason, another
> is incremental development. We can work on moving a driver over to rvt in
> stages.
>
> Driver provided functionality
> -----------------------------
> This list will likely grow as the code evolves but as a first pass through
> these are the things which I see as needing to be provided by the driver:
>
> query_port_state()
>         Returns pretty much what is in ib_port_attr
>         Will differ based on driver
>
> set_link_state()
>         For rvt to have the driver set the state of the link
>
> get_lid()
>         Provides the LID
>
LID is a special case of L2 address (MAC is another special case)
Maybe change this to het_l2()?

> qp_mtu()
>         Using the SL determines the MTU (this varies per VL in OPA)
>
Again, this is too tied to the InfiniBand protocol.
Also, It doesn't make sense to me that a driver won't know how to
create a QP (this is done by the rvt) but will know how to answer
about QP mtu. Does it?

> make_qpn()
>         QPN ranges differ for drivers
>
> flush_qp()
>         Flush out all pending operations for a QP that have not made it the
> wire, and wait for that flush to finish.
Again, needs generalization

> do_send()
>         Take a fully constructed packet and place on the wire
>
The hardest operation of all IMO.
Should  be efficient but yet general
> Other functions for things like maintaining MAD counters perhaps.
>
> Driver notification or upcall to rvt
> ------------------------------------
> Certain things will require the driver to notify the rvt or execute some
> function. For instance, the driver needs to hand the packet to rvt after it
> pulls it off the wire.
>
> There are also event which the driver needs to let rvt know have happened.
> Things that currently generate IB_EVENT_PORT_ERROR, or IB_EVENT_PORT_ACTIVE,
> etc. There are likely other events as well.
>
> Next steps
> ----------
> We will continue posting code to GitHub [2] while we field feedback. Note
> the repo has been moved from my previous announcement [1]. I have placed it
> under my GitHub. Once there is more significant development and folks are
> generally happy with the design we will begin posting to this mailing list
> (linux-rdma).
What's the minimal progress in the rvt and the drivers before you
think it's ready for posting to the list?
>
> The current branch on [2] is rdmavt-v1. I'll bump this whenever a rebase
> is needed.
>
> [1] http://marc.info/?l=linux-rdma&m=144563342718705&w=2
> [2] https://github.com/ddalessa/kernel/tree/rdmavt-v1
>
> Thanks
>
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
