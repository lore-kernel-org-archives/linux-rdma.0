From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: RE: Socket Direct Protocol: help (2)
Date: Wed, 14 Apr 2010 10:51:45 +0200 (CEST)
Message-ID: <7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com> <4BC49E2B.3000804@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com> <4BC4D22A.6020700@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E9047C7405E9-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "mingo-X9Un+BFzKDI@public.gmane.org" <mingo-X9Un+BFzKDI@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 13, 2010 10:22 PM, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
wrote:

> >>> Chien, does the NE020 support FMRs? I looked at the nes ofed-1.5
> >>> code
> >>> and it appears to do nothing in the map_phys_fmr functions.
> >>>
> >>
> >> We never implemented map_phys_fmr. Is it relevant to the # of SGEs?
> >>
> >No, but SDP uses FMRs. I don't think it will run without FMR support.
> >
> 
> 
> Good to know.  Thanks.
> 
> Chien
> 
> 

Hi Steve and Chien,

I understand that NE020 cards have problem with SDP connected with
map_phy_fmr (FMR stands for Fast Memory Region).
Is it possible to solve/fix this point?
If yes, have you an idea about the time that is necessary to code
development/build?
If no, can you suggest me a card that supports SDP protocol?

I work on NE020 cards from February 2010 for an INFN experimental
proposal, called REDIGO (Read out at 10 Gbits/s), about the data
acquisition and movement systems. The covergence of storage protocols
around 10 Gigabits/s Ethernet protocols shows that one way could be the
Remote Direct Memory Access (RDMA). The goals are the investigations of
latency time, the throughput, the buffer size schemes and finally the
global event building bandwidth.

Do you know if NE020 cards have problems with librdma (RDMA procedures,
in general) and / or with MPI versions?

Thank you very much,
Andrea

Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
