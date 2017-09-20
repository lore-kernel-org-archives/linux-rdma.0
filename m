From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Wed, 20 Sep 2017 13:37:28 +0300
Message-ID: <7aac2d78-462b-c9ad-4443-9ec670a27b74@grimberg.me>
References: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170920095339.zhfymeyfbhiyepz5-qw2SdCWA0PpjqqEj2zc+bA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hi folks,
> 
> I wanted to try out Christoph's NVMe multipathing patchset on my NVMe OmniPath
> setup and merged it into 4.14-rc1. On bootup I stumbled upon that splat and no
> RDMA operation was possible:

...

> is_valid_mcast_lid.isra.23+0xfb/0x110
> 
> (gdb) l *(is_valid_mcast_lid+0xfb)
> 0x229b is in is_valid_mcast_lid (drivers/infiniband/core/verbs.c:1649).
> 1644		/* If QP state >= init, it is assigned to a port and we can check this
> 1645		 * port only.
> 1646		 */
> 1647		if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
> 1648			if (attr.qp_state >= IB_QPS_INIT) {
> 1649				if (qp->device->get_link_layer(qp->device, attr.port_num) !=
> 1650				    IB_LINK_LAYER_INFINIBAND)
> 1651					return true;
> 1652				goto lid_check;
> 1653			}
> (gdb)

Why isn't ipoib uses the generic rdma_port_get_link_layer?

Does this help?
--
diff --git a/drivers/infiniband/core/verbs.c 
b/drivers/infiniband/core/verbs.c
index ee9e27dc799b..f2c70afea238 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1646,7 +1646,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, 
u16 lid)
          */
         if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, 
&init_attr)) {
                 if (attr.qp_state >= IB_QPS_INIT) {
-                       if (qp->device->get_link_layer(qp->device, 
attr.port_num) !=
+                       if (rdma_port_get_link_layer(qp->device, 
attr.port_num) !=
                             IB_LINK_LAYER_INFINIBAND)
                                 return true;
                         goto lid_check;
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
