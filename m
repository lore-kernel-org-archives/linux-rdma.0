From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: size of queue pair number
Date: Mon, 11 Jun 2012 09:08:34 -0700
Message-ID: <CAL1RGDXtW0gq6N8CurBrBbYpGGShOm2bttRd7hQxh+aroC3ksQ@mail.gmail.com>
References: <1337846845.20236.8.camel@br9gv9yg.de.ibm.com> <CAL1RGDVdvb1q66YMDuaE2KKpnD6agvk8OhZ8HMJZQCznOn_5rw@mail.gmail.com>
 <1337936313.30523.6.camel@br9gv9yg.de.ibm.com> <CAL1RGDVn9r+6P+5usqwKOJB-y8zTY_pNm5Zore8hS-q+bjXjGw@mail.gmail.com>
 <1339427401.17528.7.camel@br9gv9yg.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339427401.17528.7.camel-EWOwsnNsUwS5SqV9CvDRx0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 11, 2012 at 8:10 AM, Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> If zero based virtual addressing has never been implemented within
> Linux, does this mean an ib_post_send() with opcode IB_WR_RDMA_WRITE
> requires specification of both - rdma.rkey AND rdma.remote_addr?
> And thus means there is a need to exchange both somehow in advance?

Yes, correct.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
