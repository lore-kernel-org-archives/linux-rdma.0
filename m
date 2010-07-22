From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: about cxgb3 and cxgb4
Date: Thu, 22 Jul 2010 11:14:39 +0200 (CEST)
Message-ID: <3669127.1279790079150.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

I ask you an opinion about RDMA driver cxgb3 and cxb4.

I installed two NetEffect Intel cards on machines with OS Linux and
driver cxgb3. Please see the detail below:

[root@redigo-01 ~]# find / -name cxgb3
/sys/module/cxgb3
/sys/bus/pci/drivers/cxgb3
/usr/src/kernels/2.6.18-164.15.1.el5-x86_64/drivers/net/cxgb3
/usr/src/kernels/2.6.18-164.15.1.el5-x86_64/drivers/infiniband/hw/cxgb3
/usr/src/kernels/2.6.18-164.15.1.el5-x86_64/include/config/scsi/cxgb3
/usr/src/kernels/2.6.18-164.2.1.el5-x86_64/drivers/net/cxgb3
/usr/src/kernels/2.6.18-164.2.1.el5-x86_64/drivers/infiniband/hw/cxgb3
/usr/src/kernels/2.6.18-164.2.1.el5-x86_64/include/config/scsi/cxgb3
/usr/src/ofa_kernel-1.5.2/drivers/net/cxgb3
/usr/src/ofa_kernel-1.5.2/drivers/infiniband/hw/cxgb3
/lib/modules/2.6.18-164.2.1.el5/updates/kernel/drivers/net/cxgb3

/lib/modules/2.6.18-164.2.1.el5/updates/kernel/drivers/infiniband/hw/cxgb3
/lib/modules/2.6.18-164.2.1.el5/kernel/drivers/net/cxgb3
/lib/modules/2.6.18-164.2.1.el5/kernel/drivers/infiniband/hw/cxgb3
/lib/modules/2.6.18-164.15.1.el5/kernel/drivers/net/cxgb3
/lib/modules/2.6.18-164.15.1.el5/kernel/drivers/infiniband/hw/cxgb3
[root@redigo-01 ~]# find / -name cxgb4
[root@redigo-01 ~]# 

I read a lot of emails about cxgb4, but I have not installed.
Could cxgb4 give an improvement on transfer speed or latency? I think
the answer is negative, but ...
What is the gain for RDMA over Ethernet at 10 Gbit/s performance - if
there is - to install cxgb4 instead of cxgb3?

Ideas or suggestions are welcome.

Thank you very much,
Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552				

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
