From: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/7] IB/core: Fix typo in the name of the
 tag-matching cap struct
Date: Sun, 24 Sep 2017 22:18:48 +0200
Message-ID: <20170924201848.GB2029@nanopsycho>
References: <20170924184635.31948-1-leon@kernel.org>
 <20170924184635.31948-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170924184635.31948-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sun, Sep 24, 2017 at 08:46:29PM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>The tag matching functionality is implemented by mlx5 driver
>by extending XRQ, however this internal kernel information was
>exposed to user space applications with *xrq* name instead of *tm*.
>
>This patch renames *xrq* to *tm* to handle that.
>
>Fixes: 8d50505ada72 ("IB/uverbs: Expose XRQ capabilities")
>Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

[...]

>diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
>index 9a0b6479fe0c..d4e0b53bfc75 100644
>--- a/include/uapi/rdma/ib_user_verbs.h
>+++ b/include/uapi/rdma/ib_user_verbs.h
>@@ -261,7 +261,7 @@ struct ib_uverbs_ex_query_device_resp {
> 	struct ib_uverbs_rss_caps rss_caps;
> 	__u32  max_wq_type_rq;
> 	__u32 raw_packet_caps;
>-	struct ib_uverbs_tm_caps xrq_caps;
>+	struct ib_uverbs_tm_caps tm_caps;

Breaks UAPI?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
