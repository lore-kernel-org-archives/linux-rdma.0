From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Thu, 10 Sep 2015 18:17:29 +0300
Message-ID: <55F19F09.7000407@mellanox.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
 <55EA2CA7.8000702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EA2CA7.8000702-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/5/2015 2:43 AM, Doug Ledford wrote:
> On 09/03/2015 10:56 AM, Haggai Eran wrote:
>> This series adds userspace support for on-demand paging. The first patch adds
>> support for the new extended query device verb. Patch 2 adds the capability and
>> interface bits related to on-demand paging, and patch 3 adds example code to
>> the rc_pingpong program to use on-demand paging.
>>
>>
>> Eli Cohen (1):
>>    Add support for extended query device capabilities
>>
>> Haggai Eran (1):
>>    Add on-demand paging support
>>
>> Majd Dibbiny (1):
>>    libibverbs/examples: Support odp in rc_pingpong
> Hi Haggai,
>
> Series applied, thanks.

Doug, in order to address your comments on the checksum offload 
submission, we'd like to leverage on these patches, e.g to enhance the 
extended query device - so WHERE is your tree containing these patches 
that you applied?

I don't see it in your kernel.org tree [1] and I didn't find a git hub 
libibverbs clone that belong to you

It's very tired-ing that every now and then we are looking across 
multiple trees to find out where accepted patches are, really - can you 
reduce the suffer here?



Or.

[1] http://git.kernel.org/cgit/libs/infiniband/libibverbs.git/


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
