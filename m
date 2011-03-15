From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: How is Q_KEY Set
Date: Tue, 15 Mar 2011 13:29:52 -0600
Message-ID: <20110315192952.GE12991@obsidianresearch.com>
References: <AANLkTikM2W2douWdRd4JfT5K_=mQjd6v_K5z8RwBW5vt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikM2W2douWdRd4JfT5K_=mQjd6v_K5z8RwBW5vt-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 15, 2011 at 02:45:12PM -0400, Greg I Kerr wrote:
> I was wondering how the Q_KEY is set by default, if
> the user doesn't specify it in the ibv_qp_attr struct?

Qkey is only used for UD connections (it is part of the DETH header)
and setting it is mandatory to transition from INIT to RTR.

So if you are not using UD then you don't have to worry about qkey,
if you are, then whatever value you pass in is being used (even if it
is unit'd memory)

> I couldn't find a suitable answer in the spec. The reason
> I'm asking is because I have a program where I create a
> "connection" in the sense that I perform all steps from
> opening the device to creating queue pairs and modifying
> them to point at the remote queue pairs. Then I run all the
> destructor functions, until I close the device.
> 
> I then re-open a new "connection." Right now I'm having
> issues with the poll_cq function either never finding anything
> on the queue, or returning transport retry counter error, when
> I try to send data over the new connection.

If you get RNR retry you are using RC and you have to worry about the
PSNs as well for every 'connection'.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
