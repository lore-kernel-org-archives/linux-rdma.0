From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: Socket Direct Protocol: help (2)
Date: Thu, 15 Apr 2010 09:07:44 +0200 (CEST)
Message-ID: <1205877.1271315264088.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com> <4BC49E2B.3000804@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com> <4BC4D22A.6020700@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com> <7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BC5D1D3.3020004@mellanox.co.il> <4BC5D529.1060701@mellanox.co.il> <2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com> <4BC5D9D4.7020702@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C79BD12@azsmsx506.amr.corp.intel.com> <4BC6B135.20
 60004@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BC6B135.2060004-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "mingo-X9Un+BFzKDI@public.gmane.org" <mingo-X9Un+BFzKDI@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 15, 2010 08:24 AM, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:

> I hope to have a fix next week for the first one.
> 
> Thanks,
> Amir
> 
> On 04/14/2010 09:48 PM, Tung, Chien Tin wrote:
> >> Tung, Chien Tin wrote:
> >>     
> >>>> One more thing - Please open a bug regarding the num_sge
> >>>> limitation at:
> >>>> https://bugs.openfabrics.org/
> >>>>
> >>>>         
> >>> Done, Bug 2027.
> >>>
> >>> Chien
> >>>
> >>>       
> >> And 2028 opened to request fastreg support.
> >>
> >>     
> >
> > I am open to test fixes for these two bugs.
> >
> > Chien
> >
> >   
> 

Hi Amir, 
Hi Chien,

I understand that the bug 2027 could be solved next week, so I will test
SDP protocol performance on NE020 cards.
Is it correct? 
If yes, could you point out the code modifies?

Keep in touch and take care.
Regards,
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
