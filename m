From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: Enable SG clustering
Date: Sun, 11 Oct 2015 11:37:59 +0300
Message-ID: <561A1FE7.8000405@dev.mellanox.co.il>
References: <1444436822-6632-1-git-send-email-sagig@mellanox.com>
 <1444436822-6632-3-git-send-email-sagig@mellanox.com>
 <CAJ3xEMg3xuNvpetNzmKo2b2QcybjD2v-9ht6Mddw5N+tDeNVxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMg3xuNvpetNzmKo2b2QcybjD2v-9ht6Mddw5N+tDeNVxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> but with arbitrary SG list support it will benefit greatly.
>
> Y? please put some wording here to clarify.

Well, because when a device will accept true SG lists then
it would benefit the HCA caching/fetching to have less SG elements.

I'll add a sentence to the change log.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
