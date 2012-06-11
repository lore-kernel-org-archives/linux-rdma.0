From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: size of queue pair number
Date: Mon, 11 Jun 2012 17:10:01 +0200
Message-ID: <1339427401.17528.7.camel@br9gv9yg.de.ibm.com>
References: <1337846845.20236.8.camel@br9gv9yg.de.ibm.com>
	 <CAL1RGDVdvb1q66YMDuaE2KKpnD6agvk8OhZ8HMJZQCznOn_5rw@mail.gmail.com>
	 <1337936313.30523.6.camel@br9gv9yg.de.ibm.com>
	 <CAL1RGDVn9r+6P+5usqwKOJB-y8zTY_pNm5Zore8hS-q+bjXjGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVn9r+6P+5usqwKOJB-y8zTY_pNm5Zore8hS-q+bjXjGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-05-25 at 09:01 -0700, Roland Dreier wrote:
> > Thanks for your good and quick help. May I ask another question about
> > zero based virtual addressing: The Infiniband Architecture Specification
> > talks about specifying the "type of VA" when registering a memory
> > region. Checking the ib_verbs code in the Linux kernel I cannot find an
> > equivalent for this. Is zero based virtual addressing available in the
> > infiniband code of the Linux kernel?
> 
> No, I don't believe we ever implemented it.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
If zero based virtual addressing has never been implemented within
Linux, does this mean an ib_post_send() with opcode IB_WR_RDMA_WRITE
requires specification of both - rdma.rkey AND rdma.remote_addr?
And thus means there is a need to exchange both somehow in advance?

Kind regards, Ursula Braun, IBM Germany

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
