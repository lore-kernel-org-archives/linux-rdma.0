From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4 RoCE mode without OFED?
Date: Thu, 27 Oct 2016 18:24:14 +0300
Message-ID: <CAAKD3BCfJev2pniTZRmH4fhmbG1EPbBUskYhqyTdJ2OjMZfkug@mail.gmail.com>
References: <CAANLjFpM=zzNyjikzt12TjqgRcfLh7j_6cXxtdM-ow48kNfPKA@mail.gmail.com>
 <CAAKD3BCA=dOKxb-h5+VRp0DG=CN0e4Xj91hLgXSHtqAt=apMkQ@mail.gmail.com> <CAANLjFr-d8RX-aiziGVb5cD0kq2BMqCNmh=JobfwK5WPOLPfng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFr-d8RX-aiziGVb5cD0kq2BMqCNmh=JobfwK5WPOLPfng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2016 at 6:53 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> That commit is from linux-stable [0] introduced in 4.5-rc1 and may be
> more of an internal thing. It looks like RDMA is able to work on the
> 4.8.4 kernel, but not on the 4.4.24 kernel (what we are using in
> production currently). We are interested in RoCE v2, does this mean
> that the non-Pro card can't do RoCE v2 even with OFED? We have some
> ConnectX-4 Lx cards that we are testing specifically for RoCE v2, but
> it would be nice if we move to RoCE to re-purpose the IB cards.
>

Regarding the commit you mentioned. it just updates the SUBLEVEL of
linux 4.4 kernel,
are you sure it's the correct commit?
Anyway, AFAIK, RoCE v1 should work on previous kernels on both ConnectX-3 and
ConnectX-3 pro. Regarding ConnectX-4 and its derivatives, you need the GID
management code in kernel, but it was introduced in v4.3.

The non-pro ConnectX-3 doesn't support RoCE v2 - not even in OFED.

> Thanks,
> Robert LeBlanc
>

Regards,
Matan

> [0] http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Wed, Oct 26, 2016 at 5:53 AM, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On Tue, Oct 25, 2016 at 11:28 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>> I've been trying to get our ConnectX-3 card to run RoCE (Ethernet mode
>>> is working) [0], but I can't pass the roce_mode to the mlx4_core
>>> module even with 4.8.4. Do you have to use OFED to use RoCE with
>>> ConnectX-3? According to the spec sheet, the card should support RoCE
>>
>> roce_mode parameter is OFED only. When you use upstream, ConnectX-3 supports
>> RoCE v1 automatically while ConnectX-3 pro supports both RoCE v1 and RoCE v2.
>> You don't have to specify any module parameter for that.
>>
>>> [1]. We generally run 4.4.x kernel and so getting OFED to compile is
>>> quite the challenge, so we are looking for an upstream solution. It
>>> seems that commit 3afd8362fabd167bb04f79501f21dd67aa9cb99f added some
>>> bits to add roce_mode to the module, but I don't see it in the module.
>>>
>>
>> I couldn't find this commit. Is it OFED?
>>
>>> Linux localhost 4.8.4 #3 SMP Tue Oct 25 13:28:15 MDT 2016 x86_64
>>> x86_64 x86_64 GNU/Linux
>>>
>>> # mstflint -d 02:00.0 q
>>> Image type:      FS2
>>> FW Version:      2.35.5100
>>> Rom Info:        type=PXE version=3.4.648 devid=4099
>>> Device ID:       4099
>>> Description:     Node             Port1            Port2            Sys image
>>> GUIDs:           0cc47affff4fe9fc 0cc47affff4fe9fd 0cc47affff4fe9fe
>>> 0cc47affff4fe9ff
>>> MACs:                                 0cc47a4fe9fd     0cc47a4fe9fe
>>> VSD:             n/a
>>> PSID:            SM_2221000001000
>>>
>>> [Tue Oct 25 13:40:21 2016] mlx4_core: unknown parameter 'roce_mode' ignored
>>> [Tue Oct 25 13:40:21 2016] mlx4_core: unknown parameter 'roce_mode' ignored
>>>
>>> # modinfo mlx4_core
>>> filename:
>>> /lib/modules/4.8.4/kernel/drivers/net/ethernet/mellanox/mlx4/mlx4_core.ko
>>> version:        2.2-1
>>> license:        Dual BSD/GPL
>>> description:    Mellanox ConnectX HCA low-level driver
>>> author:         Roland Dreier
>>> srcversion:     BB58E84E637E4E5EC69D04E
>>> alias:          pci:v000015B3d00001010sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000100Fsv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000100Esv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000100Dsv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000100Csv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000100Bsv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000100Asv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001009sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001008sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001007sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001006sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001005sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001004sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001003sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00001002sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000676Esv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006746sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006764sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000675Asv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006372sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006750sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006368sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000673Csv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006732sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006354sv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d0000634Asv*sd*bc*sc*i*
>>> alias:          pci:v000015B3d00006340sv*sd*bc*sc*i*
>>> depends:
>>> intree:         Y
>>> vermagic:       4.8.4 SMP mod_unload
>>> parm:           debug_level:Enable debug tracing if > 0 (int)
>>> parm:           msi_x:attempt to use MSI-X if nonzero (int)
>>> parm:           num_vfs:enable #num_vfs functions if num_vfs > 0
>>> num_vfs=port1,port2,port1+2 (array of byte)
>>> parm:           probe_vf:number of vfs to probe by pf driver (num_vfs > 0)
>>> probe_vf=port1,port2,port1+2 (array of byte)
>>> parm:           log_num_mgm_entry_size:log mgm size, that defines the
>>> num of qp per mcg, for example: 10 gives 248.range: 7 <=
>>> log_num_mgm_entry_size <= 12. To activate device managed flow steering
>>> when available, set to
>>> -1 (int)
>>> parm:           enable_64b_cqe_eqe:Enable 64 byte CQEs/EQEs when the
>>> FW supports this (default: True) (bool)
>>> parm:           enable_4k_uar:Enable using 4K UAR. Should not be
>>> enabled if have VFs which do not support 4K UARs (default: false)
>>> (bool)
>>> parm:           log_num_mac:Log2 max number of MACs per ETH port (1-7) (int)
>>> parm:           log_num_vlan:Log2 max number of VLANs per ETH port (0-7) (int)
>>> parm:           use_prio:Enable steering by VLAN priority on ETH ports
>>> (deprecated) (bool)
>>> parm:           log_mtts_per_seg:Log2 number of MTT entries per
>>> segment (1-7) (int)
>>> parm:           port_type_array:Array of port types: HW_DEFAULT (0) is
>>> default 1 for IB, 2 for Ethernet (array of int)
>>> parm:           enable_qos:Enable Enhanced QoS support (default: on) (bool)
>>> parm:           internal_err_reset:Reset device on internal errors if
>>> non-zero (default 1) (int)
>>>
>>> Thanks,
>>> Robert LeBlanc
>>>
>>
>> Regards,
>> Matan
>>
>>> [0] https://community.mellanox.com/docs/DOC-1444
>>> [1] http://www.mellanox.com/related-docs/prod_adapter_cards/PB_ConnectX3_VPI_Card.pdf
>>> ----------------
>>> Robert LeBlanc
>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
