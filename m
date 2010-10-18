From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: ib mad definitions
Date: Mon, 18 Oct 2010 15:24:39 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This has probably been discussed before, but is there a strong reason why ib_types.h can't be moved from opensm/include/iba to libibumad/include/infiniband?

This appears to be the only place where IB MAD definitions are available for user space applications, and having them available at the libibumad level makes sense to me.

(I'm trying to port madeye to user space as a diag, and want all IB MAD definitions.)

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
