From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: RE: MTU value affected RDMA performance?
Date: Tue, 27 Jul 2010 15:58:39 +0200 (CEST)
Message-ID: <5912490.1280239119794.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <7686034.1280236021632.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <2EFBCAEF10980645BBCFB605689E08E9049ED0AA33@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E9049ED0AA33-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jul 27, 2010 03:18 PM, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
wrote:

> > I work with Intel NetEffect NE020 cards and Extreme Summit x650
> > switch.
> > I installed cards on two PCs IBM x3455 type 7986 | Dual-Core AMD
> > Opteron
> > Processor 2214 2200MHz with Scientific Linux SL release
> > 5.4|2.6.18-164.2.1.el5.
> > Driver is iw_nes and 10Gb Ethernet is eth2.
> > I run latency and bandwidth test with MTU=1500 Bytes.
> > 
> > Does MTU value affect the performance?
> 
> Yes it does make a difference.
> 
> > If I change MTU value, why code does not work?
> 
> Can you be more specific on what does not work?
> Is your switch configured to work with MTU of 9000?
> 
> Chien
> 
> 
> 
Hi Chien,

I read from the switch manual (paragraph "general specification"):
9216 Bytes maximum packet size (Jumbo Frame)

So switch can work with MTU=9000 Bytes, but I have not configured yet. 

I have not idea about RDMA performance and MTU relationship.
MTU=9000 Bytes; latency decreases and throughpt increases. 
Is the statement above correct?

I will study how operate on swicth. 
Actually, I modify MTU value on two machines, I run test and it stops
when client RDMA sends buffers to RDMA server: it seems there is no
communication channel. Both machines are in pending status probably
because the switch is not configured with MTU=9000 Bytes.

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
