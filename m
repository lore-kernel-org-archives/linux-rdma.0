From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Hang in ib_umad when attempting to unregister.
Date: Mon, 3 May 2010 12:06:43 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740A0C@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409EA@MNEXMB1.qlogic.org>
 <57C080F9018D4C488FD7F575E2CE231F@amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49A47409F6@MNEXMB1.qlogic.org>
 <134418B1760843CCA935A71D17114ABA@amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49A47409FE@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF254C321EFA@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF254C321EFA-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LINUX-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ah. Got it. Thanks.

They do seem to be related. 0e442afd92fcdde2cc63b6f25556b8934e42b7d2 seems to be directly related - but I think that fix is already in OFED 1.5:

core_0310-IB-mad-Fix-lock-lock-timer-deadlock-in-RMPP-code.patch

seems to be the same patch as 0e442afd92fcdde2cc63b6f25556b8934e42b7d2.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Monday, May 03, 2010 12:40 PM
To: Mike Heinz
Subject: RE: Hang in ib_umad when attempting to unregister.

>Where did you get those commit #s? I looked in my local copy of
>
>git://git.openfabrics.org/ofed_1_5/linux-2.6
>
>and they don't seem to be valid objects for that repo. Am I pulling from the
>wrong place?

These are from the upstream kernel.

>commit 6b2eef8fd78ff909c3396b8671d57c42559cc51d
>commit 0e442afd92fcdde2cc63b6f25556b8934e42b7d2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
