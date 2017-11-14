From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 2/5] verbs: Introduce parent domain and its
 related verbs
Date: Tue, 14 Nov 2017 10:34:25 +0200
Message-ID: <4c8448c2-373a-bbc1-73be-f792599b8b0a@dev.mellanox.co.il>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-3-git-send-email-yishaih@mellanox.com>
 <20171113195331.GC22610@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113195331.GC22610-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/13/2017 9:53 PM, Jason Gunthorpe wrote:
> On Sun, Nov 12, 2017 at 11:41:40PM +0200, Yishai Hadas wrote:
> 
>> +.BI "struct ibv_pd *ibv_alloc_parent_domain(struct ibv_context "*context" ", struct ibv_domain_init_attr " "*attr");
>> +.sp
>> +.BI "int ibv_dealloc_parent_domain(struct ibv_pd " "*pd");
> 
> I don't think we should have a dealloc for this, since it is ibv_pd it
> should go through the normal ibv_dealloc_pd. Having two deletors for
> the same type is too hard to use.
> 

I'm fine with that, just to be clear here, the application will still 
need to call twice for ibv_dealloc_pd() once to free the parent domain 
collection and later to free the protection name, this will make it 
fully symmetric from allocation/free point of view.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
