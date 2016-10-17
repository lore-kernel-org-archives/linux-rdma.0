From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Mon, 17 Oct 2016 12:56:57 -0600
Message-ID: <20161017185657.GA8122@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161017182037.GK14983-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 17, 2016 at 02:20:37PM -0400, Jarod Wilson wrote:

> > > > > diff --git a/glue/redhat/ibacm.service b/glue/redhat/ibacm.service
> > > > > new file mode 100644
> > > > > index 0000000..1cd031a
> > > > > +++ b/glue/redhat/ibacm.service
> > > > 
> > > > Can we just put this in ibacm/ ?
> > > 
> > > Probably.
> > 
> > Okay, the only thing I really don't like being upstream is the
> > opensm.service..
> > 
> > Do you know why acm needs that?
> 
> I think Doug already attempted to address this elsewhere in the thread,
> and he'd know better than me.

srp_daemon not being able to handle a change in prefix makes sense.

But that doesn't explain what problem ibacm has..

To my mind, depending on something like opensm indicates the daemon
has a bug - eg it cannot handle dynamic subnet changes. So lets at
least be clear on what the bugs we are working around are, ask if they
have been fixed, etc.

Sean, do you know why ibacm would need to be started after opensm?

> > Okay. The trick will be to standardize the systemd_wants name ..
> 
> Perhaps rdma-core should go with rdma-core.service? We were shipping a
> package called 'rdma' that carried that.

Maybe, but I'd like to have an overall systemd plan..

If we can't have a .target then sure, this is probably the best
way..

> > rdma-ndd dynamically sets the NodeDescription to the hostname in the
> > adaptor for the subnet manager/tools to ready. I guess this hunk is
> > setting the NodeDescription one-shot at boot..
> 
> Rather than having this janky udev rule, what if we simply made rdma-ndd
> part of what's installed with rdma-core, rather than something found in
> yet another infiniband package? (Looks like it's in infiniband-diags,
> wasn't even aware rdma-ndd existed until looking at this here).

Yep, very good idea.

Ira? What do you think?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
