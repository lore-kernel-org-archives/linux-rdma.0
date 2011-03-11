From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Converting from RC to UC
Date: Fri, 11 Mar 2011 14:54:22 -0700
Message-ID: <20110311215422.GY22729@obsidianresearch.com>
References: <loom.20110311T192125-878@post.gmane.org>
 <20110311185831.GX22729@obsidianresearch.com>
 <AANLkTikqv-WYcL3_=5HRU6mVORLydNgcqv-5_VYkJrbC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikqv-WYcL3_=5HRU6mVORLydNgcqv-5_VYkJrbC-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 11, 2011 at 02:52:24PM -0500, Alan Cook wrote:
> I am using the vanilla 2.6.27.57 kernel. If the problem is a kernel
> bug, I would expect the kernel to not support UC at all, given the
> simplicity of the application.

That is quite likely, actually. You are using the RDMA CM and I have
never heard of anyone using UC that way.

Raw verbs UC definitely works.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
