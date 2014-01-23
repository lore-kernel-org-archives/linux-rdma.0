From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: default mtu sizes for connected/datagram modes and driver versions
Date: Thu, 23 Jan 2014 10:04:40 +0400
Message-ID: <CACaajQsr=W9uAG_O-gQuk+BPqnMkQ=YQZfgd4aYgmUpvKWcRXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all. I'm try to understand mtu sizes in case of datagram/connected modes.
I have some old debian systemd and its ip over ib interfaces has mtu
1500, on never systemd i have 4092, why?
And in case of datagram modes i have 2042.. what is the best values
for mtu in case of using ip over ib?
Thanks!

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
