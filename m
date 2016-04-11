From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH v2 00/13] SELinux support for Infiniband RDMA
Date: Mon, 11 Apr 2016 14:11:55 -0600
Message-ID: <20160411201155.GC371@obsidianresearch.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459985638-37233-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 07, 2016 at 02:33:45AM +0300, Dan Jurgens wrote:

> Currently there is no way to provide granular access control to an Infiniband
> fabric.  By providing an ability to restrict user access to specific virtual
> subfabrics administrators can limit access to bandwidth and isolate users on
> the fabric.

Do you actually have a concrete use case for this?

This seems superficially similar to netlabel, which I guess targets a
certain niche, but I'm really wondering with all the other container
patches if this was supposed to be done with namespaces...

> An Infiniband device (ibdev) is labeled by name and port number.  There is a
> single access vector for ibdevs as well, called "smi".

This is called an End Port (SMI is something else in the IB
spec). Please use the standard terminology.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
