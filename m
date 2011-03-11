From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Converting from RC to UC
Date: Fri, 11 Mar 2011 15:07:45 -0700
Message-ID: <20110311220745.GZ22729@obsidianresearch.com>
References: <loom.20110311T192125-878@post.gmane.org>
 <AANLkTimM0PDiWuHFJfn3s-JVEKWHVVfL4+2Kcc4+G5C7@mail.gmail.com>
 <loom.20110311T224601-402@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20110311T224601-402-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 11, 2011 at 09:55:00PM +0000, Alan Cook wrote:
> Roland Dreier <roland@...> writes:
> > 
> > How are you setting up the connection?
> > 
> > My understanding is that the RDMA CM (ie librdmacm) does not handle UC,
> > so if you are using that, it shouldn't work.  Sean could confirm this.
> > 
> >  - R.
> 
> I am using RDMA CM.  I have not seen any documentation that states it does not
> support UC, although I have not seen any documentation that says it does either.
>  I have seen documentation regarding RDMA CM that talks about a connection not
> actually being established between queue pairs when using unreliable datagram
> (UD), but nothing regarding support for UC.
> 
> If it is the case that RDMA CM is not supported, could someone point me at a
> resource that describes setting up an IB RDMA connection not using RDMA CM?

If you can tolerate it you might be better off just fixing the kernel,
the change is probably only one or two additional if statements to
support RC vs UC. Unfortunately I looked around for a mins for you but
I did not see an obvious error. Though perhaps the RTS transition in
the IB CM is at fault?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
