From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problems using krping
Date: Tue, 26 Jan 2010 09:02:37 -0600
Message-ID: <4B5F040D.8080204@opengridcomputing.com>
References: <201001211807011710722@inspur.com>, <201001221533186875550@inspur.com>, <201001242242553436345@inspur.com>, <201001251036131874884@inspur.com> <201001262046537030587@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201001262046537030587-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lihaidong wrote:
> Mr.Wise


You need to start calling me Steve.  You're making me feel older than I 
am. ;-)


> When  krping setup buffers  failed, ib_free_fast_reg_page_list is used;
> When krping free buffers, ib_free_fast_reg_page_list is not used.
> Though krping still works well, could you an comment on that?



Sounds like a bug.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
