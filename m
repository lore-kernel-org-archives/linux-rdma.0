From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Old SDR IB HBA
Date: Tue, 15 May 2012 22:16:08 +0300
Message-ID: <d004e56b0a274ba55134840a93060de4@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all!

Is it normal that kenrnel reports 8.5G speed on old SDR mellanox HBA?
c-2-1 1 # ibstatus
Infiniband device 'mthca0' port 1 status:
         default gid:     fe80:0000:0000:0000:0002:c902:0023:05a1
         base lid:        0x2f
         sm lid:          0xf
         state:           4: ACTIVE
         phys state:      5: LinkUp
         rate:            8.5 Gb/sec (4X)
         link_layer:      InfiniBand

c-2-1 1 # ibv_devinfo
hca_id: mthca0
         transport:                      InfiniBand (0)
         fw_ver:                         1.0.800
         node_guid:                      0002:c902:0023:05a0
         sys_image_guid:                 0002:c902:0023:05a3
         vendor_id:                      0x02c9
         vendor_part_id:                 25204
         hw_ver:                         0xA0
         board_id:                       MT_03B0120001
         phys_port_cnt:                  1
                 port:   1
                         state:                  PORT_ACTIVE (4)
                         max_mtu:                2048 (4)
                         active_mtu:             2048 (4)
                         sm_lid:                 15
                         port_lid:               47
                         port_lmc:               0x00
                         link_layer:             IB


-- 
Best Regards,
Alexey 'Alexxy' Shvetsov
Petersburg Nuclear Physics Institute, NRC Kurchatov Institute, 
Gatchina, Russia
Department of Molecular and Radiation Biophysics
Gentoo Team Ru
Gentoo Linux Dev
mailto:alexxyum-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
mailto:alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org
mailto:alexxy-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
