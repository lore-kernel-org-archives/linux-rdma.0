From: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: error in ibdiagnet output
Date: Thu, 29 Oct 2009 12:47:27 -0700
Message-ID: <6203933669E90E4AB42B5BC4EDE38D350C8295A2D2@orsmsx510.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the output of ibdiagnet, there is a line that has improper terminology.  The line refers to "partial" where the proper term is "limited" (per the IB standard).  Example shown below:

-I---------------------------------------------------
-I- Fabric Partitions Report (see ibdiagnet.pkey for a full hosts list)
-I---------------------------------------------------
-I-    PKey:0x7fff Hosts:95 full:95 partial:0

Thanks,
Don Meyer
Senior Network/System Engineer/Programmer
US+ (253) 371-9532 iNet 8-371-9532
*Other names and brands may be claimed as the property of others
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
