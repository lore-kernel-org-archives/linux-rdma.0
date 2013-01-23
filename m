From: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Error message when trying to use Infiniband virtual functions in
 virtual machine
Date: Wed, 23 Jan 2013 16:29:44 +0100
Message-ID: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm working on a project in which I try to virtualize Infiniband. I
use ConnectX3 Infiniband cards with FW 2.9.1200.
I've installed a Fedora 18 OS with 3.8.0rc2 recompiled kernel. I use
KVM 1.2 to run virtual machines.

For my tests, I've created one virtual machine on which I've installed
RHEL6.3 with 3.8.0rc2 recompiled kernel.
On the host, I've loaded mlx4_core with num_vfs=2. Two virtual
functions are normaly available.
I've linked one virtual function with the VM. The return of lspci on
the VM is normal :

[root@welling0 ~]# lspci -s 00:08.0
00:08.0 Network controller: Mellanox Technologies MT27500 Family
[ConnectX-3 Virtual Function]

All sould work fine. But when I try to load mlx4_core driver on my VM,
this error message appears :

mlx4_core 0000:00:08.0: failed execution of VHCR_POST commandopcode 0x31

Here is the result of dmesg command :

[root@welling0 ~]# dmesg
mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
mlx4_core: Initializing 0000:00:08.0
mlx4_core 0000:00:08.0: Detected virtual function - running in slave mode
mlx4_core 0000:00:08.0: Sending reset
mlx4_core 0000:00:08.0: Sending vhcr0
mlx4_core 0000:00:08.0: 64B EQEs/CQEs supported by the device but not enabled
mlx4_core 0000:00:08.0: HCA minimum page size:512
mlx4_core 0000:00:08.0: irq 48 for MSI/MSI-X
mlx4_core 0000:00:08.0: irq 49 for MSI/MSI-X
mlx4_core 0000:00:08.0: failed execution of VHCR_POST commandopcode 0x31
mlx4_core 0000:00:08.0: NOP command failed to generate MSI-X interrupt IRQ 49).
mlx4_core 0000:00:08.0: Trying again without MSI-X.
mlx4_core: probe of 0000:00:08.0 failed with error -16


Have you got any idea about this error ?

Thank's for your help !!

Mathis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
