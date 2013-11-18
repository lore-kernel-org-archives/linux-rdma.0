From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Infiniband merge plans for 3.13
Date: Mon, 18 Nov 2013 20:43:08 +0200
Message-ID: <CAJZOPZ+ewrpXqkEf18HMkU9KZgU=21T743FG_LDBC3-d0iUFew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

So it seems your for-next branch gets hot toward pull request to Linus.

Can you spare few words on how you see the IP based Addressing V5
series?! we have addressed the concerns you raised re compatibility
and also simplified the series to avoid using uverbs extensions @ this
point, anything else left there?

This series is pre-step for submitting SRIOV support to RoCE (the code
is ready!) and hence no Cloud IBoE upstream solution for VMs  before
we nail that, it deserves your response.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
