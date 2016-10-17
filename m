From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Mon, 17 Oct 2016 19:10:46 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24F0A408@CRSMSX101.amr.corp.intel.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
 <20161017185657.GA8122@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017185657.GA8122-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
> > > rdma-ndd dynamically sets the NodeDescription to the hostname in the
> > > adaptor for the subnet manager/tools to ready. I guess this hunk is
> > > setting the NodeDescription one-shot at boot..
> >
> > Rather than having this janky udev rule, what if we simply made
> > rdma-ndd part of what's installed with rdma-core, rather than
> > something found in yet another infiniband package? (Looks like it's in
> > infiniband-diags, wasn't even aware rdma-ndd existed until looking at this
> here).
> 
> Yep, very good idea.

Yep, very good idea...

> 
> Ira? What do you think?

Yes, I've been trying to find time to make a patch which adds rdma-ndd into the rdma-core.  I absolutely agree it should be part of rdma-core as it is much better than the 1 time shot of the start up scripts.

What I have been worried about is conflicts between infiniband-diags and the new rdma-core.  RH made a separate package out of rdma-ndd so that would be easy but I don't think other distros have.

So how do you obsolete "part" of a package?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
