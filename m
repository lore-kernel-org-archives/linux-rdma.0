From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: i40iw: use shared code for port mapper
Date: Wed, 23 Mar 2016 21:26:48 +0000
Message-ID: <1EEBC91386407A4A8D1EBE1DD5AA52125EA2B89F@FMSMSX114.amr.corp.intel.com>
References: <20160323205447.GA5714@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160323205447.GA5714@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Dan for pointing it out. Will be sending out patch to fix it and also will run
sparse with the CHECK_ENDIAN parameter in future patches.

Faisal

>-----Original Message-----
>From: Dan Carpenter [mailto:dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>Sent: Wednesday, March 23, 2016 3:55 PM
>To: Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: re: i40iw: use shared code for port mapper
>
>Hello Faisal Latif,
>
>The patch 8d8cd0bf6798: "i40iw: use shared code for port mapper" from Feb
>26, 2016, leads to the following static checker warnings:
>
>drivers/infiniband/hw/i40iw/i40iw_hw.c:484 i40iw_manage_arp_cache()
>error: wrong number of bits for 'cpu_to_le32' (16 vs 32) left= 'info->arp_index'
>info->arp_index = ((arp_index))
>
>drivers/infiniband/hw/i40iw/i40iw_hw.c:556 i40iw_manage_qhash()
>error: wrong number of bits for 'cpu_to_le16' (32 vs 16) left= 'info->dest_port'
>info->dest_port = ((cminfo->loc_port))
>
>drivers/infiniband/hw/i40iw/i40iw_hw.c:562 i40iw_manage_qhash()
>error: wrong number of bits for 'cpu_to_le16' (32 vs 16) left= 'info->src_port'
>info->src_port = ((cminfo->rem_port))
>
>drivers/infiniband/hw/i40iw/i40iw_cm.c:3273 i40iw_init_tcp_ctx()
>error: wrong number of bits for 'cpu_to_le32' (16 vs 32) left= 'tcp_info-
>>arp_idx' tcp_info->arp_idx = ((i40iw_arp_table(iwqp->iwdev, &tcp_info-
>>dest_ip_addr3, 1, (0), 3)))
>
>drivers/infiniband/hw/i40iw/i40iw_cm.c:3289 i40iw_init_tcp_ctx()
>error: wrong number of bits for 'cpu_to_le32' (16 vs 32) left= 'tcp_info-
>>arp_idx' tcp_info->arp_idx = ((i40iw_arp_table(iwqp->iwdev, &tcp_info-
>>dest_ip_addr0, 0, (0), 3)))
>
>drivers/infiniband/hw/i40iw/i40iw_verbs.c:1772 i40iw_dereg_mr()
>error: wrong number of bits for 'cpu_to_le32' (16 vs 32) left= 'info->pd_id' info-
>>pd_id = ((iwpd->sc_pd.pd_id & 32767))
>
>
>drivers/infiniband/hw/i40iw/i40iw_hw.c
>   553          info->ipv4_valid = cminfo->ipv4;
>   554          ether_addr_copy(info->mac_addr, iwdev->netdev->dev_addr);
>   555          info->qp_num = cpu_to_le32(dev->ilq->qp_id);
>   556          info->dest_port = cpu_to_le16(cminfo->loc_port);
>                ^^^^^^^^^^^^^^^
>This is a u32 but we're storing a le16 in it which is problematic.
>The Sparse version of this check is more strict but has more false positives.
>Anyway, give it a whirl:  https://lwn.net/Articles/205624/
>
>   557          info->dest_ip[0] = cpu_to_le32(cminfo->loc_addr[0]);
>   558          info->dest_ip[1] = cpu_to_le32(cminfo->loc_addr[1]);
>   559          info->dest_ip[2] = cpu_to_le32(cminfo->loc_addr[2]);
>   560          info->dest_ip[3] = cpu_to_le32(cminfo->loc_addr[3]);
>   561          if (etype == I40IW_QHASH_TYPE_TCP_ESTABLISHED) {
>   562                  info->src_port = cpu_to_le16(cminfo->rem_port);
>   563                  info->src_ip[0] = cpu_to_le32(cminfo->rem_addr[0]);
>   564                  info->src_ip[1] = cpu_to_le32(cminfo->rem_addr[1]);
>   565                  info->src_ip[2] = cpu_to_le32(cminfo->rem_addr[2]);
>   566                  info->src_ip[3] = cpu_to_le32(cminfo->rem_addr[3]);
>   567          }
>
>regards,
>dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
