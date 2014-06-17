From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
Date: Mon, 16 Jun 2014 17:09:27 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406161707230.21018@chino.kir.corp.google.com>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com> <539F34E8.3000501@opengridcomputing.com> <alpine.DEB.2.02.1406161638360.21018@chino.kir.corp.google.com> <CAPDOMVg8hT95Wcmy4VHdfsumEvc=w3dz8V8xP1QScsLK3buSxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPDOMVg8hT95Wcmy4VHdfsumEvc=w3dz8V8xP1QScsLK3buSxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nick Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 16 Jun 2014, Nick Krause wrote:

> If that is the case ,David I would mark bug id 44631 as closed due to no
> need for my if statement.

You don't want to depend on the implementation of the page allocator to 
never return NULL for orders < PAGE_ALLOC_COSTLY_ORDER with GFP_KERNEL, it 
could possibly change in the future and we wouldn't catch your dependency 
in send_flowc().  The size object size of the skbuff_head_cache slab cache 
could also change.  You don't need the suggested pr_warn(), though, since 
the page allocation failure warning would also be noisy enough.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
