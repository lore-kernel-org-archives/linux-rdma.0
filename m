From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: How to handle illegal multicast addresses in IPoIB?
Date: Mon, 21 Sep 2009 17:33:45 +0300
Message-ID: <4AB78EC9.7020805@Voltaire.com>
References: <4AB78040.9000606@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AB78040.9000606-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Moni Shoua wrote:
> One patch (http://lists.openfabrics.org/pipermail/general/2009-August/061663.html) checks each 
> multicast address for validity before it lets it get into the queue. 

isn't it the below commit which appears in Linus tree?

Or.
> commit 5e47596bee12597824a3b5b21e20f80b61e58a35
> Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date:   Sat Sep 5 20:23:40 2009 -0700
> 
>     IPoIB: Check multicast address format
> 
>     Check that the format of multicast link addresses is correct before
>     taking them from dev->mc_list to priv->multicast_list.  This way we
>     never try to send a bogus address to the SA, which prevents badness
>     from erronous 'ip maddr addr add', broken bonding drivers, etc.
> 
>     Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>     Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
