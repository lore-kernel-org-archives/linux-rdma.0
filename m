From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [WTF] utterly tasteless ABI in hfi1 (around
 ->write()/->write_iter())
Date: Wed, 16 Mar 2016 12:02:48 -0400
Message-ID: <20160316160248.GE23593@thunk.org>
References: <20160316041717.GJ17997@ZenIV.linux.org.uk>
 <56E97FD7.9020007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E97FD7.9020007-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ira weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 16, 2016 at 11:46:31AM -0400, Doug Ledford wrote:
> I can't speak for Mike, but I never said "It's Special".  I said it's a
> driver internal thing with only one consumer and the kernel driver and
> the user space consumer are a matched pair.  If this were a general API
> for use by any old program I would agree with you, but since it isn't, I
> wasn't that concerned about whether it got fixed.  If it broke, Intel
> had both pieces and could fix it.  And with that in mind I said "ince
> this is an internal driver interface that only Intel uses, I'm not
> inclined to force them to rewrite their driver and their library just
> because their particular usage took you off guard."

The thing which is really scary about the "we own both pieces, so we
can be sloppy with the interface design" is there is the question of
whether there are any security issues with such an interface.  Maybe
the assumption is that only root will get to access the interface, but
as we're seeing with user namespaces, very often these assumptions are
getting upended.

So certainly if I were a bad guy working at the NSA^H^H^H^H KGB trying
to find a zero-day that I would keep in my agency's back pocket,
interfaces designed with this kind of attitude would be the first
place I would look.

> For the hfi1 driver (and OPA in general), we do have the ability to do a
> new API.  But, going back to what I said before, I just don't care that
> much.  It's Intel internal stuff as far as I'm concerned.  If they do
> something fragile and it breaks, then that's all on their hands.

Except if there's a security vulernability, then it's on our
collective heads as kernel developers.  Unless we want to tell people,
"don't use intel hardware, it's written by device driver authors who
are sloppy"....

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
