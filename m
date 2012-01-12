From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER major problems with Linux 3.0 and Solaris targets
Date: Thu, 12 Jan 2012 16:18:05 +0100
Message-ID: <4F0EF9AD.6090403@profitbricks.com>
References: <4EEA0577.5030304@profitbricks.com>	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>	<4F0D987B.4060206@profitbricks.com> <CAJZOPZJOT4Mdyzg+Q06HevikqdA7Sy1KqD1V6Q5LjsiuFsYv5w@mail.gmail.com> <4F0EA679.1020703@profitbricks.com> <4F0EA7F3.8040704@mellanox.com> <4F0EB30F.8040504@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F0EB30F.8040504-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/01/12 11:16, Sebastian Riemer wrote:
> On 12/01/12 10:29, Or Gerlitz wrote:
>   
>> If you  have build the kernel IB user space support (uverbs) and the
>> IB libs, do "ibv_devinfo" if not, just ossi "cat
>> /sys/class/infiniband/mlx4_0/*" and send the output. To be clear, iser
>> does work for you on the productive servers but not on this server?
>>     
> Yes, we've got consistent OFED-1.5.4 user-space. "ibv_devinfo" reports a
> "mismatch between the kernel and the userspace libraries" - "kernel does
> not support XRC.". "ibverbs-driver-mlx4" is at version
> 1.0.1-1.20.g6771d22 and "libibverbs" is at version 1.1.4-1.24.gb89d4d7.
>
> But O.K., the other method shows firmware version "2.9.1000".
>
>   

I've found out that we have two single port MHQH19B-XTR InfiniBand HCAs.

lspci output:
03:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0
5GT/s - IB QDR / 10GigE] (rev b0)
04:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0
5GT/s - IB QDR / 10GigE] (rev b0)

The first one is ib1. And the second is ib0.
/sys/devices/pci0000:00/0000:00:0c.0/0000:03:00.0/net/ib1
/sys/devices/pci0000:00/0000:00:0b.0/0000:04:00.0/net/ib0

The iSER traffic is on ib1 (the HCA which reported the error) and ib0 is
for IPoIB traffic. I don't know if the mlx4 driver has a problem with
that hardware config.

Here is the requested data:
mlx4_0:
board_id       MT_0D90110009
fw_ver         2.9.1000
hca_type       MT26428
hw_rev         b0
node_desc      pserver214 HCA-1 (mlx4_0 - MT26428)
node_guid      0002:c903:000f:5f76
node_type      1: CA
sys_image_guid 0002:c903:000f:5f79
uevent         NAME=mlx4_0

mlx4_1:
board_id       MT_0D90110009
fw_ver         2.9.1000
hca_type       MT26428
hw_rev         b0
node_desc      pserver214 HCA-2 (mlx4_1 - MT26428)
node_guid      0002:c903:000f:5f26
node_type      1: CA
sys_image_guid 0002:c903:000f:5f29
uevent         NAME=mlx4_1

Both are connected to the storage but in different subnets and without
multipathing.

How do I find out if ib1 is on mlx4_1 or mlx4_0?

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
