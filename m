From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: size of queue pair number
Date: Fri, 25 May 2012 09:01:58 -0700
Message-ID: <CAL1RGDVn9r+6P+5usqwKOJB-y8zTY_pNm5Zore8hS-q+bjXjGw@mail.gmail.com>
References: <1337846845.20236.8.camel@br9gv9yg.de.ibm.com> <CAL1RGDVdvb1q66YMDuaE2KKpnD6agvk8OhZ8HMJZQCznOn_5rw@mail.gmail.com>
 <1337936313.30523.6.camel@br9gv9yg.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337936313.30523.6.camel-EWOwsnNsUwS5SqV9CvDRx0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Thanks for your good and quick help. May I ask another question about
> zero based virtual addressing: The Infiniband Architecture Specification
> talks about specifying the "type of VA" when registering a memory
> region. Checking the ib_verbs code in the Linux kernel I cannot find an
> equivalent for this. Is zero based virtual addressing available in the
> infiniband code of the Linux kernel?

No, I don't believe we ever implemented it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
