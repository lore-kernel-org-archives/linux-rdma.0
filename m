From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Name for a new type of QP
Date: Wed, 23 Jun 2010 12:19:38 +0300
Message-ID: <4C21D1AA.8060402@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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
