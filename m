From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] ib/srpt: Enhance printk output
Date: Tue, 12 Aug 2014 21:51:39 -0700
Message-ID: <CAG4TOxPWqHBjJHc99nqpkLkykaXOQi0vB4cnD+mgyUE4yfUu1Q@mail.gmail.com>
References: <cover.1407885084.git.dledford@redhat.com> <17d91e94768e30db6846a41c9ec66b217659fd28.1407885084.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <17d91e94768e30db6846a41c9ec66b217659fd28.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 12, 2014 at 4:20 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The ib_srpt module has a metric ton of printks for debugging and
> warnings and such.  And it never prefaces a single one of them with
> information to allow an admin to know what errant module is spewing
> garbage all through their dmesg output.  Fix that.

Target patches should probably go through Nic's tree, although for
srpt stuff like this I guess I can take it.

However I also think it would be a lot cleaner to define pr_fmt() at
the top of the file like

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and then convert the printks to pr_info() or pr_warn() instead of
having to type "ib_srpt:" everywhere.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
