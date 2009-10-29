From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Ubuntu and OFED package
Date: Thu, 29 Oct 2009 10:37:42 -0700
Message-ID: <ada3a525cex.fsf@cisco.com>
References: <5D00672F-A0D5-4A5C-8C62-D32AA922C4AF@alcf.anl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5D00672F-A0D5-4A5C-8C62-D32AA922C4AF-Kw/0HyiNjNCfRvmTrFJqzg@public.gmane.org> (Kevin
	Harms's message of "Thu, 29 Oct 2009 11:10:34 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Harms <harms-Kw/0HyiNjNCfRvmTrFJqzg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > node:~$ sudo ibv_devinfo
 > mlx4: There is a mismatch between the kernel and the userspace
 > libraries: Kernel does not support XRC. Exiting.
 > Failed to open device

It seems you are using the default Ubuntu kernel but a libmlx4 package
from somewhere else.  If you are using the OFED-patched libmlx4 you will
need to use the OFED-patched kernel too.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
