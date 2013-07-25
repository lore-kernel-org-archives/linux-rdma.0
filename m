From: xrg.dev-8HG2SOrYmURWk0Htik3J/w@public.gmane.org
Subject: ibv_reg_mr fails with ENOMEM and iommu_alloc error on PPC64
Date: Thu, 25 Jul 2013 08:56:35 -0400
Message-ID: <20130725125635.AC1E2200B4@smtp.hushmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi list,

I am moving my work environment on P/Linux, and I am having trouble register large amount of memories. The device I have are ConnectX-3 EN (RoCE). i am trying to register 16GB of memory, mmap and mlock succeeded, but ibv_reg_mr returns ENOMEM.

Concurrently, the kernel log reports the following while trying to ibv_reg_mr :

kernel: iommu_alloc failed, tbl c000001f33e4a680 vaddr c000001ebd7b0000 npages 10

I set log_num_mtt = 20 and log_mtts_per_seg=7, and the page size on that architecture is 64KB.

Any clue at what might be wrong ?

Some system info :

OS: RHEL 6.4
Kernel: 2.6.32-358.14.1.el6.ppc6

Thanks,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
