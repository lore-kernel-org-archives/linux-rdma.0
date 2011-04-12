From: Muchtar Nir <nirmu-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Infiniband Netlink Patches
Date: Tue, 12 Apr 2011 15:38:39 +0300
Message-ID: <BANLkTi=dVThgB_BD-o2J18ScS7=H5m_3HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry for resending. Having Some mailer problems...

On Mon, 2011-04-11 at 13:36 -0600, Jason Gunthorpe wrote:
> > Hi Roland (your real email this time...),
>
> > Did you get a chance to go over the last series of the IB Netlink
> > patches I sent?  Is there anything missing? Anything I can do make
> > reviewing this easier?
>
> I think we were both hoping to hear something from the Linux netlink
> experts on the userspace schema in these patches. That is whay a
> concise and complete text description was needed..
>
> Jason

I thought my explanation was clear enough.
Here it is again with some (hopefully...) improvements.
I'd appreciate if you could let me know of any obscurity, so I can
improve on it and we can make progress on this.

The schema for RDMA CM is a series of netlink messages. Each one
contains an rdma_cm_stat struct. Additionally, two netlink attributes
are created for the addresses for each message (if applicable).
Their types:
IBNL_RDMA_CM_ATTR_SRC_ADDR (The source address for this ID)
IBNL_RDMA_CM_ATTR_DST_ADDR (The destination address for this ID)
sockaddr_* structs are encapsulated within these attributes.

In other words, every transaction contains a series of messages like so:

-------message 1-------
struct rdma_cm_id_stats {
        __u32 qp_num;
        __u32 bound_dev_if;
        __u32 port_space;
        __s32 pid;
        __u8 cm_state;
        __u8 node_type;
        __u8 port_num;
        __u8 reserved;
}
IBNL_RDMA_CM_ATTR_SRC_ADDR attribute - contains the source address
IBNL_RDMA_CM_ATTR_DST_ADDR attribute - contains the destination address
-------end 1-------
-------message 2-------
struct rdma_cm_id_stats
IBNL_RDMA_CM_ATTR_SRC_ADDR attribute
IBNL_RDMA_CM_ATTR_DST_ADDR attribute
-------end 2-------

And so on...

Thanks,
Nir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
