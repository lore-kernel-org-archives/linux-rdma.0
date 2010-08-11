From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Update proposal for handling BUSY responses from the SA/SM
Date: Wed, 11 Aug 2010 13:47:13 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493AC5@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A43@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96016FF@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A87@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601761@orsmsx501.amr.corp.intel.com>
 <5AEC2602AE03EB46BFC16C6B9B200DA816BB467C46@MNEXMB2.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96017FE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96017FE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason
List-Id: linux-rdma@vger.kernel.org

> It breaks the ABI and existing apps that *do* handle BUSY replies.  We can't assume that no apps out there aren't written correctly.

I could be wrong, but I couldn't find a single example in the OFED 1.5.2 package.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, August 11, 2010 1:58 PM
To: Todd Rimmer; Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Roland Dreier; Jason Gunthorpe; Hal Rosenstock
Subject: RE: Update proposal for handling BUSY responses from the SA/SM

> Coding IB applications is hard enough, let's not require it to be harder.
> We need a solution that fixes all the apps and makes it easy for future
> applications to have a sensible default behavior.

The mad interface is privileged, not some generic API available to any user space app.

> I think Mike's approach does that, minimizes risk, addresses 3rd party apps
> which may not be part of OFA, and has a path toward allowing sophisticated
> applications to control the behavior (few if any apps will really want to
> do that).

It breaks the ABI and existing apps that *do* handle BUSY replies.  We can't assume that no apps out there aren't written correctly. 

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
