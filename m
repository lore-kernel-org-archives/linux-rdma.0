From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Tue, 31 Mar 2015 12:13:58 +0300
Message-ID: <551A6556.9030708@dev.mellanox.co.il>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com> <CAJ3xEMj0T8QXBQdVHmfEFMXwjAFVD-O6ywAwyyVY+M3oRLzAVA@mail.gmail.com> <20150330.233602.155832546277570456.davem@davemloft.net> <CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/31/2015 6:47 AM, Roland Dreier wrote:
>> Roland, I have to genuinely agree with Or, that your handling of
>> patch integration is sub-par and really painful for anyone actually
>> trying to get real work done here.
>>
>> If you simply don't have the time to devote to constantly reviewing
>> patches as they come in, and doing so in a timely manner, please let
>> someone who is actually interested and has the time to take over.
>
> It's a fair criticism, and certainly for at least the last year or so
> I have not had the time to do enough work as a maintainer.  I have
> hope that some of the things that have been keeping me busy are dying
> down and that I'll have more time to spend on handling the RDMA tree,
> but that's just talk until I actually get more done.
>
> I really would like to get more people involved in handling the flow
> of patches but I'm not sure who has not only the interest and the time
> but also the judgement and expertise to take over.  Certainly Or has
> been a long time contributor who has done a lot of great things, but I
> still worry about things like ABI stability and backwards
> compatibility.
>
> But I'm open to ideas.
>

We had a talk about a similar topic at LSFMM15. Linux-scsi subsystem is 
a large scale subsystem and also has the "single maintainer with
limited time for upstream maintenance" bottleneck.

Christoph created the "scsi-queue" tree to feed James in order to
accelerate the work process.

One thought was laying a set of rules that would allow a maintainer
to "just apply patches":
- Obviously applies cleanly and does not produce compilation
errors/warning (patches that don't meet this will be removed)
- At least two Reviewed-by tags (one of them can be Acked-by/Tested-by)

One problem with that is that we need "a christoph" to poke people for
review since not a lot of people giving review.

Another thought was to allow multiple maintainers (my understanding is
the patchwork supports it). If we can find some split to allow different
maintainers to feed Roland this might work.

Thoughts?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
