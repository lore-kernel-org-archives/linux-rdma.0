From: john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org (John A. Gregor)
Subject: Re: [PATCH v2 13/51] IB/qib: Add qib_driver.c
Date: Wed, 07 Apr 2010 15:58:01 -0700
Message-ID: <4bbd0df9.9ytN9eNcGH0QOhV2%john.gregor@qlogic.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
 <20091203190413.29507.17962.stgit@chromite.mv.qlogic.com>
 <adafx3743n6.fsf@roland-alpha.cisco.com>
 <4BBCDBD6.8010809@opengridcomputing.com>
 <ada7hoj2h35.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada7hoj2h35.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>  > Where can I find information on trace events?  Something in Documentation/*?
>
> Yep, Documentation/trace/events.txt.

LWN just did a really good writeup on using the TRACE_EVENT macro:

	http://lwn.net/Articles/379903/

Part 2 is still behind the paywall.

-John Gregor
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
