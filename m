From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] read_config: skip file/directory with unsecure
 permissions
Date: Mon, 12 Aug 2013 20:59:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA54FE@ORSMSX109.amr.corp.intel.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
 <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
 <20130521205713.GB11318@obsidianresearch.com>
 <1375989856.27609.10.camel@localhost.localdomain>
 <20130812190545.GA7968@obsidianresearch.com>
 <8d276f12593ddc79233fa41abdaf0d41@meuh.org>
 <20130812203935.GA8990@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130812203935.GA8990-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is slightly off topic, but what is the underlying reason for having the libibverbs config directory?  Is it simply to support the library name being different than the device name, or is there something more?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
