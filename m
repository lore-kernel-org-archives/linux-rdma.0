From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/core: allocate wc array statically
Date: Mon, 15 Jan 2018 13:00:50 +0200
Message-ID: <5b245fae-5696-3fa6-2b51-be263d8b9684@mellanox.com>
References: <1515942470-11461-1-git-send-email-maxg@mellanox.com>
 <1515942470-11461-2-git-send-email-maxg@mellanox.com>
 <70221289-a8a7-91cf-7975-cf0ad60c9018@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <70221289-a8a7-91cf-7975-cf0ad60c9018-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 1/14/2018 6:22 PM, Sagi Grimberg wrote:
> 
>> The poll batch is small and known at pre-proccessing time.
>> No need to allocate it dynamically.
> 
> Any specific reason why all CQ allocators (including userspace)
> should allocate this array (as small as it is...)

For kernel allocators, I think we're ok with this approach since we 
allocate it dynamically anyway.
I guess you're right regarding the user space, so we can ignore this 
patch and push the other 2 or we can live with this allocation and save 
few lines of code for dynamic alloc/free of wcs.

I'm good with both approaches.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
