From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv2 RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Mon, 22 Jun 2015 22:40:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF7EC2@ORSMSX109.amr.corp.intel.com>
References: <5583536C.3010504@dev.mellanox.co.il>
 <20150622202056.GA8049@obsidianresearch.com>
 <55888813.9040803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55888813.9040803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Note that there still remain a couple of node type checks in the kernel
> that we may want to remove. There's an IB CA check in cma.c:rdma_notify

This should check for rdma_cap_ib_cm()

> as well as in rds/ib.c:rds_ib_add_one and rds_ib_laddr_check and

Not sure what the underlying reason is for these checks.

> an RNIC check in rds/iw.c:rds_iw_add_one and rds_iw_laddr_check

rdma_cap_iw_cm()

The intent is to clarify why the checks that exist are made and replace them with a check that clearly conveys what the restriction is.  So, yes, the use of node_type should be replaced.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
