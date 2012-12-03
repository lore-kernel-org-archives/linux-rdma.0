From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Remove Red Hat-ism.
Date: Mon, 3 Dec 2012 15:35:47 -0700
Message-ID: <20121203223547.GA3410@obsidianresearch.com>
References: <1354566498-8364-1-git-send-email-jonstanley@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1354566498-8364-1-git-send-email-jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 03, 2012 at 03:28:18PM -0500, Jon Stanley wrote:
> Future release of Fedora are going to remove /etc/sysconfig/network
> which we source to get $HOSTNAME. Bash (and sh) set $HOSTNAME in
> the shell by default, so we should be safe to use that here. This
> adds the benefit of working across multiple distributions if that
> is required in the future.

This looks like it is a bashism (ie dash does not do this), so you
should update the #! to use /bin/bash not /bin/sh...

$ HOSTNAME= /bin/dash 
\h{\u}\w#echo $HOSTNAME

\h{\u}\w#

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
