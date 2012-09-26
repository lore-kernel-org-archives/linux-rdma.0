From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick mlx4 IB SR-IOV howto?
Date: Wed, 26 Sep 2012 22:22:58 +0200
Message-ID: <CAJZOPZLZQVjFj0P3SrU8hmsz5XNM3QR7HEsxrn5C755hxkWszQ@mail.gmail.com>
References: <CAL1RGDU0XPCyS6fVeHHxnhLHpREjqi6kjKFCX8hBwrLuVD2HwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU0XPCyS6fVeHHxnhLHpREjqi6kjKFCX8hBwrLuVD2HwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 26, 2012 at 7:14 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> So I have SR-IOV enabled on a ConnectX-3 adapter, and I loaded the
> driver with num_vfs=1 probe_vf=1, so in the host I see:
>
> # The master device
> $ ibv_devinfo -d mlx4_1
> hca_id: mlx4_1
>         transport:                      InfiniBand (0)
>         fw_ver:                         2.11.500
>         node_guid:                      0002:c903:0036:6670
>         sys_image_guid:                 0002:c903:0036:6673
>         vendor_id:                      0x02c9
>         vendor_part_id:                 4099
>         hw_ver:                         0x0
>         board_id:                       MT_1100120019
>         phys_port_cnt:                  1
>                 port:   1
>                         state:                  PORT_ACTIVE (4)
>                         max_mtu:                2048 (4)
>                         active_mtu:             2048 (4)
>                         sm_lid:                 1
>                         port_lid:               2
>                         port_lmc:               0x00
>                         link_layer:             InfiniBand
>
> # The slave VF
> $ ibv_devinfo -d mlx4_3
> hca_id: mlx4_3
>         transport:                      InfiniBand (0)
>         fw_ver:                         2.11.500
>         node_guid:                      0014:0500:8c20:105c
>         sys_image_guid:                 0002:c903:0036:6673
>         vendor_id:                      0x02c9
>         vendor_part_id:                 4100
>         hw_ver:                         0x0
>         board_id:                       MT_1100120019
>         phys_port_cnt:                  1
>                 port:   1
>                         state:                  PORT_DOWN (1)
>                         max_mtu:                2048 (4)
>                         active_mtu:             2048 (4)
>                         sm_lid:                 1
>                         port_lid:               2
>                         port_lmc:               0x00
>                         link_layer:             InfiniBand
>
> What do I need for the slave VF's port to become active?
> I'm running opensm 3.3.13 on a different box, is that new enough?
> (does SR-IOV require any SM support?)

Yes, as Hal noted, at minimum you need opensm 3.3.14
(http://marc.info/?l=linux-rdma&m=133819320432335&w=2) as it is the
1st version to support alias-guid et al stuff needed for SRIOV, 3.3.15
is also out now, so you want the 2nd version that supports this...
basically you need IB link for the PPF and the slave to get an alias
guid registered for it @ the SM. We (IL team) were off Tues/Wed as of
a holiday, will try to get you further details tonight and if not, by
tomorrow, sure.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
