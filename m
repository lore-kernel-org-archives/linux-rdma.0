From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] rdma-core infrastructure
Date: Fri, 14 Oct 2016 16:33:08 -0600
Message-ID: <20161014223308.GA16509@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 03:21:32PM -0400, Jarod Wilson wrote:
> This is a set of patches to make some minor changes to the stock spec file,
> add a bunch of userspace glue that Red Hat has been shipping on it's own in
> Red Hat Enterprise Linux and Fedora for a while now, and a revised split
> package spec file that we're likely to use in at least RHEL, to preserve the
> current packaging split.

Is this just for EL7, or do you plan to keep going this way
indefinitely in EL8 and FC25?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
