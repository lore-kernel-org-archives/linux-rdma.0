From: Aaron Knister <aaron.s.knister-NSQ8wuThN14@public.gmane.org>
Subject: sriov dmar errors
Date: Wed, 10 Jan 2018 21:52:54 -0500
Message-ID: <7f4de804-9095-9c62-719e-1d5d90ce518b@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It looks like commit 4be90bc (IB/mad: Remove ib_get_dma_mr calls
) broke SR-IOV usage with some of our older Mellanox IB cards. After
loading the mlx4_core module with some number of vfs specified (e.g.
modprobe mlx4_core num_vfs=16) the following errors appear and the
port's state never changes from INIT to ACTIVE:

[ 1946.325804] DMAR: DRHD: handling fault status reg 302
[ 1946.331442] DMAR: DMAR:[DMA Write] Request device [16:06.1] fault
addr fcb6e000
DMAR:[fault reason 02] Present bit in context entry is clear
[ 1946.525788] DMAR: DRHD: handling fault status reg 402
[ 1946.531416] DMAR: DMAR:[DMA Write] Request device [16:06.1] fault
addr fcb6d000
DMAR:[fault reason 02] Present bit in context entry is clear

If I revert to the parent commit (96249d7) the HCA and virtual functions
all initialize as expected.

I'm not sure where to turn next to debug the issue further. Any tips?

-- 
Aaron Knister
NASA Center for Climate Simulation (Code 606.2)
Goddard Space Flight Center
(301) 286-2776
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
