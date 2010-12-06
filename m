From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 0/4] New RAW_PACKET QP type
Date: Mon, 6 Dec 2010 09:32:29 +0200
Message-ID: <4CFC918D.1090708@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patches add a new QP type named RAW_PACKET.

This type of QP is used in Ethernet environment and intended for
creation of a whole packet, including L2 headers, from userspace.
QP of thie type does not generate header in hardware but sending
gathered payloads to the wire.
This QP type must be used only by privileged software.

Differences from V2

This series doesn't contain patch for protocol distinction.
RAW_PACKET QP added to qp_state_table while preforming QP init.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
