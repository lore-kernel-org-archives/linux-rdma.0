From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Thu, 25 Nov 2010 10:36:27 +0200
Message-ID: <4CEE200B.70106@Voltaire.com>
References: <20101115140829.GA20355@mtldesk30> <ada62vxl046.fsf@cisco.com>	<20101116180732.GB29132@mtldesk30> <ada1v6klwil.fsf@cisco.com>	<20101117090134.GA20369@mtldesk30> <adasjyzkfyw.fsf@cisco.com>	<20101118065142.GB20369@mtldesk30> <AANLkTinN43YgQW3ftbng-4f2NiNe9_oXPVCX5LPzh7uG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinN43YgQW3ftbng-4f2NiNe9_oXPVCX5LPzh7uG-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Aleksey Senin wrote:
> RAW_ETH patches cannot be applied without it, so we really need this masking.

So Maybe it would be easier to review and merge if you add this patch to the raw qp patch set
you mentioned

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
