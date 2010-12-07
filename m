From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 7 Dec 2010 14:29:24 -0700
Message-ID: <20101207212924.GG16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-6-git-send-email-nirm@voltaire.com>
 <20101129191136.GC16788@obsidianresearch.com>
 <1291126171.3155.250.camel@nirm-desktop>
 <20101130181944.GI16788@obsidianresearch.com>
 <1291219134.3155.471.camel@nirm-desktop>
 <20101201183538.GQ16788@obsidianresearch.com>
 <1291736427.32170.36.camel@nirm-desktop>
 <20101207185453.GD16788@obsidianresearch.com>
 <7E95F01E94AB484F83061FCFA35B39F8794E3B@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F8794E3B-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 07, 2010 at 10:53:23PM +0200, Nir Muchtar wrote:

> I'm just not convinced this can be easily completed/accepted and not
> divert us from the primary goal, so I prefer picking this up later
> after those

This part of the kernel is mature, the 'primary goal' is to not add
new half backed things that need to churn userspace APIs before they
are complete :)

> patches are accepted. If I discover there's no good way to obtain this 
> through userspace then I won't.

There isn't. Read my last message.

> > > The thing is, there's no easy and clean way to retrieve the export when
> > > using dump_start.
> > 
> > I don't follow this comment, can you elaborate?
> > 
> > This really needs to use the dump api, and I can't see any reason why
> > it can't.
 
> As I said, there's just no way (I know of) to use dump_start, divide data
> into several packets, and receive a consistent snapshot of the data, and
> this is an issue. We can achieve all that by doing something a little 
> different so why shouldn't we? 

You have to give up on 100% consistency to use dump_start, which is OK
for diags, and what other dumpers in the kernel do.

What you've done in your v2 patch won't work if the table you are
dumping is too large, once you pass sk_rmem_alloc for the netlink
socket it will deadlock. The purpose of dump_start is to avoid that
deadlock. (review my past messages on the subject)

Your v1 patch wouldn't deadlock, but it would fail to dump with
ENOMEM, and provides an avenue to build an unprivileged kernel OOM
DOS.

The places in the kernel that don't use dump_start have to stay under
sk_rmem_alloc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
