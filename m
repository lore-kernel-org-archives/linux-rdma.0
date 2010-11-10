From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: asynchronous operation with poll()
Date: Wed, 10 Nov 2010 11:04:29 -0700
Message-ID: <20101110180429.GJ909@obsidianresearch.com>
References: <ibbr34$ima$1@dough.gmane.org>
 <20101109204452.GG909@obsidianresearch.com>
 <ibeaq8$egv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ibeaq8$egv$1@dough.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 10, 2010 at 02:39:03PM +0000, Jonathan Rosser wrote:

> >Continually posting sends and recvs will get you into trouble, you
> >will run out of recvs and get RNR's. These days the wisdom for
> >implementing RDMA is that you should have explicit message flow
> 
> OK - I appreciate that a real world protocol ought to have flow
> control rather than just send as fast as possible. I've been trying
> to exercise the interfaces as far as possible and make sure my RDMA
> implementation is solid before building something real on top of it.

With iWarp if you send more than the receiver is able to receive you
will break the connection with an error. Some kind of flow control
scheme is mandatory..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
