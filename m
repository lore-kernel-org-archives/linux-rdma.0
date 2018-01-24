From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: get_maintainer.pl bug?
Date: Wed, 24 Jan 2018 13:23:24 +0200
Message-ID: <20180124112323.GA8265@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
This is what i get when running scripts/get_maintainer.pl drivers/infiniband/:

Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:INFINIBAND SUBSYSTEM)
linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)

However section "INFINIBAND SUBSYSTEM" pointed out a different address for
Jason:

INFINIBAND SUBSYSTEM
M:      Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
M:      Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
W:      http://www.openfabrics.org/
Q:      http://patchwork.kernel.org/project/linux-rdma/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
S:      Supported
F:      Documentation/devicetree/bindings/infiniband/
F:      Documentation/infiniband/
F:      drivers/infiniband/
F:      include/uapi/linux/if_infiniband.h
F:      include/uapi/rdma/
F:      include/rdma/

So
- Which one is the correct one?
- What am i doing wrong when using scripts/get_maintainer.pl?

Thanks,
Yuval
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
