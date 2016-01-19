From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Back from PTO
Date: Tue, 19 Jan 2016 19:04:16 +0200
Message-ID: <CAG9sBKP8kqax_wqyej+1J+hFaaCUFKdFyAX8e4Hxg3HoafWjrg@mail.gmail.com>
References: <569D57B1.2060205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569D57B1.2060205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 18, 2016 at 11:22 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> As people know, I've had some paternity leave here as of late.  Then
> there was the annual shutdown at Red Hat for the holidays, and then I
> had some PTO on the back end of that.  As a result, I've been absent for
> a while.  I don't like to pre-announce these things on public mailing
> lists (nothing like telling the whole world when you will be away from
> home to make you feel safe about your home while you're gone), but I
> don't mind letting people know where I've been now that I'm back.
>
> Obviously I'm behind.  I'm going to send in a pull request shortly with
> the things that I had before I left on break.  I didn't get everything
> into my for-next tag that I wanted to before I left on break, so I
> expect there will be a second pull request that includes at least a
> couple larger items I was working on when I left that should be about
> the same now as they were before:
>
> RoCEv2 support
> mlx5 RoCE support
> mlx4 RoCEv2 support
> rdmavt
> qib->rdmavt changes
>
> Things that I intended to submit after the merge window opened and
> Greg's merge was done:
>
> Retake staging/rdma
> Delete staging/rdma/{amso1100,ehca,ipath}
> hfi1->rdmavt changes
> Add staging/rdma/soft-rxe
>
Doug,
it's not clear if you intend to take rdmavt into drivers/infiniband/sw
IMHO such a central piece of code needs to go through proper design
stages, be written with a clear and sharp interface and be published
with documentation.
To me it looks like the only purpose of rdmavt is to pull hfi1 driver
out from staging. If we want it as an infrastructure for any kind of
low level driver it needs to stick to infrastructure standards.
I hope that you agree

> Along the way, I may pick up some other commits too.  If you haven't
> seen your desired commit(s) that you think should make it into 4.5 (like
> the [v2] IB/core: sysfs.c: Fix PerfMgt ClassPortInfo handling patch that
> isn't in yet but needs to be), please send me an email *offlist* (this
> is important for my mail filtering that the list not be in the to/cc
> address, you can bcc if you want) and include a link to the patch or
> patches, preferably as a link to the latest version in patchworks versus
> say a link to a mailing list archive of the submission email.
>
> Thanks!
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
