From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rfc] RDMA: unite max_mr_page_list_len for FRWR and FMRs
Date: Mon, 10 Jul 2017 22:13:53 +0300
Message-ID: <7678b984-c765-eeca-1a23-2d2904fc8c99@grimberg.me>
References: <1499691002-5224-1-git-send-email-sagi@grimberg.me>
 <3F7C141B-7CD5-44FB-A16E-E4D3D531CF23@oracle.com>
 <1dbe09f5-9292-8ff0-9193-793032182f61@grimberg.me>
 <630132AB-A94E-4906-8695-7DBAFC5F998C@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <630132AB-A94E-4906-8695-7DBAFC5F998C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> I thought the FMR page list limit was always 64. I seem to
>>> vaguely recall testing this way back when I split out the
>>> xprtrdma code for handling different registration modes,
>>> and above 64, FMR fell over (at least with CX2 and CX3).
>>
>> Not sure about CX2, but iser runs fmrs with 128 entries perfectly fine
>> on CX3. IIRC CX2 does not support FRWRs,
> 
> CX2 does indeed support both FMR and FRWR.

Thanks for the info.

>> CX4 and up does not support FMRs (which I'd love to kill altogether
>> anyways).
> 
> "Killing in-kernel FMR" might be a good topic for the LPC RDMA
> micro-conference.

I won't be able to attend, but I'd love if others can discuss it.
I'd like for that to happen, but I'd also like to support as much
non-deprecated devices as possible. In fact, until the FMR bug report
came along, I had a "remove fmr" patch for iser in the pipe and held
it back as someone out there is using iser over qib.

So as much as I'd like that to happen, so we can just ignore it, I'm
convinced we can do it just yet.

> 1. I concur that it would be good to have some API for advertising
> the limit for FMR. If it's higher than 64 for some devices, that
> will be good for performance.

That is what I'm trying to achieve.

> 2. But I'm not sure it's always the same as the device's FRWR
> maximum page list depth. If it is always or often smaller, then
> that unfairly limits FRWR.

The opposite argument can be made too.

is a separate max_fmr_page_list_len a better way to go?

> 3. I'm not at all objecting, but if FMR is to go away, why make
> this change now?

As I said, I don't know if FMRs are going away, its not on me to
decide. I just tried to help ULPs to not guess the limit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
