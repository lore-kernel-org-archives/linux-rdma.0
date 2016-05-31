From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Tue, 31 May 2016 20:01:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05CBD5@ORSMSX109.amr.corp.intel.com>
References: <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
 <20160526172244.GC27115@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
 <20160526233612.GA4396@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BC0C@ORSMSX109.amr.corp.intel.com>
 <20160527131956.GY25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05BD12@ORSMSX109.amr.corp.intel.com>
 <20160529081646.GA25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05CA92@ORSMSX109.amr.corp.intel.com>
 <20160531181012.GD7477@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160531181012.GD7477-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If I understand your proposal correctly, the proposed IOCTL framework will be
> able to handle all types of objects without any limitations in order and locking,
> everything is going to be processed by the driver, which will decide if
> such object/method is supported or not.

For the core ioctl framework - yes.

An ioctl can be dispatched to some other common handling, which can validate object ordering and type.

> What will stop the GPU with DRMs to use it?

It would have to hook into the same file.  But if it's generic enough, nothing would prevent other subsystems (e.g. Xeon Phi or NVM) from re-using the code.  I don't see this as a negative.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
