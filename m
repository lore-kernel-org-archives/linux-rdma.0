From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: MTU value affected RDMA performance?
Date: Tue, 27 Jul 2010 15:07:01 +0200 (CEST)
Message-ID: <7686034.1280236021632.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I have a question about RDMA. 

I work with Intel NetEffect NE020 cards and Extreme Summit x650 switch. 
I installed cards on two PCs IBM x3455 type 7986 | Dual-Core AMD Opteron
Processor 2214 2200MHz with Scientific Linux SL release
5.4|2.6.18-164.2.1.el5.
Driver is iw_nes and 10Gb Ethernet is eth2.
I run latency and bandwidth test with MTU=1500 Bytes.

Does MTU value affect the performance? 
If I change MTU value, why code does not work? 
(command line: ifconfig eth2 mtu 9000)
Is it possible to use jumbo frames MTU = 9000 Bytes at 10 Gb Ethernet?

I'm bit confuse about the role playes by MTU parameter.

Thank you in advance for clarification.

Regards,
Andrea



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
