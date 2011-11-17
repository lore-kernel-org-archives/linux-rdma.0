From: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Subject: Re: Linux 3.2-rc1 vs. OFED 1.5.4-rc4: Packets are looped back
Date: Thu, 17 Nov 2011 17:33:09 +0000 (UTC)
Message-ID: <loom.20111117T182134-82@post.gmane.org>
References: <alpine.DEB.2.00.1111111007550.10404@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Christoph Lameter <cl@...> writes:
> 
> We have an app here that runs fine with OFED. But if I try to use the
> kernel IB subsystem in 3.2 it complains about packets being looped back to
> the application.
> 
> That seems to be controlled by IB_DEVICE_BLOCK_MULTICAST_LOOPBACK and
> IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK.
> 
> Why does it not work in the kernel IB stack?

The only place the 3.2 kernel sets IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK is in
ipoib_transport_dev_init() so unless you are doing IPoIB you will get loopback
traffic.

The reason you do not get loopback traffic with OFED is because OFED has the
following patch that adds the block_loopback module parameter to mlx4_core and
defaults to blocking-enabled.

http://git.openfabrics.org/git?p=ofed_1_5/linux-2.6.git;a=blob;f=kernel_patches/fixes/mlx4_0290_mcast_loopback.patch;h=786a3926529befac2c2d1fa6d8c36bada79d61a7;hb=HEAD



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
