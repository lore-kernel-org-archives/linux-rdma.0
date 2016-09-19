From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 2/8] IB/cxgb3: Move user vendor structures
Date: Mon, 19 Sep 2016 10:30:08 -0500
Message-ID: <02bc01d2128a$b4066330$1c132990$@opengridcomputing.com>
References: <1474195823-10429-1-git-send-email-leon@kernel.org> <1474195823-10429-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474195823-10429-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> This patch moves cxgb3 vendor's specific structures to
> common UAPI folder which will be visible to all consumers.
> 
> These structures are used by user-space library driver
> (libcxgb3) and currently manually copied to that library.
> 
> This move will allow cross-compile against these files and
> simplify introduction of vendor specific data.
> 
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Looks good.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
