From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Converting from RC to UC
Date: Fri, 11 Mar 2011 18:29:19 +0000 (UTC)
Message-ID: <loom.20110311T192125-878@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I currently have a working RDMA InfiniBand based client-server application using
Reliable Connection (RC) service.  I would like to change the application to use
Unreliable Connection (UC) service.  I am not performing RDMA reads, so I should
be able to use UC.

I was under the impression that the only change that would be required would be
changing the queue pair type from IBV_QPT_RC to IBV_QPT_UC.  After making this
change on both the client and server applications, I receive an Invalid
Parameter error from rdma_accept() on the server side of the application.  The
client side reports no errors (other than the rejected server connection).

Internet searches have not been fruitful, as it seems most people are using RC
rather than UC.

What else needs to be changed in the setup for switching from RC to UC?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
