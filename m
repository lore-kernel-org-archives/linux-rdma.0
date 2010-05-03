From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Hang in ib_umad when attempting to unregister.
Date: Mon, 3 May 2010 13:25:46 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740A1C@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409EA@MNEXMB1.qlogic.org>
 <57C080F9018D4C488FD7F575E2CE231F@amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49A47409F6@MNEXMB1.qlogic.org>
 <134418B1760843CCA935A71D17114ABA@amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49A47409FE@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF254C321EFA@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49A4740A0C@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740A0C-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LINUX-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I should be more clear - there are a couple of reasons why I don't think Roland's patch is the cause, or a fix, for this problem. First, because when I dug through QLogic's bug database I found incidents like this going back to 2007. Second, when I first began looking at this I noticed the patch and built a version that moved the cancel_delayed_work() calls in ib_cancel_rmpp_recvs() back inside the locked area and the problem still occurred.

Finally, I should note that this isn't a spinlock type hang; what's happening is that destroy_rmpp_recv() appears to be sleeping, waiting for a completion that never arrives. I'm guessing that what is going on is that the reference count in an rmpp_recv is wrong, but what is causing the problem is unknown. 

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Mike Heinz
Sent: Monday, May 03, 2010 1:07 PM
To: Hefty, Sean
Cc: LINUX-RDMA
Subject: RE: Hang in ib_umad when attempting to unregister.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
