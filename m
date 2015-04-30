From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Thu, 30 Apr 2015 19:21:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC9419@ORSMSX109.amr.corp.intel.com>
References: <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
 <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
 <553DF294.4070507@mellanox.com>
 <CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
 <553F931F.6000302@mellanox.com> <20150428174312.GB5497@obsidianresearch.com>
 <5540F8F4.5010906@dev.mellanox.co.il>
 <20150429164847.GA12781@obsidianresearch.com>
 <5541E5ED.7000606@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC929B@ORSMSX109.amr.corp.intel.com>
 <20150430175252.GB32666@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150430175252.GB32666-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> But, how could RDMA CM work? Inbound CM messages will be filtered if
> the IP is not in the HW GID table?

I'm not understanding the issue.

If a device has some requirement to program its assigned IP addresses into some HW table, I don't see why upper layers should be made to care.  The IB CM is essentially handling 2 different type of CM messages -- one for IB and one for RoCE.  This just adds a third type.  All three types are similar, with some fields ignored and others formatted using different data.  The CM interface can be updated to better reflect reality, rather than pretending that RoCE has path records or anything other than IB-classic has LIDs.  The CM message definitions themselves could also be updated to indicate which fields matter.

> How could UD work?

I haven't given much thought to UD, but since AV creation goes directly to the driver, I still don't see why GIDs need to be used.  The driver can encode whatever it needs to (e.g. GID/IP index) into the AV.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
