From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Update proposal for handling BUSY responses from the SA/SM
Date: Wed, 11 Aug 2010 14:05:51 -0500
Message-ID: <5AEC2602AE03EB46BFC16C6B9B200DA816BB467C5A@MNEXMB2.qlogic.org>
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
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason
List-Id: linux-rdma@vger.kernel.org

> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> It breaks the ABI and existing apps that *do* handle BUSY replies.  We
> can't assume that no apps out there aren't written correctly.
> ....
> The mad interface is privileged, not some generic API available to any
> user space app.

I have yet to find a single app (OFA or 3rd party) which handles BUSY properly.  Right now we can identify numerous apps which are broken.

While umad is privileged, the SA queries it allows are used by every IB compliant app and ULP.  If is also used by many management apps which are also priviledged.

The proposed change will not break any apps and does not change the ABI, it will simply limit when they see busy (in Mike's most recently posted patch, after all retries were exhausted, a BUSY would be returned so the app could handle "long duration BUSY", while the kernel would handle "short duration BUSY").


Todd Rimmer


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
