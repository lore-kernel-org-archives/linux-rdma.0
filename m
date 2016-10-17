From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Mon, 17 Oct 2016 13:14:48 -0600
Message-ID: <20161017191448.GC8122@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
 <a6c8091e-fe83-8413-77d7-4aac053b8e62@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a6c8091e-fe83-8413-77d7-4aac053b8e62-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 17, 2016 at 02:56:37PM -0400, Doug Ledford wrote:
 
> Since it got snipped, I'm pretty sure it just lists opensm in the Wants=
> tag.  With systemd, that's a soft dependency.  Only if opensm is
> installed and configured to start anyway does systemd then order this
> item after opensm.  Since you need opensm for links to come up anyway,
> it makes sense for the order of startup for RDMA related items to be:

Daemons should not require opensm to be started to operate
correctly.

If they do we surely have a boot race bug that should be fixed,
because we cannot rely on a remote SM to have configured the port the
time window betweeen rdma.service completion and dependent service
start.

So I view every use of a opensm dependent in a unit file as either
unnecessary or working around a bug.. Lets ID the bugs so we at least
know where we stand..

Plus, there are more SM's than opensm, so we really should not
hardwire a single SM in the service files upstream, but try and work
with all the SMs...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
