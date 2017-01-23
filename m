From: "Robert P. J. Day" <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>
Subject: include/uapi/rdma/Kbuild file doesn't include "qedr-abi.h"
Date: Mon, 23 Jan 2017 06:35:45 -0500 (EST)
Message-ID: <alpine.LFD.2.20.1701230633430.5922@uk63952.mitel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


  just an observation -- that Kbuild does not include the header file
"qedr-abi.h" sitting in that directory. should it? it's definitely
included by a few kernel files:

$ grep -r "qedr-abi.h" *
drivers/infiniband/hw/qedr/main.c:#include <rdma/qedr-abi.h>
drivers/infiniband/hw/qedr/qedr_cm.c:#include <rdma/qedr-abi.h>
drivers/infiniband/hw/qedr/verbs.c:#include <rdma/qedr-abi.h>
$

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
