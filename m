From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Mon, 25 Sep 2017 19:01:28 +0800
Message-ID: <e44f4640-44b2-4692-ca57-08f9ebf4da2c@redhat.com>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
 <20170924103426.GB25094@mtr-leonro.local>
 <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4@redhat.com>
 <4faccebf-7fcf-58b9-1605-82ee9acc652b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4faccebf-7fcf-58b9-1605-82ee9acc652b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi
Pls see my comments bellow.
> I'm not able to reproduce this.
>
I've reproduce this on below two environment, and the target side I used 
is nullbk
[root@rdma-virt-00 ~]$ lspci | grep -i mel
04:00.0 Network controller: Mellanox Technologies MT27520 Family 
[ConnectX-3 Pro]
04:00.1 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
04:00.2 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
04:00.3 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
04:00.4 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
04:00.5 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
04:00.6 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
04:00.7 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
06:00.0 Network controller: Mellanox Technologies MT27520 Family 
[ConnectX-3 Pro]
06:00.1 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
06:00.2 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
06:00.3 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
06:00.4 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
06:00.5 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
06:00.6 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]
06:00.7 Network controller: Mellanox Technologies MT27500/MT27520 Family 
[ConnectX-3/ConnectX-3 Pro Virtual Function]

[root@rdma-virt-03 ~]$ lspci | grep -i mel
04:00.0 Infiniband controller: Mellanox Technologies MT27700 Family 
[ConnectX-4]
04:00.1 Infiniband controller: Mellanox Technologies MT27700 Family 
[ConnectX-4]
05:00.0 Ethernet controller: Mellanox Technologies MT27710 Family 
[ConnectX-4 Lx]
05:00.1 Ethernet controller: Mellanox Technologies MT27710 Family 
[ConnectX-4 Lx]


> I still don't understand how we call ib_alloc_cq and get to
> a mapped buffer, its calling dma_alloc_coherent.
>
> Can you try the following patch and report what's going on?
> -- 
>
Here is the log, didn't get the error log, but the nvme0n1 device node 
also doesn't exist on host.
[  144.993253] nvme nvme0: new ctrl: NQN 
"nqn.2014-08.org.nvmexpress.discovery", addr 172.31.0.90:4420
[  145.177205] nvme nvme0: creating 40 I/O queues.
[  145.711199] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.0.90:4420
[  156.482770] nvme nvme0: Reconnecting in 10 seconds...
[  166.881540] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  166.889043] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  166.895478] nvme nvme0: Failed reconnect attempt 1
[  166.900840] nvme nvme0: Reconnecting in 10 seconds...
[  177.120933] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  177.128434] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  177.134866] nvme nvme0: Failed reconnect attempt 2
[  177.140227] nvme nvme0: Reconnecting in 10 seconds...
[  187.360819] nvme nvme0: Connect rejected: status 8 (invalid service ID).
[  187.368321] nvme nvme0: rdma_resolve_addr wait failed (-104).
[  187.374752] nvme nvme0: Failed reconnect attempt 3
[  187.380113] nvme nvme0: Reconnecting in 10 seconds...
[  197.620302] nvme nvme0: creating 40 I/O queues.
[  198.227963] nvme nvme0: Successfully reconnected
[  198.228046] nvme nvme0: identifiers changed for nsid 1

[root@rdma-virt-01 ~]$ lsblk
NAME                           MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                              8:0    0 465.8G  0 disk
├─sda2                           8:2    0 464.8G  0 part
│ ├─rhelaa_rdma--virt--01-swap 253:1    0     4G  0 lvm  [SWAP]
│ ├─rhelaa_rdma--virt--01-home 253:2    0 410.8G  0 lvm  /home
│ └─rhelaa_rdma--virt--01-root 253:0    0    50G  0 lvm  /
└─sda1                           8:1    0     1G  0 part /boot

> -- 
>
> I guess we could see weird phenomenons if we have a resource leak,
> but I ran kmemleak and could not get anything in this area...
>
>> Panic after connection with below commits, detailed log here: 
>> https://pastebin.com/7z0XSGSd
>> 31fdf18     nvme-rdma: reuse configure/destroy_admin_queue
>> 3f02fff       nvme-rdma: don't free tagset on resets
>> 18398af    nvme-rdma: disable the controller on resets
>> b28a308   nvme-rdma: move tagset allocation to a dedicated routine
>>
>> good    34b6c23 nvme: Add admin_tagset pointer to nvme_ctrl
>
> Is that a reproducible panic? I'm not seeing this at all.
>

Yes, I can reproduce every time. And the target side kernel version is 
4.14.0-rc1 during the panic occurred.

> Can you run gdb on nvme-rdma.ko
> $ l *(nvme_rdma_create_ctrl+0x37d)
>
[root@rdma-virt-01 linux ((31fdf18...))]$ gdb 
/usr/lib/modules/4.13.0-rc7.31fdf18+/kernel/drivers/nvme/host/nvme-rdma.ko
GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-100.el7
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later 
<http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from 
/usr/lib/modules/4.13.0-rc7.31fdf18+/kernel/drivers/nvme/host/nvme-rdma.ko...done.
(gdb) l *(nvme_rdma_create_ctrl+0x37d)
0x297d is in nvme_rdma_create_ctrl (drivers/nvme/host/rdma.c:656).
651        struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
652        struct blk_mq_tag_set *set = admin ?
653                &ctrl->admin_tag_set : &ctrl->tag_set;
654
655        blk_mq_free_tag_set(set);
656        nvme_rdma_dev_put(ctrl->device);
657    }
658
659    static struct blk_mq_tag_set *nvme_rdma_alloc_tagset(struct 
nvme_ctrl *nctrl,
660            bool admin)
(gdb)

> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
