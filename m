From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/ibsim] Provide support for SubnSet(GUIDInfo)
Date: Mon, 19 Sep 2011 09:59:04 -0600
Message-ID: <20110919155904.GA8113@obsidianresearch.com>
References: <20110916210611.GA6926@obsidianresearch.com>
 <CAKzyTsy6QsrufSAFrCDyUUZcZvQU+PHuPjEL7y9SrT3FuaD19Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKzyTsy6QsrufSAFrCDyUUZcZvQU+PHuPjEL7y9SrT3FuaD19Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2011 at 10:07:57AM -0400, Hal Rosenstock wrote:
> On Fri, Sep 16, 2011 at 5:06 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > Hardwire PortInfo.GUIDCap to 1 for both the switch and HCA case,
> 
> Why hardwire this to 1 ? This is not what most defaults are.
> 
> > then simply verify that the incoming SubnSet matches the RO data
> > in block 0.
> 
> Is this just to make the set of guidinfo simple ? Longer term, this
> should support a GUIDCap > 1 but I suppose that could be a follow on
> patch to this.

It is to make the existing ibsim compliant with the spec. If someone
cares about simulating guidinfo then they can implement a higher port
cap, otherwise, setting it to one lets things that those do try to
manipulate guid info not blow up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
