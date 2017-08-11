From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 0/8] Add OPA extended LID support
Date: Fri, 11 Aug 2017 08:48:09 -0700
Message-ID: <7127900c-a999-bf6f-8c7e-7b96985dd57e@intel.com>
References: <1502388268-20687-1-git-send-email-don.hiatt@intel.com>
 <1502465986.3080.40.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502465986.3080.40.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 8/11/2017 8:39 AM, Doug Ledford wrote:
> On Thu, 2017-08-10 at 14:04 -0400, Don Hiatt wrote:
>> This patch series primarily increases sizes of variables that hold
>> lid values from 16 to 32 bits. Additionally, it adds a check in
>> the IB mad stack to verify a properly formatted MAD when OPA
>> extended LIDs are used.
>>
>> Changes from v3:
>> ---------------
>> * Add 'IB/core: Add functions to convert 32 bit lids to 16 bits' and
>>    use them in place of casts.
> Hi Don,
>
> I've already taken v3 (was going to email it out today, but I pulled it
> into a branch 2 days ago and it passed 0day overnight, I was just
> waiting to merge three different branches together and then send out
> the notifications for them all once done, and v3 of this was one of the
> three).  Please prepare an incremental patch to get me up to v4 and
> submit that to the list.  Thanks.
>
Hi Doug,

Leon had a minor suggestion to put a comment on the helper functions so I'll
make a v5 and submit an incremental patch of v2-->v5.

Thanks.

don

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
