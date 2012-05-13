From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/6] IB/core: fix mismatch between locked and
 pinned pages
Date: Sun, 13 May 2012 10:11:51 +0300
Message-ID: <4FAF5EB7.5050805@mellanox.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com> <1336681689-16668-3-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.00.1205111205530.31049@router.home> <CAL1RGDWVQuhSWkK1qK98Ar6YrsL02_m9kkAY4pDFaCqhMyHKiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWVQuhSWkK1qK98Ar6YrsL02_m9kkAY4pDFaCqhMyHKiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/11/2012 9:38 PM, Roland Dreier wrote:
> applied, with Christoph's reviewed-by and a Cc: stable tag.  Thanks everyone.

Hi Roland,

Okay, thanks, I see that you still haven't pushed these updates to the 
infiniband tree, will be helpful if you can do that soon, such that 
we'll be able to work directly against your tree with the patches 
accepted so far applied.

Now... with 3.4-rc7 being out, the 3.5 merge window is coming really 
soon, any chance you'll have time to look on the new QP group verbs, 
IPoIB TSS/RSS code in the coming days?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
