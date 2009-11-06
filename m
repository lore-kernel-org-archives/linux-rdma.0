From: Craig Reese <cfreese-68lYvLNOm//YtjvyW6yDsg@public.gmane.org>
Subject: StorNext/OFED incompatible? (missing find_exported_dentry in exportfs.ko)
Date: Fri, 06 Nov 2009 15:04:39 -0500
Message-ID: <4AF48157.904@super.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



I've been running around in circles trying to get StorNext 3.5.1 working
on a machine with OFED 1.4.1.  Until now StorNext always fails to
start saying that its missing symbol 'find_exported_dentry".  I now think
I've figured out that this is because OFED 1.4.1 (and it looks like 1.4 
an 1.4.2)
rebuilds its own exportfs.ko module and this is not a superset of
the code in the RedHat 5u3 exportfs.ko module.

Is there an easy fix for this?  In addition to leaving some things out,
it appears that OFED changes some of the existing function signatures
so I don't see a straightforward way to merge the two.

Any help appreciated.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
