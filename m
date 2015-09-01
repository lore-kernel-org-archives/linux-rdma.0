From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix incorrect wc pkey_index assignment for GSI
 messages
Date: Tue, 1 Sep 2015 11:36:40 +0300
Message-ID: <55E56398.3020003@mellanox.com>
References: <1441034670-27778-1-git-send-email-sagig@mellanox.com>
 <CAJ3xEMgfibE3VsyvLmuaFnzbo8HgwZ+qtrt0G24Dy54RLjPGWA@mail.gmail.com>
 <55E55CF1.4010803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E55CF1.4010803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/1/2015 11:08 AM, Sagi Grimberg wrote:
>
>>
>>>   (see http://www.spinics.net/lists/netdev/msg335599.html).
>>
>> better to have pointer here to upstream commit and not to an archive
>> URL which is possibly gonna die some day
>
> This commit is not upstream yet. 

I know, but but under the way the net/net-next and now also Doug's tree 
are set,
the ID remains the same also when Linus picks the offending patch, so 
you can give their
ID now, just make sure you take it from the correct branch -- see Doug's 
responses to
my email on the list in the last 1-2 days

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
