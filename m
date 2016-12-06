From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Tue, 6 Dec 2016 22:13:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0BBEC7@ORSMSX109.amr.corp.intel.com>
References: <20161130170830.GA17512@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA190@ORSMSX109.amr.corp.intel.com>
 <01e501d24b2e$ff2a3260$fd7e9720$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA1B7@ORSMSX109.amr.corp.intel.com>
 <d4bab4a9-aa32-282f-b501-ecfc00b0be0f@talpey.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA68E@ORSMSX109.amr.corp.intel.com>
 <HE1PR0501MB2812393A0A690DEC1E03DE3FB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161205171013.GA27784@obsidianresearch.com>
 <HE1PR0501MB2812A66403A8C19AF83742EDB1830@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAJ3xEMhYs0jtXYDqAXEw17Fk4padG903J3enL+uNPg_fNk-9Uw@mail.gmail.com>
 <20161206213938.GC647@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206213938.GC647-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I've already proposed disallowing multiprotocol struct ib_devices.

My preference is to discontinue attempts at associating a protocol with the device.  A device could implement a dozen protocols in software.  Transports belong to QPs or cm ids, not devices.  Each rdma_cm_id should be associated with a specific cm/transport directly, rather than indirectly selecting one based on the bound <device, port>.

If an app wants a specific transport type for a QP, why doesn't it just try to open one and see if the call fails?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
