From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 18/19] ib_srp: Remove SCSI devices upon port down event
Date: Tue, 13 Nov 2012 09:59:47 +0100
Message-ID: <50A20C03.9040607@acm.org>
References: <508A85BB.1000505@acm.org> <508A88D8.2050905@acm.org> <CAJZOPZL8mKU2MsrPPACvWjiA59aGnWDj0HNTQQNhbDrMsE0+Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZL8mKU2MsrPPACvWjiA59aGnWDj0HNTQQNhbDrMsE0+Tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/12/12 23:40, Or Gerlitz wrote:
> Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> This patch is a modified version of a patch from Karandeep Chahal
>> that was posted on May 29, 2012 on the linux-rdma mailing list
>> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11796.html)
> 
> If you want your patch to land upstream, I would expect here a
> change-log that explains why we want to do that... e.g what happens if
> someone mounts a file system on this block device, do we want to pull
> the rug behind the FS legs, why? what's special in port down even from
> any other loss of IB connectivity that we have to give it special
> treatment? why its needed to react on IB events and not just on
> connectivity loss?

This patch is not an essential part of this patch series. All it does
is to trigger failover more quickly if a port down event has been
received. Without this patch, if an IB cable has been disconnected long
enough, a QP error will be generated anyway and that event will trigger
the path failure logic introduced in the earlier patches of this series.

Regarding file system behavior: if a file system should be shielded
from path failures in a multipath setup then it should be mounted on
top of a multipath device instead of using the SCSI host directly
created by ib_srp. In the file system tests I ran I have been using
the following multipathd options:

defaults {
    queue_without_daemon no
}
devices {
    device {
        ...
        features          "3 queue_if_no_path pg_init_retries 50"
        fast_io_fail_tmo  15
        dev_loss_tmo      60
    }
}

Are you perhaps worrying about what will happen in a setup with a single
path between initiator and target and where the IB connection disappears
and reappears quickly ? Shouldn't multipath be used even in such a setup
to avoid that the filesystem encounters an I/O error if the path disappears
for a longer time than what is tolerated by the SCSI error handler in order
to recover gracefully ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
