From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [RFI] ucmatose: No effect to set service type for QoS
Date: Tue, 9 Aug 2016 18:26:34 +0200
Message-ID: <CAMGffEn=dQsBzV9SPsVTJdsppJ65n_FFiRRASyrjwnmMNmCuDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I'm testing QoS support for IB. I notice ucmatose has equally
performance when set different service type, but set SL in ib_send_bw
works well (different SL show different performance base on opensm
settings)

I capature packats using ibdump, it shows in in LRH the service level
fields are all 0 when running traffic with ucmatose.

When running ib_send_bw, it carries the right service level I set.

Seems in rdma_set_service_type, it sets to tos to id_priv->tos, and
lter set to path_rec->qos_class or traffic_class but not to sl
directly, what's the consideration here?
code snip:
        switch (cma_family(id_priv)) {
        case AF_INET:
                path_rec->qos_class = cpu_to_be16((u16) id_priv->tos);
                comp_mask |= IB_SA_PATH_REC_QOS_CLASS;
                break;
        case AF_INET6:
                sin6 = (struct sockaddr_in6 *) cma_src_addr(id_priv);
                path_rec->traffic_class = (u8)
(be32_to_cpu(sin6->sin6_flowinfo) >> 20);
                comp_mask |= IB_SA_PATH_REC_TRAFFIC_CLASS;
                break;
        case AF_IB:
                sib = (struct sockaddr_ib *) cma_src_addr(id_priv);
                path_rec->traffic_class = (u8)
(be32_to_cpu(sib->sib_flowinfo) >> 20);


Does it make sense we also set sl here, or service type for ucmatose
is totally different with SL for ib_send_bw?
-- 
Mit freundlichen Grüßen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
Fax: +49 30 5770085-98
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Geschäftsführer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
