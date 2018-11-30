From: Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH v2 0/6] RFC: gup+dma: tracking dma-pinned pages
Date: Thu, 29 Nov 2018 22:14:11 -0500
Message-ID: <79d1ee27-9ea0-3d15-3fc4-97c1bd79c990@talpey.com>
References: <20181110085041.10071-1-jhubbard@nvidia.com>
 <942cb823-9b18-69e7-84aa-557a68f9d7e9@talpey.com>
 <97934904-2754-77e0-5fcb-83f2311362ee@nvidia.com>
 <5159e02f-17f8-df8b-600c-1b09356e46a9@talpey.com>
 <c1ba07d6-ebfa-ddb9-c25e-e5c1bfbecf74@nvidia.com>
 <15e4a0c0-cadd-e549-962f-8d9aa9fc033a@talpey.com>
 <313bf82d-cdeb-8c75-3772-7a124ecdfbd5@nvidia.com>
 <2aa422df-d5df-5ddb-a2e4-c5e5283653b5@talpey.com>
 <7a68b7fc-ff9d-381e-2444-909c9c2f6679@nvidia.com>
 <1939f47a-eaec-3f2c-4ae7-f92d9fba7693@talpey.com>
 <0f093af1-dee9-51b6-0795-2c073a951fed@nvidia.com>
 <c64387d6-c51d-185a-d2a4-1fedcdac0abe@talpey.com>
 <04c18816-e15d-bffd-e8be-eceefae77197@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <04c18816-e15d-bffd-e8be-eceefae77197@nvidia.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>, john.hubbard@gmail.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 11/29/2018 10:00 PM, John Hubbard wrote:
> On 11/29/18 6:30 PM, Tom Talpey wrote:
>> On 11/29/2018 9:21 PM, John Hubbard wrote:
>>> On 11/29/18 6:18 PM, Tom Talpey wrote:
>>>> On 11/29/2018 8:39 PM, John Hubbard wrote:
>>>>> On 11/28/18 5:59 AM, Tom Talpey wrote:
>>>>>> On 11/27/2018 9:52 PM, John Hubbard wrote:
>>>>>>> On 11/27/18 5:21 PM, Tom Talpey wrote:
>>>>>>>> On 11/21/2018 5:06 PM, John Hubbard wrote:
>>>>>>>>> On 11/21/18 8:49 AM, Tom Talpey wrote:
>>>>>>>>>> On 11/21/2018 1:09 AM, John Hubbard wrote:
>>>>>>>>>>> On 11/19/18 10:57 AM, Tom Talpey wrote:
>>>>>>> [...]
>>>> Excerpting from below:
>>>>
>>>>> Baseline 4.20.0-rc3 (commit f2ce1065e767), as before:
>>>>>        read: IOPS=193k, BW=753MiB/s (790MB/s)(1024MiB/1360msec)
>>>>>       cpu          : usr=16.26%, sys=48.05%, ctx=251258, majf=0, minf=73
>>>>
>>>> vs
>>>>
>>>>> With patches applied:
>>>>>        read: IOPS=193k, BW=753MiB/s (790MB/s)(1024MiB/1360msec)
>>>>>       cpu          : usr=16.26%, sys=48.05%, ctx=251258, majf=0, minf=73
>>>>
>>>> Perfect results, not CPU limited, and full IOPS.
>>>>
>>>> Curiously identical, so I trust you've checked that you measured
>>>> both targets, but if so, I say it's good.
>>>>
>>>
>>> Argh, copy-paste error in the email. The real "before" is ever so slightly
>>> better, at 194K IOPS and 759 MB/s:
>>
>> Definitely better - note the system CPU is lower, which is probably the
>> reason for the increased IOPS.
>>
>>>      cpu          : usr=18.24%, sys=44.77%, ctx=251527, majf=0, minf=73
>>
>> Good result - a correct implementation, and faster.
>>
> 
> Thanks, Tom, I really appreciate your experience and help on what performance
> should look like here. (I'm sure you can guess that this is the first time
> I've worked with fio, heh.)

No problem, happy to chip in. Feel free to add my

Tested-By: Tom Talpey <ttalpey@microsoft.com>

I know, that's not the personal email I'm posting from, but it's me.

I'll be hopefully trying the code with the Linux SMB client (cifs.ko)
next week, Long Li is implementing direct io in that and we'll see how
it helps.

Mainly, I'm looking forward to seeing this enable RDMA-to-DAX.

Tom.

> 
> I'll send out a new, non-RFC patchset soon, then.
> 
> thanks,
> 
