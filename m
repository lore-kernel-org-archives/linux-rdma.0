From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sun, 06 Nov 2011 02:09:30 -0800
Message-ID: <1320574170.5859.370.camel@haakon2.linux-iscsi.org>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	 <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2011-11-06 at 08:34 +0100, Bart Van Assche wrote:
> On Sat, Nov 5, 2011 at 7:04 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > On Sat, 2011-11-05 at 08:37 +0100, Bart Van Assche wrote:
> >> On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
> >> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> >> > This is the PULL request for an initial merge of the ib_srpt driver
> >> > using mainline target infrastructure into v3.2-rc1.
> >>
> >> In case anyone is interested, the most important unaddressed comments
> >> for this version of ib_srpt are:
> >> - There are still too many module parameters. This makes ib_srpt
> >> harder to use than necessary because several of these parameters can
> >> only be set at module load time.
> >
> > Can you be more specific here..?  I went through the module parameters
> > and made the ones that where used in a per-port specific context into
> > configfs attributes as Roland recommended, but it seems like you are
> > saying that more should be made into attributes.  Which ones..?
> 
> Several read-only kernel module parameters remain. That's fine in
> out-of-tree code since it will be compiled as a kernel module only.
> But anyone who tries to build with CONFIG_INFINIBAND_SRPT=y will
> notice that it's impossible to change the value of these read-only
> kernel module parameters.
> 

So after the cleanups, srp_max_req_size, srpt_srq_size and
srpt_service_guid appear as the remaining module parameters.  The first
two are required at srpt_add_one() -> srpt_device allocation time
(usually at initial load time), and should remain as global scope
parameters correct..?  To address the point with
CONFIG_INFINIBAND_SRPT=y, how about assigning these two values for each
srpt_device during srpt_add_one(), and reference them directly in
srpt_device so their respective module parameter can become S_IRUGO|
S_IWUSR...?

We have also discussed srpt_service_guid a bit before, which you
indicated needed to stay in current code as global scope, and presumably
should not change value after loading.  Looking at the actual usage, one
post merge improvement we can consider is seeing if it's possible to
move ib_cm_listen() out of srpt_add_one() and have it driven instead by
configfs context in order to optionally set srpt_service_guid on a per
target endpoint basis to get us some more flexibility. 

> >> - The last WQE event can arrive before the queue pair is reset,
> >> resulting in a hanging session and blocking future logins
> >> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg09678.html).
> >
> > Yep, was going to get this resolved post merge along with my patch now
> > in lio-core.git to address active I/O shutdown with ib_srpt.
> 
> Your "active I/O shutdown" patch does not address the "last WQE" issue.

The current patch in lio-core allows ib_srpt to push active I/O and
perform shutdown + unload without hanging (or crashing) at this point.
Active I/O tests with physical link layer failures also seems to work,
but mixing to two together still obviously needs more testing.

For the "last WQE" you've mentioned, I'm happy to accept a patch to
address this as you know the code better than me.  Otherwise, I'll be
digging this out of your out-of-tree code as a seperate item and
figuring out how to reproduce and test this special case.

> 
> >> - The "ib_srpt: Convert srp_max_rdma_size into per port configfs
> >> attribute" contradicts the I/O controller concept. This is a bug.
> >> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg09677.html).
> >
> > As mentioned in the thread, I deferred to Roland's input on that one.
> > So you're saying this should be made back into a module parameter now,
> > or what..?
> 
> I see two possible ways forward:
> - Convert the per-port max_rdma_size configfs variable into a
> per-module configfs variable.

We don't need to add any per-module configfs target variables, we
already have /sys/module/$NAME/parameters/ for that.  ;)

> - Remove the max_rdma_size variable from configfs entirely and compute
> the max_rdma_size from the HCA properties in struct ib_device_attr.
> 

What did you have in mind..?  This should be based on ->max_sge *
PAGE_SIZE, or something else from ib_device_attr..?  

Thanks,

--nab



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
