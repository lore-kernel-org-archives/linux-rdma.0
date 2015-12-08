From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Tue, 8 Dec 2015 23:00:28 +0200
Message-ID: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 8, 2015 at 8:17 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 12/08/2015 01:13 PM, Sagi Grimberg wrote:


>
> > I mentioned this in v1. This patch set is applied over Christoph's
> > device attributes patch. Will it go in as well?
>
> No, that's too big and not the right sort of fix for 4.4-rc.  I had it
> on my radar for getting into for-next.



Doug, re the device attribute patch, I have expressed my opinion that
--- we should be going in a slightly different direction of stashing a
struct ib_device_attr as a direct or pointer field of struct ib_device
and have the device or the core to fill it up just before the device
instance creation with the core is to be complete. This way we can
remove all the annoying calls from ULPs to query device and avoid
adding so many fields to the device structure itself.

So there are two suggestions on the table here and we need to hear the
maintainer thinking. I do expect that your response will not be "I
applied X" but rather you'll allow the time to try and convince you on
whatever direction, this is pending for long time and we're on
4.4-rc4, there should be no rush to cut this over night and push to
k.o the code for this small cleanup.

I didn't submit a patch that follows my suggestion, but Ira did so in
one of the OPA submission rounds, if you're OK with that proposal or
if you even just want to see the patch to cast your vote/decision, I
will rebase it and complete.

Makes sense?

Or.

>
> So, it'll have to be fixed up to apply over the top of your patches which will already be applied.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
