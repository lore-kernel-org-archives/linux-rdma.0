From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 00/19, v5] Make ib_srp better suited for H.A. purposes
Date: Tue, 13 Nov 2012 22:30:41 +0100
Message-ID: <50A2BC01.40609@acm.org>
References: <508A85BB.1000505@acm.org> <CAJZOPZJPQkJ-kkW3ro9sRJXQJg_Yz_tjoJ1Rwb=XEePO3j_iJw@mail.gmail.com> <50A207D5.6060207@acm.org> <CAJZOPZJXdLRH9NPCt0snGNP8LKODO+phtV7uts6Vj-gxEEjpsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJXdLRH9NPCt0snGNP8LKODO+phtV7uts6Vj-gxEEjpsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/13/12 22:04, Or Gerlitz wrote:
> Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> On 11/12/12 23:36, Or Gerlitz wrote:
>
>> This patch series reduces path failover time significantly. Instead of
>> having to wait until the SCSI error handler has finished recovery,
>
> When a SCSI device is selected by mpath and used as a path, aren't failed
> commands returned back to the mpath driver for possibly re-submission over
> a different path?

The advantage of having a configurable fast_io_fail_tmo parameter is 
that this parameter can be configured to a smaller value than the SCSI 
timeout and hence that failover mechanisms in higher layers (dm and 
multipathd) are triggered more quickly if an I/O error is encountered.

>> multipathd switches paths as soon as fast_fail_tmo has elapsed. Also, SCSI
>> hosts that correspond to failed paths are removed. With the upstream SRP
>> initiator and when triggering path failover repeatedly after some time
>> hundreds of obsolete SCSI hosts are present.
>>
>>>> - Dropped the patches for integration with multipathd.
>>>
>>> can you explain this please? are  these non SRP patches which we
>>> submitted/accepted
>>> through another maintainer? can you point on the upstream commits?
>>
>>
>> With that comment I was referring to the dev_loss_tmo and fast_io_fail_tmo
>> sysfs variables that had been dropped in v2 of this patch set but that have
>> been reintroduced in v3 of this patch set. If these parameters have been set
>> in /etc/multipath.conf then multipathd passes these on to the block driver
>> (ib_srp in this case), at least the block driver provides the dev_loss_tmo
>> and fast_io_fail_tmo sysfs attributes.
>
> So these are attributes you added to the block layer, or to SRP? I'm
> not clear on that.

These attributes have been added to the SRP transport layer. Since the 
ib_srp driver registers itself with the SRP transport layer the SRP 
transport layer creates these two attributes for the ib_srp driver. This 
is similar to how the FC transport layer creates these attributes for FC 
initiator drivers.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
