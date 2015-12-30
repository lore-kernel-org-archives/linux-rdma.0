From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 5/7] IB/mlx4: Enable send of RoCE QP1 packets
 with IP/UDP headers
Date: Wed, 30 Dec 2015 13:04:55 +0200
Message-ID: <CAG9sBKMOE1ULAnL=OWiSYc76vgi8jiuhnQxY3Li9NwGy3+r7oQ@mail.gmail.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
	<1451395447-5198-6-git-send-email-matanb@mellanox.com>
	<CAJ3xEMgVvpj5S9gc_3onzCU5zjkXayOEZCCk_DofAwz194s8KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgVvpj5S9gc_3onzCU5zjkXayOEZCCk_DofAwz194s8KQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> The last hunk that you removed had a role and was by no means
> dead-code, right? so... (1) why it's correct to remove it? (2) if you
> want to introduce different way to implement what was done here, why
> in this patch? maybe add pre-patch for that

In a way you are right. This hunk does not insert a bug and even
improves correctness but it acutally belongs to an earlier patch
(dbf727de7440f73c4b92be4b958cbc24977e8ca2 IB/core: Use GID table in AH
creation and dmac resolution)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
