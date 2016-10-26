From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Trouble enabling iSER for ConnectX-4 Lx
Date: Wed, 26 Oct 2016 17:13:16 -0600
Message-ID: <CAANLjFr_we+33Nen-NYp1xQPzQ-wbR=GL4LBkEZb9azMUN-_=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have some ConnectX-4 Lx cards that I'm trying to test RoCE and iSER
on. I downloaded and installed the Mellanox drivers with VMA [0]. I
was able to run the ib_read_bw tests over the adapters after
installing the infiniband-diags and perftest RPMs. When I went to
configure LIO for iSER, I'm getting the message "Cannot change iser"
on step 6 in the procedure here [1] which I've done many times with
Infiniband without issues. I navigated to
/sys/kernel/config/target/iscsi/{iqn}/tpgt_1/np/{portal_ip:port} and
sure enough, I can't write '1' into iser. The kernel is not giving any
messages and the ib_isert module is loaded. This is on 4.4.27,
Mellanox driver 3.4-1.0.0.3 built with `./install --add-kernel-support
--skip-repo --tmpdir /root/junk --vma`

# mstflint -d 4:00.0 q
Image type:          FS3
FW Version:          14.16.1020
FW Release Date:     20.6.2016
Rom Info:            type=UEFI version=14.10.16
                    type=PXE version=3.4.812 devid=4117
Description:         UID                GuidsNumber
Base GUID:           0cc47a000089f706        4
Base MAC:            00000cc47a89f706        4
Image VSD:
Device VSD:
PSID:                SM_2001000001034

# ibstatus
Infiniband device 'mlx5_0' port 1 status:
       default gid:     fe80:0000:0000:0000:0ec4:7aff:fe89:f706
       base lid:        0x0
       sm lid:          0x0
       state:           4: ACTIVE
       phys state:      5: LinkUp
       rate:            25 Gb/sec (1X EDR)
       link_layer:      Ethernet

Infiniband device 'mlx5_1' port 1 status:
       default gid:     fe80:0000:0000:0000:0ec4:7aff:fe89:f707
       base lid:        0x0
       sm lid:          0x0
       state:           4: ACTIVE
       phys state:      5: LinkUp
       rate:            25 Gb/sec (1X EDR)
       link_layer:      Ethernet

Any ideas of what I'm doing wrong here? I don't have any experience
with RoCE, so I'm sure I'm doing something wrong. And the manual has
nothing about configuring RoCE other than enabling --vma when
installing the drivers [2].

Thanks,
Robert LeBlanc

[0] http://www.mellanox.com/page/products_dyn?product_family=27
[1] https://community.mellanox.com/docs/DOC-1472
[2] http://www.mellanox.com/related-docs/prod_software/Mellanox_EN_for_Linux_User_Manual_v3_40.pdf
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
