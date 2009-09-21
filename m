From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: How to handle illegal multicast addresses in IPoIB?
Date: Mon, 21 Sep 2009 17:39:11 +0300
Message-ID: <4AB7900F.2020406@Voltaire.COM>
References: <4AB78040.9000606@Voltaire.COM> <4AB78EC9.7020805@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AB78EC9.7020805-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Moni Shoua wrote:
>> One patch (http://lists.openfabrics.org/pipermail/general/2009-August/061663.html) checks each 
>> multicast address for validity before it lets it get into the queue. 
> 
> isn't it the below commit which appears in Linus tree?
> 
> Or.
>> commit 5e47596bee12597824a3b5b21e20f80b61e58a35
>> Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Yes, thanks you...
I must have missed it.

So there is only one question left. Do we also need the other patch?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
