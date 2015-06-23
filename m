From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv2 RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Tue, 23 Jun 2015 05:50:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF8147@ORSMSX109.amr.corp.intel.com>
References: <5583536C.3010504@dev.mellanox.co.il>
 <20150622202056.GA8049@obsidianresearch.com>
 <55888813.9040803@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FF7EC2@ORSMSX109.amr.corp.intel.com>
 <55889EDF.3070906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55889EDF.3070906-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> rds_ib_add_one says:
> /* Only handle IB (no iWARP) devices */
> but not sure comment is 100% accurate as it checks node type != IB CA.
> 
> rds_ib_laddr_check says:
> /* rdma_bind_addr will only succeed for IB & iWARP devices */
> /* due to this, we will claim to support iWARP devices unless we check
> node_type. */
> It's similar to above in that it checks node type != IB CA and does not
> seem 100% accurate.

I noticed these, but I don't know why RDS has this requirement.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
