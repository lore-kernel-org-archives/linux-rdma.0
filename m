From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: multicast sends not received by sending QP
Date: Wed, 10 Nov 2010 11:05:12 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B84C5788@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On one of our test clusters, I'm seeing a situation where multicast traffic is not received on the QP which sends a message.  All nodes that I actually tested on the cluster have this problem (5 of 15).  The devinfo from one of these is below:

hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.7.000
        node_guid:                      0002:c903:0002:5e0a
        sys_image_guid:                 0002:c903:0002:5e0d
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xA0
        board_id:                       MT_04E0120005

The cluster is running OFED 1.5.2, with updated versions of ibacm and librdmacm.  (I updated those trying to debug this issue.)  I do not see this problem on my test systems (running 2.6.36).

I do see the same failure on separate set of test systems running 1.5.2, but I don't know that the OFED version is the problem.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
