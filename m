From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 18/19] ib_srp: Remove SCSI devices upon port down event
Date: Tue, 13 Nov 2012 22:54:02 +0200
Message-ID: <CAJZOPZ+PiDQ6GYLkDO4MaPTDxLr2XDMn8q3gTaX-COx04PSegg@mail.gmail.com>
References: <508A85BB.1000505@acm.org>
	<508A88D8.2050905@acm.org>
	<CAJZOPZL8mKU2MsrPPACvWjiA59aGnWDj0HNTQQNhbDrMsE0+Tg@mail.gmail.com>
	<50A20C03.9040607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A20C03.9040607-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 11/12/12 23:40, Or Gerlitz wrote:
> This patch is not an essential part of this patch series. All it does
> is to trigger failover more quickly if a port down event has been
> received. Without this patch, if an IB cable has been disconnected long
> enough, a QP error will be generated anyway and that event will trigger
> the path failure logic introduced in the earlier patches of this series.

But if you have IB link which went down only to few milli-seconds or
even few hundred msecs, why disconnected the IB RC connection? IB is
layered and the RC transport is layer four, why we want to manually
break it if we have L2 event of port down?

Also, for the use case of multipath, an essentail part of the mpath
driver is to deal with (say) two devices when at some point at least
one of them becomes "failed" from the mpath point of view. So now this
patch comes and delets failed devices, but we've put mpath there so we
can deal with failed devices! also its very confusing for the mpath
users that would expect to be able to observe all the devices which
this mpath is set on and  their state, agree?





> Regarding file system behavior: if a file system should be shielded
> from path failures in a multipath setup then it should be mounted on
> top of a multipath device instead of using the SCSI host directly
> created by ib_srp. In the file system tests I ran I have been using
> the following multipathd options:
>
> defaults {
>     queue_without_daemon no
> }
> devices {
>     device {
>         ...
>         features          "3 queue_if_no_path pg_init_retries 50"
>         fast_io_fail_tmo  15
>         dev_loss_tmo      60
>     }
> }
>
> Are you perhaps worrying about what will happen in a setup with a single
> path between initiator and target and where the IB connection disappears
> and reappears quickly ? Shouldn't multipath be used even in such a setup
> to avoid that the filesystem encounters an I/O error if the path disappears
> for a longer time than what is tolerated by the SCSI error handler in order
> to recover gracefully ?

this gets way too much complicated, and just for patch which you said
"is not an essential part of this patch series" ... can we just drop
it altogether from the series?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
