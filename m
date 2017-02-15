From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 18:27:28 +0200
Message-ID: <49d89d44-0bcc-1830-1f47-6624f858a7a6@grimberg.me>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-2-bart.vanassche@sandisk.com>
 <cebcaeae-94a6-de82-cfc8-ce055b273836@grimberg.me>
 <0514bb01-95cf-c10a-b883-494f149845f3@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <0514bb01-95cf-c10a-b883-494f149845f3@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, "# 4 . 7+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


>> Hi Guys,
>>
>> Sorry for addressing this late, but has this failure been investigated?
>>
>> Max, Israel, what does this error syndrome map to?
>
> Sagi,
> this syndrome says that number of klms to write is bigger than number of
> mtts.

That is strange, given that we check for it explicitly...

if this is indeed the case, then mlx5 reports wrong
max_fast_reg_page_list_len.

> Artemy started investigating it and proposed solution that were tested
> by Laurence.
> Let's see if your fix will help.

Not sure it will help if the syndrome is what you say it is...
