From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: [RFC] naming for new QP types
Date: Thu, 01 Jul 2010 18:36:12 +0300
Message-ID: <4C2CB5EC.1080501@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
This message follows a discussion about names for a new QP type (see http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04512.html) and precedes a patch set for RAW QP that we intend to send.

The patch requires changes in enum ib_qp_type
1. Rename IB_QPT_RAW_ETY to IB_QPT_RAW_ETHERTYPE - this is not really a requirement but an opportunity to improve an existing name.
2. Add new QP type - IBV_QPT_RAW_PACKET. I'll delay the comments for the new name to later, when the patches are submitted, but ask another question instead.

The xrc branch also includes modifications to the same structure and it adds a new type IBV_QPT_XRC before the end.

In general, will it be acceptable if we submit the patches so that after they are applied the structure will look like this

enum ib_qp_type {
        /*
         * IB_QPT_SMI and IB_QPT_GSI have to be the first two entries
         * here (and in that order) since the MAD layer uses them as
         * indices into a 2-entry table.
         */
        IB_QPT_SMI,
        IB_QPT_GSI,

        IB_QPT_RC,
        IB_QPT_UC,
        IB_QPT_UD,
        IB_QPT_RAW_IPV6,
        IB_QPT_RAW_ETHERTYPE = 7,
        IB_QPT_RAW_PACKET = 8
};

So when XRC is accepted we still keep the same values for the last 2?

thanks

MoniS
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
