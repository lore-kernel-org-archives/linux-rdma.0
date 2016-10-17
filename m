From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] rdma-core infrastructure
Date: Mon, 17 Oct 2016 11:43:46 -0400
Message-ID: <20161017154346.GF14983@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014223308.GA16509@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014223308.GA16509-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 04:33:08PM -0600, Jason Gunthorpe wrote:
> On Fri, Oct 14, 2016 at 03:21:32PM -0400, Jarod Wilson wrote:
> > This is a set of patches to make some minor changes to the stock spec file,
> > add a bunch of userspace glue that Red Hat has been shipping on it's own in
> > Red Hat Enterprise Linux and Fedora for a while now, and a revised split
> > package spec file that we're likely to use in at least RHEL, to preserve the
> > current packaging split.
> 
> Is this just for EL7, or do you plan to keep going this way
> indefinitely in EL8 and FC25?

Kind of TBD at the moment. We could probably go either way for Fedora and
a new EL major release.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
