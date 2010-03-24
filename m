From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Wed, 24 Mar 2010 11:43:17 -0600
Message-ID: <20100324174316.GL29129@obsidianresearch.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com> <20100323165920.GH29129@obsidianresearch.com> <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com> <20100323172953.GI29129@obsidianresearch.com> <5F80899D-F989-4162-B050-7E4D6B389876@cisco.com> <20100323195251.GJ29129@obsidianresearch.com> <3B848E1F-C9B6-416A-9E6E-99604E71902A@cisco.com> <20100323201124.GK29129@obsidianresearch.com> <adaljdi2rap.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaljdi2rap.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 23, 2010 at 10:59:42PM -0700, Roland Dreier wrote:

> That is all definitely doable.  I wonder if it's better to get rid of
> the dedicated fd though.  After all, having the fd means a fancy app can
> do poll() or sigio or whatever internally.  Being able to integrate into
> an fd-driven event loop seems like a pretty big thing to give up.

Not sure, adding the fd is only a small amount of work. But on the
other hand integrating with a completion channel might bet better
suited to verbs's API, and even less work..

> Also, having a uverbs "syscall" that is exactly like read() seems a bit
> of a stretch, even within the ugliness that is the uverbs interface.
> (We love all our children, but sometimes we have to be realistic)

I agree, but if the FD is eliminated then that seems like the best bet
- it wouldn't be exactly like read, it would be a multiplexed uverb
command executed over the uverbs fd.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
