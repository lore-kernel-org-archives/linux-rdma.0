From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [oss-security] CVE Request: Linux: IB/security: Restrict use of
 the write() interface'
Date: Sun, 8 May 2016 01:00:52 -0700
Message-ID: <20160508080052.GA30264@infradead.org>
References: <20160507042232.GA5286@eldamar.local>
 <1462645186.4268.27.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462645186.4268.27.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, May 07, 2016 at 08:19:46PM +0200, Yann Droneaud wrote:
> I thought access_ok() done as part of copy_to_user() would protect from
> such unwelcomed behavior. But it's not if the kernel invoke write()
> handler outside of a user process.

It does.  Core dumps are an obious example, although I fail to see
how an unprivilegued user could set the core dump pattern to involve
an IB uverbs device.  The other hint in the patch is that it checks
for the credentials, which suggests suid/sgid binaries are part of
the issue.

But the combination of the write abuse and allowing users to use the
device nodes is bound to be lethal sooner or later, so I'm not surprised
about issues popping up.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
