From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma-core: define link speed and link width enums
Date: Mon, 8 May 2017 11:13:34 -0600
Message-ID: <20170508171334.GA30717@obsidianresearch.com>
References: <1494251057-1060-1-git-send-email-devesh.sharma@broadcom.com>
 <20170508135404.GD10073@mtr-leonro.local>
 <e66a9fca-c6b3-ef6e-98b9-08d39bcc72d9@intel.com>
 <CANjDDBgeoiayNScofG=4CFUNbbqmizbvgtpWSHXcPqhatRSQoA@mail.gmail.com>
 <20170508161212.GA18125@obsidianresearch.com>
 <CANjDDBjDwuL8dn4ACkeGw-bBge6_fhFN5DqSAK6h0SPBGeds+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBjDwuL8dn4ACkeGw-bBge6_fhFN5DqSAK6h0SPBGeds+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 08, 2017 at 10:30:29PM +0530, Devesh Sharma wrote:
> > Relying on the kernel header from a uapi header means that we now
> > require the distro to have a sufficient version of that kernel header.

> Which means we need to have a mechanism to track the versions.
> is relying on the ABI version is good enough or you see any blockers
> there..

Realistically I think it means those distros will have to be
de-supported.

This might not be a problem, the uapi headers are fairly old now,
you'll have to check.. If something really old like rhel6 has what you
need then things are OK.

> > This might be OK, but you have to check to see what distros are
> > including (cbuild --run-shell can help with this)

> And if a given distro is not including then fall-back to current
> scheme, is it okay to have defining/un-defining compile time macros
> to enable/disable certain code sections?

No, generally not. This is too hard to do safely in public headers..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
