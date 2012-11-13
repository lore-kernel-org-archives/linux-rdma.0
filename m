From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/19, v5] Make ib_srp better suited for H.A. purposes
Date: Tue, 13 Nov 2012 23:04:35 +0200
Message-ID: <CAJZOPZJXdLRH9NPCt0snGNP8LKODO+phtV7uts6Vj-gxEEjpsw@mail.gmail.com>
References: <508A85BB.1000505@acm.org>
	<CAJZOPZJPQkJ-kkW3ro9sRJXQJg_Yz_tjoJ1Rwb=XEePO3j_iJw@mail.gmail.com>
	<50A207D5.6060207@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A207D5.6060207-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 11/12/12 23:36, Or Gerlitz wrote:

> This patch series reduces path failover time significantly. Instead of
> having to wait until the SCSI error handler has finished recovery,

When a SCSI device is selected by mpath and used as a path, aren't failed
commands returned back to the mpath driver for possibly re-submission over
a different path?


> multipathd switches paths as soon as fast_fail_tmo has elapsed. Also, SCSI
> hosts that correspond to failed paths are removed. With the upstream SRP
> initiator and when triggering path failover repeatedly after some time
> hundreds of obsolete SCSI hosts are present.


>>> - Dropped the patches for integration with multipathd.

>> can you explain this please? are  these non SRP patches which we
>> submitted/accepted
>> through another maintainer? can you point on the upstream commits?

>
> With that comment I was referring to the dev_loss_tmo and fast_io_fail_tmo
> sysfs variables that had been dropped in v2 of this patch set but that have
> been reintroduced in v3 of this patch set. If these parameters have been set
> in /etc/multipath.conf then multipathd passes these on to the block driver
> (ib_srp in this case), at least the block driver provides the dev_loss_tmo
> and fast_io_fail_tmo sysfs attributes.

So these are attributes you added to the block layer, or to SRP? I'm
not clear on that

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
