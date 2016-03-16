From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [WTF] utterly tasteless ABI in hfi1 (around
 ->write()/->write_iter())
Date: Wed, 16 Mar 2016 17:06:59 +0000
Message-ID: <20160316170659.GM17997@ZenIV.linux.org.uk>
References: <20160316041717.GJ17997@ZenIV.linux.org.uk>
 <56E97FD7.9020007@redhat.com>
 <CA+55aFxzJcBFG758ZD5E=c8m8G5WUhyPXRr1fTH+PgBJeqsMcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxzJcBFG758ZD5E=c8m8G5WUhyPXRr1fTH+PgBJeqsMcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ira weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 16, 2016 at 09:36:46AM -0700, Linus Torvalds wrote:
> On Wed, Mar 16, 2016 at 8:46 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > If we want to maintain back compatibility, then the qib driver has to
> > maintain this interface. We could possibly do a new one as well, but we
> > can't remove this one.
> 
> We've broken more important driver ABI's before - all the nasty X stuff.
> 
> Now, the X people did learn their lesson, and it hasn't happened
> lately (thank Gods!), but quite frankly, some shit-for-brains
> hardware-specific config interface for a rdma device that basically
> nobody uses is a _lot_ less important than X ever was.
> 
> So I don't care one whit if we break it, and it's not the kind of
> backwards compatibility the kernel should worry about. There are
> exactly zero regular users of this interface. I assume that people who
> use this thing are *so* deeply technical that they can take care of
> themselves. And it really is a completely broken interface.
> 
> I might be proven wrong, and somebody's dear old grandma ends up
> complaining about a new kernel breaking her configuration, and in that
> case we'd have to revert anything that causes that breakage. But I
> suspect I'm not wrong.

Let's start with "do saner interface for hfi1 if you want it in", then
duplicate it for ipathfs (using the saner userland side already tested on
fixed hfi1), then we make sure nobody is even tempted to repeat that
ugliness more or less along the lines of what you'd proposed in
fs/read_write.c, but might as well add a sanity check in do_dentry_open(),
where we already have
        if ((f->f_mode & FMODE_WRITE) &&
             likely(f->f_op->write || f->f_op->write_iter))
                f->f_mode |= FMODE_CAN_WRITE;
- the check for both methods being present could go there conveniently enough;
"use new_sync_write() as ->write" is spelled as "have NULL ->write and non-NULL
->write_iter" these days, so having both is very rare; it's only
/dev/zero, /dev/null and these two perversions.  And while writes to /dev/null
are very important (for email handling, if nothing else), I suspect that we
won't be seriously hurt by having it do the extra work new_sync_write() would
involve...  Or we could special-case that in the check (move write_null(),
aka return the third argument into fs/libfs.c and in unlikely case of having
both ->write and ->write_iter check if ->write is that one).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
