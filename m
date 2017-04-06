From: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4 partitions + SR-IOV - P_Key not found
Date: Fri, 7 Apr 2017 00:35:58 +0300
Message-ID: <20170407003558.000017dc@dev.mellanox.co.il>
References: <CADvaNzWedJOts4z6Nr3Ssx4Qur09h4=iY9mhZBxH4KdPnJke_A@mail.gmail.com>
        <519dbd14-ff05-23ad-0f70-cb8c3b9f4c4e@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519dbd14-ff05-23ad-0f70-cb8c3b9f4c4e-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 6 Apr 2017 10:40:27 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 4/6/2017 10:19 AM, Mark Lehrer wrote:
> > I am using a ConnectX-3 (MCX354A-FCB_A2-A5).  The system is Ubuntu
> > 16.04 with 4.4.0-72-generic
> > 
> > I can use partitions fine with the root device, and I can do
> > unpartitioned ipoib in qemu-kvm using virtual functions.  
> 
> Sounds like the SM has properly configured the pkeys on the physical
> port.
> 
> > However, when I try to use a partition in the guest, it gives me
> > errors like this: ib0.8010: P_Key 0x8010 is not found  
> 
> I think that there is hypervisor configuration to make this work. Are
> you familiar with it ?
> 
> -- Hal
> 
> > I tried both the inbox mlx4 driver and OFED 4.0-2.0.0.1
> > 
> > Should partitions work with SR-IOV virtual functions?  If so, what
> > should I do to debug this?
> > 
> > Thanks,
> > Mark
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   

Mark,
You need to map the physical pkeys to a virtual pkey table that is
maintained per port, per VF. OpenSM only controls the physical pkey
table on the host. Mapping physical pkey indices to virtual pkey
indices for VFs is performed on the Linux Hypervisor (Dom 0).

See detailed instructions in the mlnx ofed Linux user manual
(http://www.mellanox.com/related-docs/prod_software/Mellanox_OFED_Linux_User_Manual_v3.10.pdf)
section: 3.4.1.5.4 Partitioning IPoIB Communication using PKeys, on
pages 211-212

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
