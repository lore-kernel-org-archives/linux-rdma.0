From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix incorrect wc pkey_index assignment for GSI
 messages
Date: Tue, 1 Sep 2015 11:08:17 +0300
Message-ID: <55E55CF1.4010803@dev.mellanox.co.il>
References: <1441034670-27778-1-git-send-email-sagig@mellanox.com>
 <CAJ3xEMgfibE3VsyvLmuaFnzbo8HgwZ+qtrt0G24Dy54RLjPGWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgfibE3VsyvLmuaFnzbo8HgwZ+qtrt0G24Dy54RLjPGWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/31/2015 11:18 PM, Or Gerlitz wrote:
> On Mon, Aug 31, 2015 at 6:24 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Since patch series "Demux IB CM requests in the rdma_cm module" the
>> P_Key index is taken from the work completion rather than the message itself
>
> so prior to this series nobody in the IB core (and maybe across the
> whole upstream kernel) uses ib_wc->pkey_index?!

I guess so...

>
>>   (see http://www.spinics.net/lists/netdev/msg335599.html).
>
> better to have pointer here to upstream commit and not to an archive
> URL which is possibly gonna die some day

This commit is not upstream yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
