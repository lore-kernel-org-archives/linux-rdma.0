From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FW: [PATCH] librdmacm/mcraw: Add a new test application for
	user-space IBV_QPT_RAW_ETH QP type
Date: Fri, 11 Jun 2010 23:12:53 +0300
Message-ID: <AANLkTinTIv9vPgcPKBOt0N10BgsjuXgDaPIo5OKa5yzT@mail.gmail.com>
References: <BE2BFE91933D1B4089447C64486040801E7635F7@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801E7635F7-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
