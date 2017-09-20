From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Wed, 20 Sep 2017 12:57:04 +0200
Message-ID: <20170920105703.r7bkuhybvoq2ufs4@linux-x5ow.site>
References: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
 <7aac2d78-462b-c9ad-4443-9ec670a27b74@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7aac2d78-462b-c9ad-4443-9ec670a27b74-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 20, 2017 at 01:37:28PM +0300, Sagi Grimberg wrote:
> --
> diff --git a/drivers/infiniband/core/verbs.c
> b/drivers/infiniband/core/verbs.c
> index ee9e27dc799b..f2c70afea238 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1646,7 +1646,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16
> lid)
>          */
>         if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
>                 if (attr.qp_state >= IB_QPS_INIT) {
> -                       if (qp->device->get_link_layer(qp->device,
> attr.port_num) !=
> +                       if (rdma_port_get_link_layer(qp->device,
> attr.port_num) !=
>                             IB_LINK_LAYER_INFINIBAND)
>                                 return true;
>                         goto lid_check;
> --

w00000! You're my hero.

Tested-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
