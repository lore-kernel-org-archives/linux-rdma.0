From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Name for a new type of QP
Date: Wed, 23 Jun 2010 11:20:40 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E9D892A@irsmsx503.ger.corp.intel.com>
References: <4C21D1AA.8060402@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C21D1AA.8060402-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I would prefer a name IBV_QPT_FRAME so it is a L2 layerQP. The packet is reserved for L3.

Regards,

Mirek

-----Original Message-----
From: Moni Shoua [mailto:monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org] 
Sent: Wednesday, June 23, 2010 11:20 AM
To: linux-rdma
Cc: Walukiewicz, Miroslaw; Roland Dreier; alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
Subject: Name for a new type of QP

Hi,
This message follows a discussion in the EWG mailing list.

We want to promote a patch that enables use of a new QP type.
This QP type lets the user post_send() data to its SQ and treat it as the entire packet, including headers.
An example of use with this QP is sending Ethernet packets from userspace (and enjoying kernel bypass).

An open question in this matter it how should we call this QP type.
The first name IBV_QPT_RAW_ETH seems to be too similar to the existing type IBV_QPT_RAW_ETY.

My suggestion (that were posted in a different thread) are

IBV_QPT_FRAME
IBV_QPT_PACKET
IBV_QPT_NOHDR

Please make your comments and send your suggestions.

When we decide about a name we will send a patch that enables the use of this QP type.


thanks

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
