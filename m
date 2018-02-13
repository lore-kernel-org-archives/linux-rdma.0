From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rfc 0/5] generic adaptive IRQ moderation library for I/O devices
Date: Tue, 13 Feb 2018 11:30:05 +0200
Message-ID: <CAJ3xEMhmR_sRVyKcCZ7+GsNChBKRTNss+MAEtPTo1qnXisZDJw@mail.gmail.com>
References: <20180205220316.30236-1-sagi@grimberg.me> <CAJ3xEMi0KzOMJt7d01ohHW-ZpmdwvfzZCLN0qA-LLFwROeVseQ@mail.gmail.com>
 <4c8a45cb-bd4b-8dce-b8d2-2d26c471ef7b@mellanox.com> <73df42b8-106d-0c06-45e2-49285ed01ab5@grimberg.me>
 <a47a8012-c021-74c4-9161-eaff7374a0b2@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a47a8012-c021-74c4-9161-eaff7374a0b2-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tal Gilboa <talgi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 6, 2018 at 11:45 AM, Tal Gilboa <talgi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 2/6/2018 11:34 AM, Sagi Grimberg wrote:
>>
>> Hi Tal,
>>
>>>> I think Tal has idea/s on how the existing library can be changed to
>>>> support more modes/models
>>>>
>>> What I was thinking is allowing DIM algorithm to disregard data which is
>>> 0. Currently if bytes == 0 we return "SAME" immediately. We can change it to
>>> simply move to the packets check (which may be renamed to "completions").
>>> This way you could use DIM while only optimizing to (P1) high packet rate
>>> and (P2) low interrupt rate.
>>
>>
>> That was exactly where I started from. But unfortunately it did not work
>> well :(
>>
>>  From my experiments, the moderation was all over the place failing to
>> converge. At least the workloads that I've tested with, it was more
>> successful to have a stricter step policy and pulling towards latency
>> if we are consistently catching single completion per event.
>>
>> I'm not an expert here at all, but at this point, based on my attempts
>> so far, I'm not convinced the current net_dim scheme could work.
>
> I do believe we can make it work. I see your addition of the cpe part to
> stats compare. Might not be a bad idea for networking devices. Overall, it
> seems to me like this would be a private case of the general DIM
> optimization, since it doesn't need to account for aggregation, for
> instance, which breaks the "more packets == more data" ratio.

Did U2 came to agreement/lead on how to re-use the upstream library
for the matter Sagi is pushing for?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
