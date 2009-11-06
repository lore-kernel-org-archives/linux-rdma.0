From: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: StorNext/OFED incompatible? (missing find_exported_dentry in
	exportfs.ko)
Date: Fri, 6 Nov 2009 15:10:05 -0600
Message-ID: <20091106211004.GA14448@opengridcomputing.com>
References: <4AF48157.904@super.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF48157.904-68lYvLNOm//YtjvyW6yDsg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Craig Reese <cfreese-68lYvLNOm//YtjvyW6yDsg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 06, 2009 at 03:04:39PM -0500, Craig Reese wrote:
>
>
> I've been running around in circles trying to get StorNext 3.5.1 working
> on a machine with OFED 1.4.1.  Until now StorNext always fails to
> start saying that its missing symbol 'find_exported_dentry".  I now think
> I've figured out that this is because OFED 1.4.1 (and it looks like 1.4  
> an 1.4.2)
> rebuilds its own exportfs.ko module and this is not a superset of
> the code in the RedHat 5u3 exportfs.ko module.
>
> Is there an easy fix for this?  In addition to leaving some things out,
> it appears that OFED changes some of the existing function signatures
> so I don't see a straightforward way to merge the two.
>

exportfs is needed by NFS.  Since OFED 1.4.1, 1.4.2, and 1.5 ship their
own version of NFS, you will have this issue.  You can work aorund this
by not building NFS when you build OFED.  

Thanks,
Jon

> Any help appreciated.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
