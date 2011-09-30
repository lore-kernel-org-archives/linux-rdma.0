From: "Manoj Nambiar" <manoj_n09-kXrGd1YOZaxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Issue with ibv_post_send
Date: Fri, 30 Sep 2011 23:28:26 +0530
Message-ID: <B9438EA8FC8240F998ACDF244CF79A8E@01hw294151>
References: <C91B74CE6ED1470EB8BC7B9E3B06A4E0@01hw294151> <1828884A29C6694DAF28B7E6B8A8237316E686A3@ORSMSX101.amr.corp.intel.com>
Reply-To: "Manoj Nambiar" <nambiar-EkmVulN54Sk@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E686A3-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks again Sean,

That really helped. ibv_post_send is now working. (I was using 
rdma_create_qp)

Regards,
Manoj Nambiar

-----Original Message----- 
From: Hefty, Sean
Sent: Thursday, September 29, 2011 10:22 PM
To: Manoj Nambiar ; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: Issue with ibv_post_send

> * When I reduce the sge length of the first work request to 20 
> ibv_post_send
> works
> * When I remove IBV_SEND_INLINE from the send_flags, ibv_post_send works.
>
> Either case I am unable to achieve the desired functionality.
>
> Is there a maximum sge size limit in the case of IBV_SEND_INLINE. How do I
> control it?

The desired inline data size of the QP is provided as input to 
ibv_create_qp.  The actual supported size will be returned by that call. 
You need to verify that your inline send size is less than that value.

- Sean 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
