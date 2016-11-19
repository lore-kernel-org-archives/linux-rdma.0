From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 19 Nov 2016 21:46:58 +0200
Message-ID: <CAJ3xEMimsUMgRhWgSChFS39nw3XggsVGSnmgP+L4gSco=vAF3A@mail.gmail.com>
References: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
 <20161117184950.GP4240@leon.nu> <582E089A.3040106@redhat.com>
 <20161117200203.GQ4240@leon.nu> <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw@mail.gmail.com>
 <fea924a0-f399-8ecf-c039-5cb7c5e0acb8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fea924a0-f399-8ecf-c039-5cb7c5e0acb8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2016 at 4:01 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 11/17/2016 5:24 PM, Or Gerlitz wrote:

[...]

> I agree with you.  It doesn't fix your patch.  The commit message can
> still be fixed up.

>> Please do not send it to Linus and wait for them to respond. I
>> disagree that it fixes my commit b/c my commit was prior to when
>> route-able RoCE  was introduced and on that time TOS had no relation.

> I agree.  A better fix tag would be the commit that added RoCEv2 support.

But this is the smaller part of the problem. The bigger part is that I
have asked for clarifications on the patch and they didn't provide
anything. So if you are picking patches where a reviewer comments are
ignored, what lesson are you teaching the submitter, that he can just
continue with this practice? why you letting this go that way?

>> does a tiny enhancement for a 10y old commit of Roland, why you think
>> we need it in 4.9-rc6 or 7??

> I don't, it's in the mlx-next branch which means I'll queue it up for
> the 4.10 merge window.  I have no plan on sending that branch for 4.9-rc.

Are you going to comment on that to the submitter? if not, they are
going to continue with this practice.

How are we supposed to realize from patchworks + your github branches
that patches that were submitted for 4.9-rc are picked for 4.10? this
is very confusing and error prone too.

Please comment also on the bunch of patches I pointed you where the
copy you have picked into your tree (pulled it from somewhere?) isn't
what was submitted.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
