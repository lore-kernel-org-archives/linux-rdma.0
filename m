From: Stephen Cousins <steve.cousins-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>
Subject: mxl4 and rpcrdma: connection to 192.168.0.100:20049 on mlx4_0, memreg
 5 slots 32 ird 16
Date: Mon, 15 Nov 2010 18:29:54 -0500
Message-ID: <AANLkTi=d6d2vydtcK+ux22e-QR5xqrkenMoeM8AzHBVq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm having issues with nfs-rdma. The server has a Mellanox QDR card in it:

# ibv_devinfo
hca_id:	mlx4_0
	transport:			InfiniBand (0)
	fw_ver:				2.7.626
	node_guid:			0002:c903:0007:f352
	sys_image_guid:			0002:c903:0007:f355
	vendor_id:			0x02c9
	vendor_part_id:			26428
	hw_ver:				0xB0
	board_id:			MT_0D90110009
	phys_port_cnt:			1
		port:	1
			state:			PORT_ACTIVE (4)
			max_mtu:		2048 (4)
			active_mtu:		2048 (4)
			sm_lid:			1
			port_lid:		1
			port_lmc:		0x00

The client is a Supermicro motherboard with the IB QDR built in:

# ibv_devinfo
hca_id:	mlx4_0
	transport:			InfiniBand (0)
	fw_ver:				2.7.700
	node_guid:			0025:90ff:ff16:0240
	sys_image_guid:			0025:90ff:ff16:0243
	vendor_id:			0x02c9
	vendor_part_id:			26428
	hw_ver:				0xB0
	board_id:			SM_2121000001000
	phys_port_cnt:			1
		port:	1
			state:			PORT_ACTIVE (4)
			max_mtu:		2048 (4)
			active_mtu:		2048 (4)
			sm_lid:			1
			port_lid:		6
			port_lmc:		0x00

The 2.7.700 firmware is brand new from Supermicro. Prior to this it
was 2.7.0 and it showed the same thing.

NFS is working for the most part but the client always logs messages
like below after a modestly sizable transfer ( like 2GB) with dd:

# dd if=/dev/zero of=node4.dat bs=1M count=2K oflag=direct
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 11.7277 seconds, 183 MB/s

messages.log:

Nov 15 09:39:00 node4 kernel: rpcrdma: connection to
192.168.0.100:20049 on mlx4_0, memreg 5 slots 32 ird 16

and then 5 minutes later:

Nov 15 09:44:00 node4 kernel: rpcrdma: connection to
192.168.0.100:20049 closed (-103)

The server has 16 GB of RAM and the client has 32 GB. They are running
CentOS 5.5 with a 2.6.35.4 kernel.

I have tried changing memreg to 6 and it gives the same corresponding message.

Thanks for any help.

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
