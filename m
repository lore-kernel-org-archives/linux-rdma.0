From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] lockdep warning fixes
Date: Thu, 9 Jul 2015 13:49:35 +0300
Message-ID: <CAJ3xEMiydOEN_baOJcdcH0=LL+6Qv2HM5XJGirjqFHfz4zif5g@mail.gmail.com>
References: <1436280313-21451-1-git-send-email-haggaie@mellanox.com>
	<559DA5E9.5050500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559DA5E9.5050500-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 9, 2015 at 1:36 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Thanks, both applied.

to where?! Doug, I didn't see any update on your gitbub nor your
kernel.org tree, and again, it's a bit annoying to chase two trees w.o
clear branching policy... can you use something with clear name (say)
4.2-fixes on your github and it would be clear that 4.2 rc fixes go
there?

Also, I didn't see a note from you on picking the fixes from Ira and
myself to address the comments from Linus..

Ira's https://patchwork.kernel.org/patch/6675271/ -- this still has
blank line that I asked Ira to remove, so if you can either ask him to
do so, or clean this up yourself...

mine https://patchwork.kernel.org/patch/6675921/

and the mlx4 fix Matan's code plus the ipoib fix

https://patchwork.kernel.org/patch/6702851/
https://patchwork.kernel.org/patch/6702841/


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
