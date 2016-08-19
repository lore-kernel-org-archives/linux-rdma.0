From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Fri, 19 Aug 2016 12:33:34 -0600
Message-ID: <20160819183334.GB20340@obsidianresearch.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
 <4cf7c492-ed42-d9cc-38e8-15d8c50d585f@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4cf7c492-ed42-d9cc-38e8-15d8c50d585f-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 17, 2016 at 05:35:42PM +0300, Sagi Grimberg wrote:
> 
> >diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> >index ccf1d51..87e4332 100644
> >+++ b/include/infiniband/verbs.h
> >@@ -209,6 +209,13 @@ enum ibv_odp_general_caps {
> > 	IBV_ODP_SUPPORT = 1 << 0,
> > };
> >
> >+#define ibv_is_qpt_supported(caps, qpt) ((caps) & (1 << (qpt)))
> 
> This looks useful, but not directly related to this patch. Would
> be better to add it in a stand-alone patch (even if its a one-liner).

And of course it should be a static inline....

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
