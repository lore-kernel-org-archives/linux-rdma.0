From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: sync congestion map updating
Date: Wed, 30 Mar 2016 10:16:06 -0700
Message-ID: <56FC09D6.7090602@oracle.com>
References: <1459328902-31968-1-git-send-email-wen.gang.wang@oracle.com>
 <20160330161952.GA2670@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160330161952.GA2670-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-2ukJVAZIZ/Y@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Wengang,

On 3/30/2016 9:19 AM, Leon Romanovsky wrote:
> On Wed, Mar 30, 2016 at 05:08:22PM +0800, Wengang Wang wrote:
>> Problem is found that some among a lot of parallel RDS communications hang.
>> In my test ten or so among 33 communications hang. The send requests got
>> -ENOBUF error meaning the peer socket (port) is congested. But meanwhile,
>> peer socket (port) is not congested.
>>
>> The congestion map updating can happen in two paths: one is in rds_recvmsg path
>> and the other is when it receives packets from the hardware. There is no
>> synchronization when updating the congestion map. So a bit operation (clearing)
>> in the rds_recvmsg path can be skipped by another bit operation (setting) in
>> hardware packet receving path.
>>
>> Fix is to add a spin lock per congestion map to sync the update on it.
>> No performance drop found during the test for the fix.
>
> I assume that this change fixed your issue, however it looks suspicious
> that performance wasn't change.
>
First of all thanks for finding the issue and posting patch
for it. I do agree with Leon on performance comment.
We shouldn't need locks for map updates.

Moreover the parallel receive path on which this patch
is based of doesn't exist in upstream code. I have kept
that out so far because of similar issue like one you
encountered.

Anyways lets discuss offline about the fix even for the
downstream kernel. I suspect we can address it without locks.

Reagrds,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
