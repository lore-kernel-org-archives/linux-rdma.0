From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: bug 2028:SDP protocol fast memory registration
Date: Fri, 9 Jul 2010 11:36:44 +0200 (CEST)
Message-ID: <2425749.1278668204885.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BC49E2B.3000804@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com> <4BC4D22A.6020700@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com> <7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BC5D1D3.3020004@mellanox.co.il> <4BC5D529.1060701@mellanox.co.il> <2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com> <4BC5D9D4.7020702@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C79BD12@azsmsx506.amr.corp.intel.com> <4BC6B135.2060004@mellanox.co.il> <1205877.1271315264088.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BC6D075.1070405@mellanox.co.il> <6490876.127177162
 0997.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BCEE8FE.6!	050805@mellanox.co.il> <484607.1272033291418.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BD3F0A9.4080306@mellanox.co.il> <4BD5DAFC.203070!
 5@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BD5DAFC.2030705-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "mingo-X9Un+BFzKDI@public.gmane.org" <mingo-X9Un+BFzKDI@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 26, 2010 08:27 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
wrote:

> 
> Amir Vadai wrote:
> > I have a fix for 2027 (number of SGE's issue) read.
> > I'm busy with other things - but hopefully will succeed testing it
> > and
> > pushing it today.
> >
> > As to 2028 (No FMR support) - I need pushed a fix to only disable
> > ZCopy
> > when no FMR facility.
> > I don't have time right now to add support for fast memory
> > registeration
> > when FMR is not available - but Steve said he'll help with
> > implementing it.
> >
> > - Amir
> >
> >   
> (I removed this from the linux-kernel list)
> 
> I probably won't get to adding fast memory registration until
> July/August.
> 
> 
> Steve.
> 

Hi Steve,

have any news about SDP protocol fast memory registration (bug 2028)?
Please, if you can, give me an update.

Thank you very much.
Keep in touch,
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
