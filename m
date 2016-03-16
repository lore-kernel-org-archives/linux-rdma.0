From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [WTF] utterly tasteless ABI in hfi1 (around ->write()/->write_iter())
Date: Wed, 16 Mar 2016 09:36:46 -0700
Message-ID: <CA+55aFxzJcBFG758ZD5E=c8m8G5WUhyPXRr1fTH+PgBJeqsMcQ@mail.gmail.com>
References: <20160316041717.GJ17997@ZenIV.linux.org.uk>
	<56E97FD7.9020007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E97FD7.9020007-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ira weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 16, 2016 at 8:46 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> If we want to maintain back compatibility, then the qib driver has to
> maintain this interface. We could possibly do a new one as well, but we
> can't remove this one.

We've broken more important driver ABI's before - all the nasty X stuff.

Now, the X people did learn their lesson, and it hasn't happened
lately (thank Gods!), but quite frankly, some shit-for-brains
hardware-specific config interface for a rdma device that basically
nobody uses is a _lot_ less important than X ever was.

So I don't care one whit if we break it, and it's not the kind of
backwards compatibility the kernel should worry about. There are
exactly zero regular users of this interface. I assume that people who
use this thing are *so* deeply technical that they can take care of
themselves. And it really is a completely broken interface.

I might be proven wrong, and somebody's dear old grandma ends up
complaining about a new kernel breaking her configuration, and in that
case we'd have to revert anything that causes that breakage. But I
suspect I'm not wrong.

                  Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
