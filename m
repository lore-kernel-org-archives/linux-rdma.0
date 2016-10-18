From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Tue, 18 Oct 2016 10:51:04 -0400
Message-ID: <20161018145104.GT14983@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
 <20161017185657.GA8122@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0A408@CRSMSX101.amr.corp.intel.com>
 <20161017201309.GA24291@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161017201309.GA24291-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 17, 2016 at 02:13:09PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 17, 2016 at 07:10:46PM +0000, Weiny, Ira wrote:
> 
> > What I have been worried about is conflicts between infiniband-diags
> > and the new rdma-core.  RH made a separate package out of rdma-ndd
> > so that would be easy but I don't think other distros have.
> 
> > So how do you obsolete "part" of a package?
> 
> The distros know how to do this, they just conflict with the old
> version of infiniband-diags.

Yeah, basically, you spin up a new infiniband-diags package that doesn't
have rdma-ndd and a new rdma-core package that includes it, along with (in
rpm-ese) 'Conflicts: infiniband-diags < <first version w/o rdma-ndd>', and
that should pretty much cover it.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
