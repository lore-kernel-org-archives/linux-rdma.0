From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: FW: [PATCH] librdmacm/mcraw: Add a new test application for
 	user-space IBV_QPT_RAW_ETH QP type
Date: Mon, 14 Jun 2010 10:21:38 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E763A5E@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C64486040801E7635F7@irsmsx503.ger.corp.intel.com>
 <AANLkTinTIv9vPgcPKBOt0N10BgsjuXgDaPIo5OKa5yzT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinTIv9vPgcPKBOt0N10BgsjuXgDaPIo5OKa5yzT-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Or,

any reason not to patch mckey to support both IB and Ethernet raw QPs?
The mckey works on UD_QP type and mcraw works on RAW_QP type. 

The data payload prepared for UD and RAW_QP are on different layers. 

The mckey uses rdma_join_multicast() that triggers a state machine for IB multicast joining. 

The mcraw does not trigger such state machine because for sending the  ethernet multicast there is no need for any multicast joining state machine. The multicast destination address on ethernet is determined by multicast group address.

For me the API changes between mcraw and mckey are quite large and adding additional options could be confused for users. 

does raw qp has any relation to the iWARP/TOE HW stack?

Yes, As I told the logic for joining multicast group is different for IB and ethernet (I mention here about ethernet not iWARP specific). The mcraw handles an ethernet path sending multicasts that could be similar for nes and mlx4. 

Regards,

Mirek

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
Sent: Friday, June 11, 2010 10:13 PM
To: Walukiewicz, Miroslaw
Cc: Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: FW: [PATCH] librdmacm/mcraw: Add a new test application for user-space IBV_QPT_RAW_ETH QP type

Walukiewicz, Miroslaw <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The patch adds a new test application describing a usage of the IBV_QPT_RAW_ETH
> for IPv4 multicast acceleration on iWARP cards. See man mcraw for parameters description

So this is the only raw qp related patch to librdmacm? any reason not
to patch mckey to support both IB and Ethernet raw QPs? does raw qp
has any relation to the iWARP/TOE HW stack? there's also raw qp patch
posted to ewg for mlx4 which has no backing iwarp logic.

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
