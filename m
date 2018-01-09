From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 00/14] index e382a3ca759e..d4a471a76d82
 100644
Date: Mon, 8 Jan 2018 19:51:05 -0700
Message-ID: <20180109025105.GB6305@ziepe.ca>
References: <20180104152544.28919-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180104152544.28919-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 04, 2018 at 05:25:30PM +0200, Leon Romanovsky wrote:
> Changelog:
>  v1 -> v2:
>   * Dropped "IB/mlx5: Use correct mdev for vport queries in ib_virt"
>  v0 -> v1:
>   * Rebased to latest rdma/for-next
>   * Enriched commit messages.
> 
> Thanks
> 
> >From Daniel:
> 
> This feature allows RDMA resources (pd, mr, cq, qp, etc) to be used with
> both physical ports of capable mlx5 devices. When enabled a single IB
> device with two ports will be registered instead of two single port
> devices.
> 
> There are still two PCI devices underlying the two port device, the
> capabilities indicate which device is the "master" device and which is
> the slave.
> 
> When the add callback function is called for a slave device a list of IB
> devices is searched for matching master device, indicated by the
> capabilities and the system_image_guid. If a match is found the slave is
> bound to the master device, otherwise it's placed on a list, in case
> it's master becomes available in the future. When a master device is added it
> searches the list of available slaves for a matching slave device. If a
> match is found it binds the slave as its 2nd port. If no match as found
> the device still appears as a dual port device, with the 2nd port down.
> RDMA resources can still created that use the yet unavailable 2nd port.
> 
> Commands related to IB resources are all routed through the master
> mlx5_core device. Port specific commands, like those for hardware
> counters are routed to their respective port mlx5_core device. Since
> devices can appear and disappear asynchronously a reference count on the
> underlying mlx5_core device is maintained. Getting and putting this
> reference is only necessary for commands destined to a specific port,
> the master core device can be used freely, as it will exist while the IB
> device exists.
> 
> SR-IOV devices follow the same pattern as the physical ones. VFs of a
> master port can bind VFs of slave ports, if available, and operate as
> dual port devices.
> 
> Examples of devices passed to a VM:
> (master)         - One net device, one IB device that has two ports. The slave
>                    port will always be down.
> (slave)          - One net device, no IB devices.
> (slave, slave)   - Two net devices and no IB devices.
> (master, master) - Two net devices, two IB devices, each with two ports.
>                    The slave port of each device will always be down.
> (master, slave)  - Two net devices, one IB device, with two ports. Both
> 		    ports can be used.
> 
> There are no changes to the existing design for net devices.
> 
> The feature is disabled by default and it is enabled in firmware
> with mlxconfig.

> 	Thanks
> 
> Daniel Jurgens (13):
>   net/mlx5: Fix race for multiple RoCE enable
>   net/mlx5: Set software owner ID during init HCA
>   IB/core: Change roce_rescan_device to return void
>   IB/mlx5: Reduce the use of num_port capability
>   IB/mlx5: Make netdev notifications multiport capable
>   {net,IB}/mlx5: Manage port association for multiport RoCE
>   IB/mlx5: Move IB event processing onto a workqueue
>   IB/mlx5: Implement dual port functionality in query routines
>   IB/mlx5: Update counter implementation for dual port RoCE
>   {net,IB}/mlx5: Change set_roce_gid to take a port number
>   IB/mlx5: Route MADs for dual port RoCE
>   IB/mlx5: Don't advertise RAW QP support in dual port mode
>   net/mlx5: Set num_vhca_ports capability
> 
> Parav Pandit (1):
>   IB/mlx5: Change debugfs to have per port contents

I made the revisions I noted in the the followup mails and applied
this to for-next.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
