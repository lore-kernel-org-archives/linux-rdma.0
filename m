From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Wed, 28 Nov 2012 00:13:20 +0200
Message-ID: <CAJZOPZJ6tNimvQGKa6E0ttowM8WWxCMR7s9BMWebVOEYtQ+TCQ@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov>
	<50B4EBA3.7070400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50B4EBA3.7070400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 27, 2012 at 6:34 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> Thanks Dave for doing all this work. A reworked and retested patch series
> that should address all comments that have been posted so far can be found
> here: http://github.com/bvanassche/linux/srp-ha. I can repost the entire
> patch series if you want. The changes compared to the previous time this
> patch series was posted are:
> * Integrated Ishai's and Vu's patches for recreating the QP and the CQs.
> * Took advantage of SCSI core changes that make scsi_remove_host() wait
>   until device removal and error handling finished (will post these shortly).

Bart, do you mean that the series @ your tree is a superset of the
series posted by Dave? that is you took his eleven patches and added
more? if this is the case, why can't we have Dave's series
(fixed/changed wherever needed) and your series on top of?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
