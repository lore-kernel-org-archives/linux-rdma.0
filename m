From: Eva Mishra <eva.mishra2007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: physical memory registration
Date: Fri, 13 Sep 2013 14:35:27 +0530
Message-ID: <CAAcPZE5JHF-XDkojg=kRSRXeo+E-79hjLoMiXi1B5U_T_FQv2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I understood following steps for register physical memory region verb
as defined in InfiniBand specification

step 1: Allocate kernel memory using kmalloc etc. Return address is a
kernel virtual address. Allocate multiple buffers.
step 2: Get corresponding physical addressess of buffers returned in step 1
step 3: Give the physical addresses as 'addr' inputs to physical
buffer list structure ib_phys_buf as defined in ofed
step 4: GIve sizes of allocated buffers as 'size' inputs to physical
buffer list structure ib_phys_buf as defined in ofed
step 5: Request an iova to be used as an address for posting
operations. iova can be any  arbitrary address.

Please check if the above understanding is correct

whether iova to be provided is a physical address or virtual address ?
Does iova give one single reference to all physical buffers in
physical buffer list to consumer ?

Please give some pointers for understanding of physical memory
registrations apart from IB-specification
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
