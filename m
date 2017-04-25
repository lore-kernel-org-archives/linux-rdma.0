From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband/uverbs: Fix integer overflows
Date: Tue, 25 Apr 2017 15:18:42 -0400
Message-ID: <1493147922.3041.88.camel@redhat.com>
References: <1490385317-35641-1-git-send-email-vlad@tsyrklevich.net>
         <1490385702.3312.18.camel@sandisk.com>
         <CAH0z3hM8a4Hra3+gvz5HeFBcmkqmP0KhFQsFQh30SActK+p7mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH0z3hM8a4Hra3+gvz5HeFBcmkqmP0KhFQsFQh30SActK+p7mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-03-24 at 16:45 -0400, Vlad Tsyrklevich wrote:
> [replying again to the list with HTML e-mails turned off]
> 
> I doubt it. I chose to implement a naive integer overflow check here
> instead of checking against some device-specific value since I'm
> unfamiliar with the infiniband internals and don't have appropriate
> hardware to test such a change against.

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
