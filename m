From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 0/3] Least attached vector support
Date: Tue, 2 Apr 2013 14:20:35 +0000 (UTC)
Message-ID: <loom.20130402T161828-251@post.gmane.org>
References: <4BEBC56C.3090605@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Yevgeny Petrilin <yevgenyp@...> writes:

> Hello Roland,
> 
> Those patches where submitted a while ago, I cleaned them up a little and
generated against your latest git.
> They allow to hw driver to choose to which EQ a CQ would be attached,
considering the load on its eqs.

(replying to an e-mail from three years ago)

Hello,

Can anyone tell me what happened with this patch series ? To me this looks like
a useful patch series to make the mlx4_en driver faster. However, I haven't seen
anyone posting any review comments to this series and apparently this
functionality isn't upstream either.

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
