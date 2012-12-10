From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] Avoid linker error with clang 3.0
Date: Sun, 9 Dec 2012 23:06:00 -0700
Message-ID: <20121210060600.GA30472@obsidianresearch.com>
References: <alpine.BSF.2.00.1212090306300.64779@toaster.local>
 <50C490D9.1000301@acm.org>
 <CAGH67wS1P43ssD+-VFyCupLw3CT8U73wT-aT6N2AS5ddWApAoA@mail.gmail.com>
 <CAGH67wQt48zEp0KiN44w=wfYZy+FA6oc=ehuAHUL2QBo=A1nhw@mail.gmail.com>
 <ABB9B291-3AB5-4AE6-8CE2-5FE691E1AE02@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ABB9B291-3AB5-4AE6-8CE2-5FE691E1AE02-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 09, 2012 at 01:47:03PM -0800, Garrett Cooper wrote:

> 	After talking with some other more knowledgeable people than
> 	myself, it looks like opensm is depending upon gcc inline
> 	behavior:
> 	http://freebsd.1045724.n5.nabble.com/C99-inlines-td4157849.html
> 	, http://wiki.freebsd.org/PortsAndClang (look for "undefined
> 	or duplicate symbols while linking"). The previously attached
> 	patch should be ok for dealing with the linking problem as it
> 	just changes the scoping. Definitely learned a few things
> 	today about gcc :).

It is definately a bug in the code, it should be 'static inline' - the
reason it doesn't blow up on gcc is most likely because nobody ever
compiled it with a low enough optimization level to see it.

Looks to me like clang is fine, no bug there.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
