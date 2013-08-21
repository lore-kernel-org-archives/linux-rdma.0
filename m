From: Eva Mishra <eva.mishra2007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: registering physical memory region
Date: Wed, 21 Aug 2013 12:17:52 +0530
Message-ID: <CAAcPZE44MOY5zz0bWNKqy=hpOO3GR-xV1J9oB6=vm0tH4eWQmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The infiniband specification describes register physical memory
region. consumer can request an iova to be returned which can be same
or different from the one requested.

we provide a physical buffer list (which is list of start physical
address of pages) as input to the call that registers physical memory.
while allocating any memory the physical address is already associated
with a virtual address. still we can request a new virtual address to
be returned for region.

what is significance of iova, since one virtual address is already
associated with physical address that we provide.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
