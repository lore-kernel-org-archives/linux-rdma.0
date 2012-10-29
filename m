From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH] IB/lmx4: silence GCC warning
Date: Mon, 29 Oct 2012 10:50:01 +0100
Message-ID: <1351504201.1339.4.camel@x61.thuisdomein>
References: <1348836538.3626.21.camel@x61.thuisdomein>
	 <201210100923.43927.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201210100923.43927.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2012-10-10 at 09:23 +0200, Jack Morgenstein wrote:
> You could use:
> 
>    u16 uninitialized_var(vlan);
> 
> instead.

I guess we'd better just wait and see whether uninitialized_var()
survives before discussing your suggestion (see the thread starting at
https://lkml.org/lkml/2012/10/26/508 ).

> Although this in the special QP data flow, I still prefer to avoid adding extra code (even setting
> initial values at procedure entry).  The line above will also do the job.  "uninitialized_var"
> is used elsewhere in the driver.  See, for example, mlx4_ib_post_send() in the same file (qp.c).


Paul Bolle

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
