From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1 10/10] IB/iser: Support the remote invalidation
 exception
Date: Tue, 1 Dec 2015 12:43:41 +0200
Message-ID: <565D79DD.7060600@dev.mellanox.co.il>
References: <CAJ3xEMjqhCMZz=dX91vzzi20F8P1Tjh=WA2MKwBQ5G7OR8mn5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMjqhCMZz=dX91vzzi20F8P1Tjh=WA2MKwBQ5G7OR8mn5Q@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org



On 30/11/2015 23:36, Or Gerlitz wrote:
> On Tue, Nov 24, 2015 at 6:23 PM, Sagi Grimberg <sagig@mellanox.com> wrote:
>>
>> From: Jenny Derzhavetz <jennyf@mellanox.com>
>>
>> Declare that we support remote invalidation in case we are:
>> 1. using Fastreg method
>> 2. always registering memory.
>
> decide if you want or don't want to use periods @ the end of these
> cases, but be consistent... I vote not to use periods

I'll fix.

>
>>
>> Detect the invalidated rkey from the work completion info so we
>> won't invalidate it locally. The spec madates that we must not rely
>> on the taget remote invalidate our rkey so we must check it upon
>> a receive (scsi response) completion.
>>
>
> s/madates/mandates/ and run spell check over the change-logs of the
> whole series please before posting v2

OK.

Thanks Or
