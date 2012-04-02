From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 02 Apr 2012 11:48:50 +0000
Message-ID: <4F799222.3050306@acm.org>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com> <4F798A9B.7060805@acm.org> <4F798B9A.6090309@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F798B9A.6090309-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/02/12 11:20, Or Gerlitz wrote:

> On 4/2/2012 2:16 PM, Bart Van Assche wrote:
>> On 04/02/12 10:33, Or Gerlitz wrote:
>>
>> As far as I can see the link layer value is fine:
>> $ cat /sys/class/infiniband/mlx4_0/ports/1/link_layer
>> InfiniBand
>> $ cat /sys/class/infiniband/mlx4_0/ports/2/link_layer
>> InfiniBand
> 
> So the two ports are actually connected to IB switch? please send
> ibv_devinfo output (HCA, firmware, etc).


The two ports are connected back-to-back to another mlx4 HCA. I noticed this behavior change since opensm stopped working after rebooting into 3.4-rc1. ibv_devinfo output is as follows:

# ibv_devinfo -v
hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.9.1000
        node_guid:                      0002:c903:0005:f34e
        sys_image_guid:                 0002:c903:0005:f351
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xA0
        board_id:                       MT_0BB0120003
        phys_port_cnt:                  2
        max_mr_size:                    0xffffffffffffffff
        page_size_cap:                  0xfffffe00
        max_qp:                         131008
        max_qp_wr:                      16384
        device_cap_flags:               0x007c9c76
        max_sge:                        32
        max_sge_rd:                     0
        max_cq:                         65408
        max_cqe:                        4194303
        max_mr:                         524272
        max_pd:                         32764
        max_qp_rd_atom:                 16
        max_ee_rd_atom:                 0
        max_res_rd_atom:                2096128
        max_qp_init_rd_atom:            128
        max_ee_init_rd_atom:            0
        atomic_cap:                     ATOMIC_HCA (1)
        max_ee:                         0
        max_rdd:                        0
        max_mw:                         0
        max_raw_ipv6_qp:                0
        max_raw_ethy_qp:                0
        max_mcast_grp:                  8192
        max_mcast_qp_attach:            248
        max_total_mcast_qp_attach:      2031616
        max_ah:                         0
        max_fmr:                        0
        max_srq:                        65472
        max_srq_wr:                     16383
        max_srq_sge:                    31
        max_pkeys:                      128
        local_ca_ack_delay:             15
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 1
                        port_lid:               1
                        port_lmc:               0x00
                        link_layer:             InfiniBand
                        max_msg_sz:             0x40000000
                        port_cap_flags:         0x0251086a
                        max_vl_num:             4 (3)
                        bad_pkey_cntr:          0x0
                        qkey_viol_cntr:         0x0
                        sm_sl:                  0
                        pkey_tbl_len:           128
                        gid_tbl_len:            128
                        subnet_timeout:         18
                        init_type_reply:        0
                        active_width:           4X (2)
                        active_speed:           10.0 Gbps (4)
                        phys_state:             LINK_UP (5)
                        GID[  0]:               fe80:0000:0000:0000:0002:c903:0005:f34f

                port:   2
                        state:                  PORT_INIT (2)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               0
                        port_lmc:               0x00
                        link_layer:             InfiniBand
                        max_msg_sz:             0x40000000
                        port_cap_flags:         0x02510868
                        max_vl_num:             4 (3)
                        bad_pkey_cntr:          0x0
                        qkey_viol_cntr:         0x0
                        sm_sl:                  0
                        pkey_tbl_len:           128
                        gid_tbl_len:            128
                        subnet_timeout:         0
                        init_type_reply:        0
                        active_width:           4X (2)
                        active_speed:           10.0 Gbps (4)
                        phys_state:             LINK_UP (5)
                        GID[  0]:               fe80:0000:0000:0000:0002:c903:0005:f350

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
