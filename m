From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 8/9] IB/mlx4: Support extended create_cq and
 query_device uverbs
Date: Wed, 3 Jun 2015 14:38:10 -0600
Message-ID: <20150603203810.GD7902@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433074457-26437-9-git-send-email-ogerlitz@mellanox.com>
 <20150601165649.GC14391@obsidianresearch.com>
 <CAAKD3BBsTFYKwOBK+6u04x6deRYzjYESJzbpyy83UtoChZhpOA@mail.gmail.com>
 <20150602170736.GA17776@obsidianresearch.com>
 <CAAKD3BARPocK1zZ2nYV0xWHqEASJTYbp1aQxwymi-TYTyK_vGA@mail.gmail.com>
 <20150603163146.GD12073@obsidianresearch.com>
 <CAJ3xEMhGdX-35WAjauKZE7+Wg39kbXP35UzYX33J6OB8g_9rYA@mail.gmail.com>
 <20150603191609.GB7902@obsidianresearch.com>
 <CAJ3xEMiPkxf_Qu40AozMRWZaY-dAfEyAOZGyT9VYsNpQO1Q-Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiPkxf_Qu40AozMRWZaY-dAfEyAOZGyT9VYsNpQO1Q-Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 03, 2015 at 10:35:03PM +0300, Or Gerlitz wrote:

> > They support the base functionality, the flags = 0 case.
> 
> which doesn't let consumers to use any new functionality.

So what? A call with flags = 0 works, why return ENOSYS for all
drivers except mlx4 in that case? It doesn't make sense to be
asymmetric like that.

Again, the extension process (patch #4) was to introduce the flags, as
long as the flags is processed properly then the syscall is
functional and should not return ENOSYS. It does not matter which
flags, if any, are supported.

> But the point here is a bit different: I somehow have the feeling that
> unless ~each and every one of your review comments are accepted to the
> letter, no inclusion.

I am just reviewing, Doug will have to decide if discussion is done or
not. To be clear: 'no inclusion' from me would be a clear NAK
statement.

If I'm going to provide my Reviewed-By I want to see:
 1) Comments addressed via a code change
 2) Comments addressed via a persuasive technical argument
 3) Comments addressed as 'too much work'/'un-important'/'personal preference'/etc.
 4) Comments addressed because I am wrong

And try to be clear about it, explain clearly.

> You are not the maintainer here, and even maintainers prefer not to
> force each of their detailed comments on submitters.

This isn't a detailed comment, this is a significant point about how a
UAPI is expected to work. And yes, UAPI is important, details are
important and I will argue for my viewpoint.

There is a huge difference between doing work on your own drivers and
doing core work. I do not know many cases where a maintainer/reviewer
of core sections will let details slide. There is a high expectation
for core code, and a very high expectation for UAPI.

> This specific comment relates TINY in-kernel thing that can be
> changed later.

Where is the pride? Do it right!

> If from ten comments you give me I accept as is five, with the other
> five I am trying to argue, on two of them we agree to my side, on two
> we go your side and on the last one we let the maintainer to cut, this
> is a healthy process that makes sense.

Sure, but you have to make a persuasive technical argument.. You can't
just argue..

In this case, you completely skipped over my main point:
 Drivers that only support flags == 0 should not return ENOSYS.

I gave several reasons why I think this is important, and how
userspace can use this, and how it is normal in the kernel.

You responded to the reasons, but ignored the actual thesis, and
didn't provide any counter reasons to support your idea:
 Drivers that only support flags == 0 should return ENOSYS.

So we are not debating, we are just arguing, and it isn't productive.

> I don't understand the "is any entirely different" part of the
> sentence, is that as of me being EMS-er?

No, that is just me typoing 'an -> any'. Sorry

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
