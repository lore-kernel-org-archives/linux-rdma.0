From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: MTU value affected RDMA performance?
Date: Tue, 27 Jul 2010 06:18:15 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9049ED0AA33@azsmsx506.amr.corp.intel.com>
References: <7686034.1280236021632.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7686034.1280236021632.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I work with Intel NetEffect NE020 cards and Extreme Summit x650 switch.
> I installed cards on two PCs IBM x3455 type 7986 | Dual-Core AMD Opteron
> Processor 2214 2200MHz with Scientific Linux SL release
> 5.4|2.6.18-164.2.1.el5.
> Driver is iw_nes and 10Gb Ethernet is eth2.
> I run latency and bandwidth test with MTU=1500 Bytes.
> 
> Does MTU value affect the performance?

Yes it does make a difference.

> If I change MTU value, why code does not work?

Can you be more specific on what does not work?
Is your switch configured to work with MTU of 9000?

Chien



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
