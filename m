From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: nfs-rdma performance
Date: Fri, 13 Jun 2014 00:25:40 -0700
Message-ID: <539AA774.2020209@oracle.com>
References: <CADvaNzXHOafuzav9RwB2SHXma7EUCxMQX6sNEL6r5-a_e37pLQ@mail.gmail.com>	<539A06C3.1030909@opengridcomputing.com> <CADvaNzUbqwvXFiDPNr4f-DC8s7kf7t=N0UXkwUXrKDPn6WgMAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADvaNzUbqwvXFiDPNr4f-DC8s7kf7t=N0UXkwUXrKDPn6WgMAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 06/12/2014 04:06 PM, Mark Lehrer wrote:
> I am using ConnectX-3 HCA's and Dell R720 servers.
> 
> On Thu, Jun 12, 2014 at 2:00 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>> On 6/12/2014 2:54 PM, Mark Lehrer wrote:
>>>
>>> Awesome work on nfs-rdma in the later kernels!  I had been having
>>> panic problems for awhile and now things appear to be quite reliable.
>>>
>>> Now that things are more reliable, I would like to help work on speed
>>> issues.  On this same hardware with SMB Direct and the standard
>>> storage review 8k 70/30 test, I get combined read & write performance
>>> of around 2.5GB/sec.  With nfs-rdma it is pushing about 850MB/sec.
>>> This is simply an unacceptable difference.

I was able to get close to 2.5GB/s with ConnectX-2 for direct I/O. What's your test case and wsize/rsize? Did you collect /proc/interrupts, cpu usage and profiling data?

>>>
>>> I'm using the standard settings -- connected mode, 65520 byte MTU,
>>> nfs-server-side "async", lots of nfsd's, and nfsver=3 with large
>>> buffers.  Does anyone have any tuning suggestions and/or places to
>>> start looking for bottlenecks?
>>
>>
>> What RDMA device?
>>
>> Steve.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
