From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: How to use IB_QPT_RAW_ETY QP from user space.
Date: Tue, 9 Mar 2010 15:09:35 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408001969035@irsmsx503.ger.corp.intel.com>
References: <4B9625CB.5040700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B9625CB.5040700-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

I look for equivalent of definition of the IB_QPT_RAW_ETY in libibverbs/include/infiniband/verbs.h

ib_verbs.h 

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
        IB_QPT_RAW_ETY
};

I see only 
Verbs.h 
enum ibv_qp_type {
        IBV_QPT_RC = 2,
        IBV_QPT_UC,
        IBV_QPT_UD,
        IBV_QPT_XRC
};

Is something missing in libibverbs.h?

Regards, 

Mirek

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
