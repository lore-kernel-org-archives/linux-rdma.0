From: Arka Sharma <arka.sw1988-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Difference between normal and fast memory registration
Date: Mon, 10 Jul 2017 22:25:58 +0530
Message-ID: <CAPO=kN1Qcb8SSvyxGgGPLgYOTGoGnV32RLNJU=f+b9_1aMYdcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

Sorry for asking this question as this might sound very fundamental. I
am very much new in rdma and Linux. I am trying to figure out how fast
memory registration improves the cost of registration compared to
normal registration ?. As per my understanding when we do memory
registration then following steps occur.
1. The pages are pinned in physical memory
2. The physical addresses are transferred to the RNIC via bus specific
mechanism to which RNIC is connected, in my case it is PCIe.
Once a memory is registered we can acquire Lkey and Rkey. This is the
case with normal registration. As mentioned in the paper named
An Efficient Design for Fast Memory Registration in RDMA

 "With FMR, user pre-allocates a table in kernel memory to record
physical address of memory region, and pre writes I/O registers of
RDMA card to register memory information, and only fills the table for
physical address of memory region during the real memory registration
operations."

So my question is in case of fast registration when exactly physical
addresses are written in registers of RNIC card. If it is done in
initialization as I am thinking by reading this statement, in that
case the physical location of data buffer to be registered may be
different with the address that has been programmed to the RNIC. I
have read in RDMA verbs specification that in case of fast
registration we need to create a work request and post to SQ. Why this
kind of approach is needed in case of fast registration.

Some clarification of this will be highly appreciated.

Regards,
Arka
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
