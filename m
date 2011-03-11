From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Converting from RC to UC
Date: Fri, 11 Mar 2011 20:10:18 +0000 (UTC)
Message-ID: <loom.20110311T210251-557@post.gmane.org>
References: <loom.20110311T192125-878@post.gmane.org> <20110311185831.GX22729@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe@...> writes:
> I think what you are hitting is some code is calling ibv_modify_qp
> with an invalid qp_attr_mask for one of the state transitions. UC and
> RC have different requirements. Assuming you are not calling
> ibv_modify_qp in your app it is probably a kernel bug?
> 

No calls are made to ibv_modify_qp.  The application is failing on the connect,
so there has not been any application specific operations performed over
InfiniBand yet (other than the connection setup).  The application itself is
quite basic: eight application specific messages to be passed over InfiniBand,
along with RDMA write messages.  It can be thought of as a glorified scp 
operation.

I am using the vanilla 2.6.27.57 kernel.  If the problem is a kernel bug, I
would expect the kernel to not support UC at all, given the simplicity of the
application.

The only change made to the application for switching from RC to UC was to
change the queue type, which does not appear to work.  It seems that there are
other setup operations performed for the RC server which are not compatible with
a UC server, but no calls return errors until rdma_accept().  What other
settings/setup would be causing the issue that would not return an error?

I have found no examples for setting up a basic IB application using UC.  All
examples are with RC.  Does anyone know of any examples for UC that they could
point me towards?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
