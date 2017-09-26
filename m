From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-next v2 1/2] iw_cxgb4: Remove __func__ parameter from pr_debug()
Date: Tue, 26 Sep 2017 12:47:41 -0500
Message-ID: <020101d336ef$8ce778e0$a6b66aa0$@opengridcomputing.com>
References: <1506447610-12909-1-git-send-email-bharat@chelsio.com> <1506447610-12909-2-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506447610-12909-2-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> 
> pr_debug() can be enabled to print function names, So removing the
> unwanted __func__ parameters from debug logs.
> Realign function parameters.
> 
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
