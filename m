From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with MLX5 IB driver
Date: Thu, 1 Jun 2017 11:05:01 +0100
Message-ID: <09d8f6bc-5994-82d1-9a0f-59540b6c525f@synopsys.com>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>
 <20170531161819.GK5406@mtr-leonro.local>
 <20170531194426.GA23120@infradead.org>
 <20170601043013.GN5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170601043013.GN5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hello,

Às 5:30 AM de 6/1/2017, Leon Romanovsky escreveu:
> On Wed, May 31, 2017 at 12:44:26PM -0700, Christoph Hellwig wrote:
>> On Wed, May 31, 2017 at 07:18:19PM +0300, Leon Romanovsky wrote:
>>> I think that you are hitting the side effect of these commits
>>> 7d0cc6edcc70 ("IB/mlx5: Add MR cache for large UMR regions") and
>>> 81713d3788d2 ("IB/mlx5: Add implicit MR support")
>>>
>>> Do you have CONFIG_INFINIBAND_ON_DEMAND_PAGING on? Can you disable it
>>> for the test?
>>
>> Eww.  Please make sure mlx5 gracefully handles cases where it can't use
>> crazy amount of memory, including disabling features like the above
>> at runtime when the required resources aren't available.
> 
> Right, the real consumer of memory in mlx5_ib is mr_cache, so the
> question is how can we check in advance if we have enough memory
> without calling allocations with GFP_NOWARN flag.
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=DPL6_X_6JkXFx7AXWqB0tg&r=s2fO0hii0OGNOv9qQy_HRXy-xAJUD1NNoEcc3io_kx0&m=Uf5GrWBvnD9y_cvJHxE3U34WbGfrJ6SH6xoBLXn3-iA&s=qOiYqKtZvTJzs3QPNC_YxrNg-S_g-1PfDr0ZvDTE5pY&e= 

With CONFIG_INFINIBAND_ON_DEMAND_PAGING disabled:
Crashes the same way.

With MLX5_DEFAULT_PROF defined as 0:

There is no crash.

mlx5_core 0000:01:00.0: enabling device (0000 -> 0002)
mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit PCI DMA mask
mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit consistent PCI DMA mask
mlx5_core 0000:01:00.0: firmware version: 16.19.21102
(...)
mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Feb 2014)
(...)
mlx5_core 0000:01:00.0: device's health compromised - reached miss count
mlx5_core 0000:01:00.0: assert_var[0] 0x00000001
mlx5_core 0000:01:00.0: assert_var[1] 0x00000000
mlx5_core 0000:01:00.0: assert_var[2] 0x00000000
mlx5_core 0000:01:00.0: assert_var[3] 0x00000000
mlx5_core 0000:01:00.0: assert_var[4] 0x00000000
mlx5_core 0000:01:00.0: assert_exit_ptr 0x006994c0
mlx5_core 0000:01:00.0: assert_callra 0x00699680
mlx5_core 0000:01:00.0: fw_ver 16.19.21102
mlx5_core 0000:01:00.0: hw_id 0x0000020d
mlx5_core 0000:01:00.0: irisc_index 0
mlx5_core 0000:01:00.0: synd 0x1: firmware internal error
mlx5_core 0000:01:00.0: ext_synd 0x11c5
mlx5_core 0000:01:00.0: raw fw_ver 0x1013526e

lspci -v result:

01:00.0 Infiniband controller: Mellanox Technologies MT28800 Family [ConnectX-5 Ex]
        Subsystem: Mellanox Technologies Device 0002
        Flags: bus master, fast devsel, latency 0
        Memory at d2000000 (64-bit, prefetchable) [size=32M]
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [48] Vital Product Data
        Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
        Capabilities: [c0] Vendor Specific Information: Len=18 <?>
        Capabilities: [40] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [1c0] #19
        Capabilities: [320] #27
        Kernel driver in use: mlx5_core

Interrupts:

 45:          0   PCI-MSI   0  aerdrv
 46:          2   PCI-MSI 524288  mlx5_pages_eq@pci:0000:01:00.0
 47:        347   PCI-MSI 524289  mlx5_cmd_eq@pci:0000:01:00.0
 48:          0   PCI-MSI 524290  mlx5_async_eq@pci:0000:01:00.0
 50:          0   PCI-MSI 524292  mlx5_comp0@pci:0000:01:00.0

List of devices:

# ls /dev/infiniband/
issm0    rdma_cm  ucm0     umad0    uverbs0

Shouldn't I be getting some mellanox devices?

Thanks,
Joao

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
