From: Suresh <sureshmca1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Infiniband link speed in windows operating system.
Date: Fri, 12 Sep 2014 15:04:24 +0000 (UTC)
Message-ID: <loom.20140912T164616-127@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

I need to read infiniband card link speed. For that i found structure which
consist active_speed. ib_ca_attr_t->p_port_attr.

In p_port_attr consist active_speed and active_width. Please let me know
exact logic to show linkspeed using this active_speed and active_width values.

Infiniband having SDR,DDR,QDR. Logic need to support for all the varieties.


- suresh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
