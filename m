From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V3 1/8] IB/core: Change provider's API of
 create_cq to be extendible
Date: Thu, 27 Aug 2015 12:11:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1508271210160.1413@east.gentwo.org>
References: <1434029727-6062-1-git-send-email-ogerlitz@mellanox.com> <1434029727-6062-2-git-send-email-ogerlitz@mellanox.com> <20150611175555.GB20142@obsidianresearch.com> <CAJ3xEMgA0UorV3ERz_M7-H0Z4c6tmK2e_k84c6VExhzjQJ+9LQ@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgA0UorV3ERz_M7-H0Z4c6tmK2e_k84c6VExhzjQJ+9LQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ok we tested this patchset with Matans timestamp-v2 branches from his repo
on github and the timestamps now work fine.

Can we please get the user space library bits into libibverbs and libmlx4?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
