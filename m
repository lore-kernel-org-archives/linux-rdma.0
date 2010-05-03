From: Todd Strader <tstrader-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Subject: IB / MLX setup issues
Date: Mon, 03 May 2010 17:05:47 -0500
Message-ID: <4BDF48BB.4070209@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm running into some issues when trying to set up a new IB cluster.  
I've got machine A which has connections to machine B and C via a single 
two-port ConnectX card.  A and B are connected and have no known 
problems.  I just set up machine C (installed OFED-1.5.1) but whenever I 
run ibv_devinfo I get:

libibverbs: Warning: couldn't load driver 'mlx4': 
/usr/local/lib/libmlx4-rdmav2.so: symbol ibv_cmd_get_eth_l2_addr, 
version IBVERBS_1.0 not defined in file libibverbs.so.1 with link time 
reference
libibverbs: Warning: no userspace device-specific driver found for 
/sys/class/infiniband_verbs/uverbs2
libibverbs: Warning: no userspace device-specific driver found for 
/sys/class/infiniband_verbs/uverbs1
libibverbs: Warning: no userspace device-specific driver found for 
/sys/class/infiniband_verbs/uverbs0
No IB devices found

The machine does have 3 HCAs.  For reference OFED 1.5.1 has deposited 
the following RPMs on the system:
libmlx4-1.0-0.7.g2432360
libmlx4-devel-1.0-0.7.g2432360
libibverbs-1.1.3-0.6.g932f1a2
libibverbs-devel-1.1.3-0.6.g932f1a2
libibverbs-devel-static-1.1.3-0.6.g932f1a2

Also, and I'm unsure if this is related, the link between machines C and 
A is in the initializing state when I bring up the machine.  Machine A 
has the subnet manager running, so I would think that should be enough.  
If I run another subnet manager on machine C, I get an active link, but 
I wouldn't think I need to be running two subnet managers.

Any advice on these issues would be appreciated.

Thanks.

Todd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
