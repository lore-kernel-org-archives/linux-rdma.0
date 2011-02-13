From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: RE: [PATCH][RFC] infiniband: Fix allocation size in
 register_snoop_agent()
Date: Sun, 13 Feb 2011 21:19:29 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1102132119080.18930@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102112237490.16994@swampdragon.chaosbits.net> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC45047A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC45047A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 11 Feb 2011, Hefty, Sean wrote:

> > Ok, someone needs to double check me on this before merging anything, but
> > don't we want to allocate sizeof(struct ib_mad_snoop_private) here, rather
> > than just the size of a pointer to the struct?
> 
> new_snoop_table is declared as:
> 
> struct ib_mad_snoop_private **new_snoop_table;
> 
> It should point to an array of pointers.
> 
Ok. Thank you for that reply.
Just ignore the patch then.

-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
