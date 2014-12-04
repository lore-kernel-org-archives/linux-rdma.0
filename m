From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: IB_CQ_VECTOR_LEAST_ATTACHED
Date: Thu, 04 Dec 2014 08:47:44 -0800
Message-ID: <54809030.6090107@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Or, Eli,

What's the history of this patch?
	http://lists.openfabrics.org/pipermail/general/2008-May/050813.html

I am working on multiple QPs workload. And I created a similar approach with IB_CQ_VECTOR_LEAST_ATTACHED, which can bring up about 17% small I/O performance. I think this CQ_VECTOR loading balance should be maintained in provider not the caller. I didn't see this patch was submitted to mainline kernel, wonder any reason behind?

Thanks
Shirley 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
