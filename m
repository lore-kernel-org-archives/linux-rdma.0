From: "Manoj Nambiar" <manoj_n09-kXrGd1YOZaxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Issue with ibv_post_send
Date: Tue, 27 Sep 2011 13:43:02 +0530
Message-ID: <246B29DA9E954AA49E77DE537F6C8CD2@01hw294151>
References: <E3692BCE687F4FC6ABC395098AA5ECF7@01hw294151> <1828884A29C6694DAF28B7E6B8A8237316E67F7D@ORSMSX101.amr.corp.intel.com>
Reply-To: "Manoj Nambiar" <nambiar-EkmVulN54Sk@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E67F7D-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Sean,

I did "struct ibv_send_wr *bad_send_wr;"

I can see that it is being set to the first work request (the one with wr_id 
as zero) by ibv_post_send. The inline data size is indeed 512.

But still - I cannot understand why ibv_post_send is failing.

Regards,
Manoj


-----Original Message----- 
From: Hefty, Sean
Sent: Tuesday, September 27, 2011 11:04 AM
To: Manoj Nambiar ; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: Issue with ibv_post_send

> code snips
> start ------------------------------------------------------------------------
> ----------------------
> int rc;
> struct ibv_send_wr bad_send_wr[3];

This should just be:

struct ibv_send_wr *bad_send_wr;

On a post error, the pointer will be set to the work request that failed.

> (gdb)  p rdmaptr->wr[0].sg_list[0]
> $24 = {addr = 47966518199024, length = 512, lkey = 2684626508}

Check that your inline data size is 512.

> (gdb)  p rdmaptr->wr[1].sg_list[0]
> $25 = {addr = 47966518134536, length = 8, lkey = 2684626508}
> (gdb)  p rdmaptr->wr[2].sg_list[0]
> $26 = {addr = 47966518134512, length = 8, lkey = 2684626508}
> (gdb) p errno

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
