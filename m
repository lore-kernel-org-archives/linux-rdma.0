From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 8/9] ib_uverbs: Support for kernel implementation of XRC
Date: Thu, 1 Sep 2016 20:16:40 -0600
Message-ID: <20160902021640.GD30057@obsidianresearch.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
 <1472774969-18997-9-git-send-email-knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472774969-18997-9-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 02, 2016 at 02:09:28AM +0200, Knut Omang wrote:

> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -725,6 +725,8 @@ struct ib_uverbs_send_wr {
>  			__u32 reserved;
>  		} ud;
>  	} wr;
> +	__u32 xrc_remote_srq_num;
> +	__u32 reserved;
>  };

Hum, how does compat work here? Isn't send_wr usually an array?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
