From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: FW: [PATCH] librdmacm/mcraw: Add a new test application for	user-space
 IBV_QPT_RAW_ETH QP type
Date: Mon, 14 Jun 2010 14:11:34 +0300
Message-ID: <4C160E66.6040707@Voltaire.com>
References: <BE2BFE91933D1B4089447C64486040801E7635F7@irsmsx503.ger.corp.intel.com>	<AANLkTinTIv9vPgcPKBOt0N10BgsjuXgDaPIo5OKa5yzT@mail.gmail.com> <BE2BFE91933D1B4089447C64486040801E763A5E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801E763A5E-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Walukiewicz, Miroslaw wrote:
> The mckey works on UD_QP type and mcraw works on RAW_QP type. 
> The data payload prepared for UD and RAW_QP are on different layers. 
> The mckey uses rdma_join_multicast() that triggers a state machine for IB multicast joining. 
> The mcraw does not trigger such state machine because for sending the ethernet multicast there is 
> no need for any multicast joining state machine. The multicast destination address on ethernet 
> is determined by multicast group address.

Miroslaw,

I tend not to agree with the entire set of your arguments, to start with, for example, the code issues IP_ADD_MEMBERSHIP call on a socket and also computes the actual L2 address derived from the L3 multicast address. 

If these ops are required for raw ethernet multicast operation, you can enhance the rdmacm to have rdma_join_multicast carry these ops similarly to what it does for PS_UDP and PS_IPOIB over IB (determine the L2 address, join through the relevant state machine, etc).

Its not that you claim to be able to run raw multicast without any relation to the rdma-cm, e.g. you even want this code to be shipped by librdmacm... so lets understand the architecture, for example what port space  is needed here, looking on the code, it looks like you want it to operate in the same manner as PS_IPOIB,so maybe extend this port space or declare an equivalent one for ethernet.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
