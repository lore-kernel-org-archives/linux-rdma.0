From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/ibsim] Provide support for SubnSet(GUIDInfo)
Date: Wed, 21 Sep 2011 10:37:59 -0600
Message-ID: <20110921163759.GG28454@obsidianresearch.com>
References: <20110916210611.GA6926@obsidianresearch.com>
 <CAKzyTsy6QsrufSAFrCDyUUZcZvQU+PHuPjEL7y9SrT3FuaD19Q@mail.gmail.com>
 <20110919155904.GA8113@obsidianresearch.com>
 <CAKzyTsw+VpLaz14eSLNED40QGN3GCeQ5xC7FZp59Da8C1xE3ww@mail.gmail.com>
 <20110919200637.GA28454@obsidianresearch.com>
 <CAKzyTswY3ebSgWMWhm7aV0n4PHa4O1qxuHu-EqnwER7b7o-=Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKzyTswY3ebSgWMWhm7aV0n4PHa4O1qxuHu-EqnwER7b7o-=Dg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 21, 2011 at 09:04:45AM -0400, Hal Rosenstock wrote:
> On Mon, Sep 19, 2011 at 4:06 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Mon, Sep 19, 2011 at 03:55:24PM -0400, Hal Rosenstock wrote:
> >
> >> >> Is this just to make the set of guidinfo simple ? Longer term, this
> >> >> should support a GUIDCap > 1 but I suppose that could be a follow on
> >> >> patch to this.
> >> >
> >> > It is to make the existing ibsim compliant with the spec.
> 
> You wrote that this was for spec compliance...

It is, the previous version returned an attribute error for all sets,
which is not compliant.

I don't really care at all, I just want sets to work.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
