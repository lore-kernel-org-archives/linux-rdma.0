From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 18/19] ib_srp: Remove SCSI devices upon port down event
Date: Tue, 13 Nov 2012 00:40:04 +0200
Message-ID: <CAJZOPZL8mKU2MsrPPACvWjiA59aGnWDj0HNTQQNhbDrMsE0+Tg@mail.gmail.com>
References: <508A85BB.1000505@acm.org>
	<508A88D8.2050905@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A88D8.2050905-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> This patch is a modified version of a patch from Karandeep Chahal
> that was posted on May 29, 2012 on the linux-rdma mailing list
> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11796.html)

If you want your patch to land upstream, I would expect here a
change-log that explains why we want to do that... e.g what happens if
someone mounts a file system on this block device, do we want to pull
the rug behind the FS legs, why? what's special in port down even from
any other loss of IB connectivity that we have to give it special
treatment? why its needed to react on IB events and not just on
connectivity loss?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
