From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 09 Apr 2013 08:49:54 -0400
Message-ID: <51640E72.3010202@dev.mellanox.co.il>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/9/2013 7:12 AM, Vasiliy Tolstov wrote:
> Hello. I have some servers, with mellanox ConnectX-3 and have some questions:
> Why max_mtu differs with active_mtu? 

What does peer port say for max MTU ?

> How can i set active mtu?

SM sets active MTU to min of peer ports max MTUs.

> Why ibstatus says that i have only 10 Gb/s ?

Because the link negotiated at 10 Gb/s.

> All cables support 40 Gb/s.

Do ports support 40 Gb/s also ? What do peer ports say for supported and
enabled link speeds ?

-- Hal

> Thanks for any help.
> 
> Linux xen28 3.8.6-1-xen #1 SMP Fri Apr 5 18:48:02 UTC 2013 (713918b)
> x86_64 x86_64 x86_64 GNU/Linux
> 
> Infiniband device 'mlx4_0' port 1 status:
>         default gid:     fe80:0000:0000:0000:0025:90ff:ff17:9b25
>         base lid:        0x34
>         sm lid:          0x4
>         state:           4: ACTIVE
>         phys state:      5: LinkUp
>         rate:            10 Gb/sec (4X)
>         link_layer:      InfiniBand
> 
> 
> 06:00.0 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
> hca_id: mlx4_0
>         transport:                      InfiniBand (0)
>         fw_ver:                         2.10.700
>         node_guid:                      0025:90ff:ff17:9b24
>         sys_image_guid:                 0025:90ff:ff17:9b27
>         vendor_id:                      0x02c9
>         vendor_part_id:                 4099
>         hw_ver:                         0x0
>         board_id:                       SM_2181000001000
>         phys_port_cnt:                  1
>                 port:   1
>                         state:                  PORT_ACTIVE (4)
>                         max_mtu:                4096 (5)
>                         active_mtu:             2048 (4)
>                         sm_lid:                 4
>                         port_lid:               52
>                         port_lmc:               0x00
>                         link_layer:             IB
> 
> 
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
