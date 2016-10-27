From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Trouble enabling iSER for ConnectX-4 Lx
Date: Thu, 27 Oct 2016 14:10:16 -0600
Message-ID: <CAANLjFqrE_e_bjMn_FSbVBq0oudzy1qGxAoFic64b77Z9X+x2A@mail.gmail.com>
References: <CAANLjFr_we+33Nen-NYp1xQPzQ-wbR=GL4LBkEZb9azMUN-_=Q@mail.gmail.com>
 <af629bfa-5355-0d14-9cc1-f5c4ef687f67@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <af629bfa-5355-0d14-9cc1-f5c4ef687f67-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks for the push in the right direction. With installing OFED, I
was able to use iSER and the comparison between Ethernet and RoCE is
quite impressive. I had a feeling that OFED would be needed, but since
it wasn't listed in the software for the adapter or mentioned in the
adapter documentation, it wasn't clear that it was needed. One thing
I'm not 100% sure about is if after running cma_roce_mode -d mlx5_0 -p
1 -m 2 is if RoCE v2 is being used for iSER. I'll have to read up more
on doing a packet capture of RoCE to know for sure, unless you have a
better way to confirm.

Thank you,
Robert LeBlanc
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Oct 27, 2016 at 1:26 AM, Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Hi Robert,
>
> You've installed mlnx-en package, which does not provide iSER modules.
> Instead, you should get MLNX_OFED from:
> http://www.mellanox.com/page/products_dyn?product_family=26&mtag=linux_sw_drivers
>
> Note that ib_isert in MLNX_OFED is not backported to all kernels, and it's
> enabled by default only for a specific kernels.
> To force building the module against your kernel, use the following command
> for MLNX_OFED installation:
> # MLNX_EXTRA_FLAGS=--with-isert ./mlnxofedinstall --force
> --add-kernel-support  --with-isert --skip-repo
>
> As for configuring RoCE, please refer to the MLNX_OFED User Manual:
> http://www.mellanox.com/related-docs/prod_software/Mellanox_OFED_Linux_User_Manual_v3.40.pdf
>
> Regards,
> Alaa
>
>
>
> On 10/27/2016 02:13, Robert LeBlanc wrote:
>
> We have some ConnectX-4 Lx cards that I'm trying to test RoCE and iSER
> on. I downloaded and installed the Mellanox drivers with VMA [0]. I
> was able to run the ib_read_bw tests over the adapters after
> installing the infiniband-diags and perftest RPMs. When I went to
> configure LIO for iSER, I'm getting the message "Cannot change iser"
> on step 6 in the procedure here [1] which I've done many times with
> Infiniband without issues. I navigated to
> /sys/kernel/config/target/iscsi/{iqn}/tpgt_1/np/{portal_ip:port} and
> sure enough, I can't write '1' into iser. The kernel is not giving any
> messages and the ib_isert module is loaded. This is on 4.4.27,
> Mellanox driver 3.4-1.0.0.3 built with `./install --add-kernel-support
> --skip-repo --tmpdir /root/junk --vma`
>
> # mstflint -d 4:00.0 q
> Image type:          FS3
> FW Version:          14.16.1020
> FW Release Date:     20.6.2016
> Rom Info:            type=UEFI version=14.10.16
>                     type=PXE version=3.4.812 devid=4117
> Description:         UID                GuidsNumber
> Base GUID:           0cc47a000089f706        4
> Base MAC:            00000cc47a89f706        4
> Image VSD:
> Device VSD:
> PSID:                SM_2001000001034
>
> # ibstatus
> Infiniband device 'mlx5_0' port 1 status:
>        default gid:     fe80:0000:0000:0000:0ec4:7aff:fe89:f706
>        base lid:        0x0
>        sm lid:          0x0
>        state:           4: ACTIVE
>        phys state:      5: LinkUp
>        rate:            25 Gb/sec (1X EDR)
>        link_layer:      Ethernet
>
> Infiniband device 'mlx5_1' port 1 status:
>        default gid:     fe80:0000:0000:0000:0ec4:7aff:fe89:f707
>        base lid:        0x0
>        sm lid:          0x0
>        state:           4: ACTIVE
>        phys state:      5: LinkUp
>        rate:            25 Gb/sec (1X EDR)
>        link_layer:      Ethernet
>
> Any ideas of what I'm doing wrong here? I don't have any experience
> with RoCE, so I'm sure I'm doing something wrong. And the manual has
> nothing about configuring RoCE other than enabling --vma when
> installing the drivers [2].
>
> Thanks,
> Robert LeBlanc
>
> [0] http://www.mellanox.com/page/products_dyn?product_family=27
> [1] https://community.mellanox.com/docs/DOC-1472
> [2]
> http://www.mellanox.com/related-docs/prod_software/Mellanox_EN_for_Linux_User_Manual_v3_40.pdf
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
