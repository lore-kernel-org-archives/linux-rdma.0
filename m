From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Tue, 28 Apr 2015 15:57:53 +0300
Message-ID: <CAJ3xEMj4N+sNmnZWwNyNWn5o-AVpf-koekj3wnzakkHvXb09fw@mail.gmail.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
	<44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
	<CAJ3xEMgepRUQs+GiMWxzV_QFaRnfbX7TPOdB_sKgRhHj7x7NDg@mail.gmail.com>
	<553DE614.7050508@mellanox.com>
	<CAJ3xEMjEhv3Nm_EfFcBWLk1ChQXBM5KvPxh5DstCqxeMo0MGwA@mail.gmail.com>
	<553F341D.8000907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <553F341D.8000907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 28, 2015 at 10:17 AM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 4/27/2015 9:22 PM, Or Gerlitz wrote:
> I think the real question is why to deal with RCUs that will require
> re-allocation of entries when it's not necessary or why do we want to use
> rwlock if the kernel provides a mechanism (called seqcount) that fits this
> problem better?
> I disagree about seqcount being complex - if you look at its API you'll find
> it's a lot simpler than RCU.

I took a 2nd look, seqcount is indeed way simpler from RCU, and by
itself is simple to use
if you feel this provides better solution vs. simple rwlock, so I'm
good with that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
