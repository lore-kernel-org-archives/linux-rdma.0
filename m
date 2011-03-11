From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Converting from RC to UC
Date: Fri, 11 Mar 2011 11:58:31 -0700
Message-ID: <20110311185831.GX22729@obsidianresearch.com>
References: <loom.20110311T192125-878@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20110311T192125-878-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 11, 2011 at 06:29:19PM +0000, Alan Cook wrote:
> I currently have a working RDMA InfiniBand based client-server application using
> Reliable Connection (RC) service.  I would like to change the application to use
> Unreliable Connection (UC) service.  I am not performing RDMA reads, so I should
> be able to use UC.
> 
> I was under the impression that the only change that would be required would be
> changing the queue pair type from IBV_QPT_RC to IBV_QPT_UC.  After making this
> change on both the client and server applications, I receive an Invalid
> Parameter error from rdma_accept() on the server side of the application.  The
> client side reports no errors (other than the rejected server connection).
> 
> Internet searches have not been fruitful, as it seems most people are using RC
> rather than UC.
> 
> What else needs to be changed in the setup for switching from RC to UC?

I think what you are hitting is some code is calling ibv_modify_qp
with an invalid qp_attr_mask for one of the state transitions. UC and
RC have different requirements. Assuming you are not calling
ibv_modify_qp in your app it is probably a kernel bug?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
