From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 0/3] New RAW_PACKET QP type
Date: Fri, 5 Nov 2010 09:05:59 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D6128@orsmsx501.amr.corp.intel.com>
References: <4CD171F0.8020506@voltaire.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8308783@orsmsx501.amr.corp.intel.com>
 <4CD41D5D.9030103@opengridcomputing.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D606E@orsmsx501.amr.corp.intel.com>
 <4CD420C3.1090803@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD420C3.1090803-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The linux PF_PACKET interface comes to mind.  It allows
> sending/receiving raw ethernet frames:
> 
> ----
>         Packet  sockets  are  used to receive or send raw packets at the
> device
>         driver (OSI Layer 2) level. They allow the user to  implement
> protocol
>         modules in user space on top of the physical layer.

I don't have a strong preference on the name, but isn't PF_PACKET further qualified by the socket type to indicate if the user provides the L2 header or not?  Maybe we just need that additional qualifier.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
