From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/core: Add support for RX/TX checksum
 offload capabilities report
Date: Wed, 5 Aug 2015 11:16:34 -0600
Message-ID: <20150805171634.GA12274@obsidianresearch.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
 <1438788867-18332-2-git-send-email-amirv@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438788867-18332-2-git-send-email-amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 05, 2015 at 06:34:26PM +0300, Amir Vadai wrote:
>  struct ib_uverbs_ex_query_device {
>  	__u32 comp_mask;
> +	__u32 csum_caps;
>  	__u32 reserved;
>  };

Uh no.

> @@ -221,6 +222,7 @@ struct ib_uverbs_odp_caps {
>  struct ib_uverbs_ex_query_device_resp {
>  	struct ib_uverbs_query_device_resp base;
>  	__u32 comp_mask;
> +	__u32 csum_caps;
>  	__u32 response_length;
>  	struct ib_uverbs_odp_caps odp_caps;
>  	__u64 timestamp_mask;

Also totally wrong.

Or, WTF? why is something so screwed up like this being sent to the list?

NAK

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
