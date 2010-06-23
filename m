From: "Alex Rosenbaum" <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: Name for a new type of QP
Date: Wed, 23 Jun 2010 14:03:28 +0300
Message-ID: <7E95F01E94AB484F83061FCFA35B39F868D9D2@exil.voltaire.com>
References: <4C21D1AA.8060402@Voltaire.COM> <BE2BFE91933D1B4089447C64486040801E9D892A@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <BE2BFE91933D1B4089447C64486040801E9D892A-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is true that on the send path for such a QP you can send any sort of
packet. The user of the QP is required to build the MAC header and the
NIC will wrap the post_sent data in an Ethernet type II frame which
includes the tailing CRC.

On the receive path this QP assume an MAC header. The qp attach GID
value gets the multicast MAC destination address to catch the correct
ingress packets.

Bottom line is that I think IBV_QPT_RAW_ETH is a good name.
If not I would like to recommend to use IBV_QPT_RAW_PACKET which hold a
resemblance to "socket(AF_PACKET, SOCK_RAW,...)"

On the other hand, I never fully understood what does IBV_QPT_RAW_ETY
stand for? Maybe we should change its name to better represent what the
code does.


_________________
 Alex Rosenbaum 

 


-----Original Message-----
From: Walukiewicz, Miroslaw [mailto:Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, June 23, 2010 1:21 PM
To: Moni Shoua; linux-rdma
Cc: Roland Dreier; Alex Rosenbaum
Subject: RE: Name for a new type of QP

I would prefer a name IBV_QPT_FRAME so it is a L2 layerQP. The packet is
reserved for L3.

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
This QP type lets the user post_send() data to its SQ and treat it as
the entire packet, including headers.
An example of use with this QP is sending Ethernet packets from
userspace (and enjoying kernel bypass).

An open question in this matter it how should we call this QP type.
The first name IBV_QPT_RAW_ETH seems to be too similar to the existing
type IBV_QPT_RAW_ETY.

My suggestion (that were posted in a different thread) are

IBV_QPT_FRAME
IBV_QPT_PACKET
IBV_QPT_NOHDR

Please make your comments and send your suggestions.

When we decide about a name we will send a patch that enables the use of
this QP type.


thanks

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
