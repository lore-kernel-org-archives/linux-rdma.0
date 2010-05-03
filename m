From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Hang in ib_umad when attempting to unregister.
Date: Mon, 3 May 2010 11:40:04 -0700
Message-ID: <B552CE79A4134D83A6F5122C6A021FFF@amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A47409EA@MNEXMB1.qlogic.org> <57C080F9018D4C488FD7F575E2CE231F@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A47409F6@MNEXMB1.qlogic.org> <134418B1760843CCA935A71D17114ABA@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A47409FE@MNEXMB1.qlogic.org> <CF9C39F99A89134C9CF9C4CCB68B8DDF254C321EFA@orsmsx501.amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A4740A0C@MNEXMB1.qlogic.org> <4C2744E8AD2982428C5BFE523DF8CDCB49A4740A1C@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740A1C-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Mike Heinz' <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: LINUX-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I should be more clear - there are a couple of reasons why I don't think
>Roland's patch is the cause, or a fix, for this problem. First, because when I
>dug through QLogic's bug database I found incidents like this going back to
>2007. Second, when I first began looking at this I noticed the patch and built
>a version that moved the cancel_delayed_work() calls in ib_cancel_rmpp_recvs()
>back inside the locked area and the problem still occurred.
>
>Finally, I should note that this isn't a spinlock type hang; what's happening
>is that destroy_rmpp_recv() appears to be sleeping, waiting for a completion
>that never arrives. I'm guessing that what is going on is that the reference
>count in an rmpp_recv is wrong, but what is causing the problem is unknown.

What RMPP messages were being sent/received?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
