From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problems using krping
Date: Thu, 21 Jan 2010 08:40:33 -0600
Message-ID: <4B586761.8040005@opengridcomputing.com>
References: <201001211807011710722@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201001211807011710722-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It appears the MLX4 driver does not support kernel mode memory regions.  
You'll have to use dma mrs or fast_reg mrs with that device.

Steve.




lihaidong wrote:
> Mr.Wise:
>  
> When using mr mode as the memory registration method, krping failed to 
> get memory region using ib_reg_phys_mr().Could you help me, please?
>  
> dmesg:
> krping_init
> krping: proc write |client,addr=10.10.10.15,mem_mode=mr,port=9999,count=1,verbose|
> client
> ipaddr (10.10.10.15)
> port 9999
> count 1
> verbose
> created cm_id ffff88013c74c800
> cma_event type 0 cma_id ffff88013c74c800 (parent)
> cma_event type 2 cma_id ffff88013c74c800 (parent)
> rdma_resolve_addr - rdma_resolve_route successful
> created pd ffff880133845280
> created cq ffff88013c1ff400
> created qp ffff88013c1ffe00
> krping: krping_setup_buffers called on cb ffff88013c59f800
> krping: recv buf dma_addr 13c59f968 size 16
> krping: recv_buf reg_mr failed
> krping: krping_setup_buffers failed: -38
> destroy cm_id ffff88013c74c800
> krping: proc write |client,addr=10.10.10.15,mem_mode=mr,port=9999,count=1,verbose|
> client
> ipaddr (10.10.10.15)
> port 9999
> count 1
> verbose
> created cm_id ffff88013c59f800
> cma_event type 0 cma_id ffff88013c59f800 (parent)
> cma_event type 2 cma_id ffff88013c59f800 (parent)
> rdma_resolve_addr - rdma_resolve_route successful
> created pd ffff88012f5964a0
> created cq ffff88012faee400
> created qp ffff88012faeec00
> krping: krping_setup_buffers called on cb ffff88013c71d400
> krping: recv buf dma_addr 13c71d568 size 16
> krping: recv_buf reg_mr failed
> krping: krping_setup_buffers failed: -38
> destroy cm_id ffff88013c59f800
>  
>  
> echo "client,addr=10.10.10.15,mem_mode=mr,port=9999,count=1" > /proc/krping 
>
> echo "server,addr=10.10.10.15,mem_mode=mr,port=9999" > /proc/krping
>  
> Using OFED-1.5 ofa_kernel-1.5
> HardWare:Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] 
>
> put krping source files into drivers/infiniband/hw/mlx4
>  
> 2010-01-21
> ------------------------------------------------------------------------
> lihaidong

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
