From: Liu Ginhann <Ginhann.Liu-Omk3PdybHIaN9aS15agKxg@public.gmane.org>
Subject: ibv_reg_mr call failed
Date: Fri, 24 May 2013 17:43:06 +0000
Message-ID: <B78BFEBC60BCD84AABFE4C6AE4239F303631433D@BY2PRD0412MB622.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are running into an unexpected problem while registering memory for IB operation. Ibv_reg_mr() call return EFAULT - bad address. 

The pointer passed into ibv_reg_mr call is mmap back from memory allocated in our kernel driver. Our test code is able to use this mapped back virtual address to peek and poke without issue; the size is expected. This memory is a fixed size FIFO buffer designed to be used as our FPGA device buffer and IB transport buffer. There is host software to manage buffer usage. If we just malloc memory from app and pass it into ibv_reg_mr call, memory register call return ok.

It seems like for some reason, ibv_reg_mr doesn't like the pointer we passed in. Here is how we allocate and map the buffer inside the driver, 
. 4M memory is created and allocated using the kmem_cache_create, kmem_cache_alloc call during driver initialization.
. When mmap is called from user application at run-time, remap_pfn_range is called to map the buffer into the process's virtual address space. page_to_pfn(virt_to_page(buffer) is used to convert kernel virtual address into page and pfn.

We tried to change flags during allocation or mapping, but none of them work.

Any suggestion how to solve this problem?

Here is version information of our test chassis,
64-bit Suse Linux: 3.0.35-rt58-0.5-rt
OFED Info: MLNX_OFED_LINUX-1.5.3-3.1.0 (OFED-1.5.3-3.1.0)

Regards, 



Hank Liu



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
