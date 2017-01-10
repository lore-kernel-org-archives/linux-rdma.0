From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Tue, 10 Jan 2017 09:10:31 -0700
Message-ID: <20170110161031.GB15493@obsidianresearch.com>
References: <20170109213944.31970-1-jarod@redhat.com>
 <20170109223108.GA10850@obsidianresearch.com>
 <0e01bfc8-333d-99dd-f7d1-024422923021@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0e01bfc8-333d-99dd-f7d1-024422923021-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 09, 2017 at 10:27:52PM -0500, Jarod Wilson wrote:
> On 2017-01-09 5:31 PM, Jason Gunthorpe wrote:
> >On Mon, Jan 09, 2017 at 04:39:44PM -0500, Jarod Wilson wrote:
> >>Building for 32-bit arm, things fall down, due to lack of arch-specific
> >>memory barriers.
> >
> >Since we now have rxe that should work on ARM I think we need to fix
> >this upstream..
> >
> >Do you have time to test some patches on ARM?
> 
> Afraid I don't have hardware. To the best of my knowledge, the only ARM
> systems my group has (and/or are getting soon) with RDMA hardware is all
> ARM64.

RDMA hardware doesn't work in ARM so that is OK. Cross compiling is
fine, ideal would be to test RXE on an arbitary ARM system, but I
wouldn't call that critical.

I just don't want to setup a cross compiler for this :\

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
