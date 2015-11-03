From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/7] IB/srp: Fix a potential queue overflow in an error
 path
Date: Tue, 3 Nov 2015 21:56:49 +0200
Message-ID: <56391181.8040207@dev.mellanox.co.il>
References: <562FF404.7000504@sandisk.com> <562FF484.6030400@sandisk.com>
 <5638F08D.9070206@dev.mellanox.co.il> <56390557.204@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56390557.204-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 03/11/2015 21:04, Bart Van Assche wrote:
> On 11/03/2015 09:36 AM, Sagi Grimberg wrote:
>> On 28/10/2015 00:02, Bart Van Assche wrote:
>>> Wait until memory registration has finished in the srp_queuecommand()
>>> error path before invalidating memory regions to avoid a send queue
>>> overflow.
>>
>> This looks backwards to me... Why do we even post anything on our
>> queue-pair to begin with if we got an unsupported sg list?
>>
>> Can't we perform a simple sanity check on the sg list instead?
>
> Hello Sagi,
>
> There is one memory descriptor pool per RDMA channel and RDMA channels
> are typically used by more than one CPU. This means that memory
> registration for more than one command can happen concurrently from a
> single memory descriptor pool.
> This is why checking how many memory
> descriptors are left before memory registration occurs wouldn't be
> sufficient.

How harm would it do to make the entire SG list mapping channel-wide
atomic? I'm asking because it's really a non-trivial flow you're
introducing.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
