From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 8 Sep 2015 17:35:14 -0700
Message-ID: <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
	<CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2015 at 5:21 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> This needs a good explanation, because for now this pull request is dead to me.

Just to clarify: it's really the combination of:

 (a) you were told about this

 (b) you rebased your commit series after it

 (c) you didn't fix it and never even mentioned the issue

that makes me just go "I want to have absolutely nothing to do with
this disaster area of a pull request".

The conflict itself? Big deal. Conflicts happen. But that patch
shouldn't have gone through your tree in the first place, and it damn
well should have had an ack from David or something if it did.

And the *same* company sent two different patches for the same thing
to two different submaintainers?  WTF guys?

Kernel development isn't a sport where you throw shit on the wall to
see what sticks.

This could have been done correctly. You could have cc'd David, and
you could also have just said "sorry, there's a conflict due to me
taking a different version of a patch that also went through the
networking tree". Or you could have tried to synchronize to begin
with, and just used the same version of the patch from day one. Or if
you had to rebase your patch series (why was that done, anyway?) you
could just have fixed it to do what the networking tree already did.

So this could have been done so much better in many ways. But none of
that happened.

Cross-subsystem conflicts do happen, and patches that cross said
subsystems aren't evil per se. I have lost count of how many conflicts
I've resolved in just this merge window. I do it all the time. But
this one made me just go "Eww".

The rebase and the complete lack of communication here just makes me angry.

                   Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
