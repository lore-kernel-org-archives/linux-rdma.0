From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: size of queue pair number
Date: Fri, 25 May 2012 10:58:33 +0200
Message-ID: <1337936313.30523.6.camel@br9gv9yg.de.ibm.com>
References: <1337846845.20236.8.camel@br9gv9yg.de.ibm.com>
	 <CAL1RGDVdvb1q66YMDuaE2KKpnD6agvk8OhZ8HMJZQCznOn_5rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVdvb1q66YMDuaE2KKpnD6agvk8OhZ8HMJZQCznOn_5rw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-05-24 at 01:41 -0700, Roland Dreier wrote:
> The reason the queue pair number type is 32 bits in the Linux stack is
> that there is no u24 or uint24_t and very few processors have support
> for 24-bit integer types :)
> 
> The queue pair numbers are allocated by the hardware drivers, and
> modulo bugs they should always return a QPN that complies with the IB
> architecture.  So in other words, yes, you can safely assume that QPNs
> are in the range 0 ... 0xffffff.
> 
Thanks for your good and quick help. May I ask another question about
zero based virtual addressing: The Infiniband Architecture Specification
talks about specifying the "type of VA" when registering a memory
region. Checking the ib_verbs code in the Linux kernel I cannot find an
equivalent for this. Is zero based virtual addressing available in the
infiniband code of the Linux kernel?

Kind regards, Ursula Braun, IBM Germany

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
