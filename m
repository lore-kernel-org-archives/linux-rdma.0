From: Tal Gilboa <talgi@mellanox.com>
Subject: Re: [PATCH rfc 0/5] generic adaptive IRQ moderation library for I/O
 devices
Date: Tue, 13 Feb 2018 23:46:26 +0200
Message-ID: <a85ece04-c1f7-0212-7b4a-19ed89ea3c55@mellanox.com>
References: <20180205220316.30236-1-sagi@grimberg.me>
 <CAJ3xEMi0KzOMJt7d01ohHW-ZpmdwvfzZCLN0qA-LLFwROeVseQ@mail.gmail.com>
 <4c8a45cb-bd4b-8dce-b8d2-2d26c471ef7b@mellanox.com>
 <73df42b8-106d-0c06-45e2-49285ed01ab5@grimberg.me>
 <a47a8012-c021-74c4-9161-eaff7374a0b2@mellanox.com>
 <CAJ3xEMhmR_sRVyKcCZ7+GsNChBKRTNss+MAEtPTo1qnXisZDJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMhmR_sRVyKcCZ7+GsNChBKRTNss+MAEtPTo1qnXisZDJw@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: linux-block@vger.kernel.org, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Idan Burstein <idanb@mellanox.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-rdma@vger.kernel.org

On 2/13/2018 11:30 AM, Or Gerlitz wrote:
> On Tue, Feb 6, 2018 at 11:45 AM, Tal Gilboa <talgi@mellanox.com> wrote:
>> On 2/6/2018 11:34 AM, Sagi Grimberg wrote:
>>>
>>> Hi Tal,
>>>
>>>>> I think Tal has idea/s on how the existing library can be changed to
>>>>> support more modes/models
>>>>>
>>>> What I was thinking is allowing DIM algorithm to disregard data which is
>>>> 0. Currently if bytes == 0 we return "SAME" immediately. We can change it to
>>>> simply move to the packets check (which may be renamed to "completions").
>>>> This way you could use DIM while only optimizing to (P1) high packet rate
>>>> and (P2) low interrupt rate.
>>>
>>>
>>> That was exactly where I started from. But unfortunately it did not work
>>> well :(
>>>
>>>   From my experiments, the moderation was all over the place failing to
>>> converge. At least the workloads that I've tested with, it was more
>>> successful to have a stricter step policy and pulling towards latency
>>> if we are consistently catching single completion per event.
>>>
>>> I'm not an expert here at all, but at this point, based on my attempts
>>> so far, I'm not convinced the current net_dim scheme could work.
>>
>> I do believe we can make it work. I see your addition of the cpe part to
>> stats compare. Might not be a bad idea for networking devices. Overall, it
>> seems to me like this would be a private case of the general DIM
>> optimization, since it doesn't need to account for aggregation, for
>> instance, which breaks the "more packets == more data" ratio.
> 
> Did U2 came to agreement/lead on how to re-use the upstream library
> for the matter Sagi is pushing for?
> 
I don't think so (yet).
Sagi, I would like to avoid having 2 "net DIM"s if possible. You 
mentioned you tried implementing over net DIM lib and it wasn't working 
well. Can you share this code with me?
