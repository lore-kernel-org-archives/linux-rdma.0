From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] IB/usnic: Fix kbuild robot, sparse and
 smatch errs
Date: Fri, 20 Dec 2013 20:28:36 +0000
Message-ID: <B3C55F87-99BB-4238-A492-BDE154C4B123@cisco.com>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387298917-7365-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <4D06370F0D59C14F80CEE49C0AA31182-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set is void.  Succeeded by http://www.spinics.net/lists/linux-rdma/msg18170.html.

Upinder

On Dec 17, 2013, at 8:48 AM, Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> This patch series fixes these kbuild robot, sparse and smatch errors:
> https://lists.01.org/pipermail/kbuild/2013-December/000877.html
> https://lists.01.org/pipermail/kbuild-all/2013-December/002354.html
> https://lists.01.org/pipermail/kbuild-all/2013-December/002335.html
> https://lists.01.org/pipermail/kbuild-all/2013-December/002337.html
> http://www.spinics.net/lists/linux-rdma/msg18047.html
> http://www.spinics.net/lists/linux-rdma/msg18048.html
> http://www.spinics.net/lists/linux-rdma/msg18049.html
> http://www.spinics.net/lists/linux-rdma/msg18050.html
> 
> IB/usnic: Fix stack frame size exceed warnings
> IB/usnic: Fix format not a string literal
> IB/usnic: Make usNIC built depend on Intel IOMMU
> IB/usnic: Fix error handling with IS_ERR_OR_NULL
> IB/usnic: Change BUG_ON to WARN_ON
> IB/usnic: Initialize all of the data returned to
> IB/usnic: Fix printk format warnings
> IB/usnic: Remove duplicate and unnecessary
> IB/usnic: Fix sparse should be static warnings
> 
> drivers/infiniband/hw/usnic/usnic_ib_main.c   |    2 +-
> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |    2 +-
> drivers/infiniband/hw/usnic/usnic_ib_main.c   |    5 ++--
> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |    2 +-
> drivers/infiniband/hw/usnic/usnic_vnic.c      |    2 --
> drivers/infiniband/hw/usnic/Kconfig           |    3 +-
> drivers/infiniband/hw/usnic/usnic_ib_main.c   |   10 +++++---
> drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |    2 +-
> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |   16 ++++++-------
> drivers/infiniband/hw/usnic/usnic_uiom.c      |    2 +-
> drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |    2 ++
> drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |    6 ++---
> drivers/infiniband/hw/usnic/usnic_uiom.c      |   32 ++++++++++++++-----------
> drivers/infiniband/hw/usnic/usnic_vnic.c      |    4 ++-
> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |   19 +++++++--------
> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h |   12 ++++-----
> drivers/infiniband/hw/usnic/usnic_vnic.c      |   12 ++++-----
> drivers/infiniband/hw/usnic/usnic_vnic.h      |   12 ++++-----
> drivers/infiniband/hw/usnic/usnic_ib_main.c   |    4 ++-
> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |    4 ++-
> drivers/infiniband/hw/usnic/usnic_ib_sysfs.c  |    2 +-
> drivers/infiniband/hw/usnic/usnic_transport.c |    4 ++-
> drivers/infiniband/hw/usnic/usnic_transport.h |    1 +
> drivers/infiniband/hw/usnic/usnic_uiom.c      |    2 +-
> 24 files changed, 81 insertions(+), 81 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
