From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/10] IB/core: more fixes for create_flow uverbs (for
 v3.12)
Date: Thu, 10 Oct 2013 11:02:48 +0300
Message-ID: <52565F28.8010008@mellanox.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/10/2013 00:12, Yann Droneaud wrote:
> I've suggested reverting temporarily commit 22878db, 436f2ad, 400dbc9
> for v3.12 in a previous message [1]. This proposition doesn't sound
> acceptable for Or.
>
> So I continue to improve them to be in a better shape for v3.12.

Yan, we are 3-4 days before rc5 and as such renaming/beautifying things 
or removing checks for negative values
against unsigned variables et al cleanups are not acceptable. You need 
to re-arrange the series such that ONLY the fixes
to the user/kernel API are targeted to 3.12 and appear as the first 2-3 
patches, the rest will go to 3.13 subject to review.

Also - does git am removes the "Link: yyy" line  you added in your 
patches while applying them? if not, please place
below the --- line so we will not carry them in the kernel log.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
