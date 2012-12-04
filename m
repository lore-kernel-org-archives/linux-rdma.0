From: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Remove Red Hat-ism.
Date: Tue, 4 Dec 2012 08:40:13 -0500
Message-ID: <CALY6xnj_OYpQFiCSC4T3cY3yup6ZXXJR=QDDCaJN96gEyvFP5w@mail.gmail.com>
References: <1354566498-8364-1-git-send-email-jonstanley@gmail.com> <20121203223547.GA3410@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121203223547.GA3410-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 3, 2012 at 5:35 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> This looks like it is a bashism (ie dash does not do this), so you
> should update the #! to use /bin/bash not /bin/sh...

But Garrett just committed something a few days ago to remove
bash-isms, and I'd hate to reintroduce one for this trivial thing.
More specifically, here's what's going to happen in Fedora-land, and
isn't in RHEL6:

The /etc/sysconfig/network file goes away, and is replaced (for our
purposes) with /etc/hostname ,which contains the short name of the
hostname. The way I figure it, we can get the hostname one of a few
ways here:

1) Blindly trust that the set hostname is correct (i.e. what the
hostname(1) command returns is what we should be using)
2) Read /etc/hostname in a subshell (the HOSTNAME= no longer exists,
so it can't be sourced)
3) Fall back on /etc/sysconfig/network if we don't find /etc/hostname
if we go with 2.

Thoughts?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
