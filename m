From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB
 driver
Date: Wed, 22 Mar 2017 10:52:38 -0600
Message-ID: <20170322165238.GA26589@obsidianresearch.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com>
 <20170321114955.GB2079@mtr-leonro.local>
 <20170321161530.GB22216@obsidianresearch.com>
 <20170321164952.GE2079@mtr-leonro.local>
 <CAAk-MO_KEV9MA5Dcaz8SZagMeC4hQX456Cu8To-YRBNMeNu3pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO_KEV9MA5Dcaz8SZagMeC4hQX456Cu8To-YRBNMeNu3pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 22, 2017 at 01:18:30PM +0200, Erez Shitrit wrote:

> 1. The qkey is not assigned at the initialization stage and the value
> in ah struct is not correct. It looks like, there is no way to avoid
> forwarding qkey (the item #6 - “no need to pass qkey, it is in the ah
> struct”).

It does make some sense that the qkey in the AH is not right, but it
still does not really make sense to forward it..

Just have the driver capture the qkey during 'attach_mcast'..

Looking at it more, there is something wrong with the implementation
in mlx5 since attach_mcast does not even use the qkey. I have no idea
how this works since the rx side must use a filter that only allows
packets that match the qkey for security.

Likely you will want to add a qkey argument to 'attach_mcast' to sort
this out..

> 2. In order to use the send from the ndo, there is need to pass the
> pointer to ib_av struct. The immediate solution is to embed it into
> the skb->data (we have 20 bytes free from the pseudo header).

Well, there are two solutions, one is to encode the ah in the pseudo
header during ipoib_hard_header. This is actually an optimization
because ipoib_hard_header is called bfore GSO splitting, so the ah can
be computed once instead of computed for every split packet. The
downside here is that it may be very complicated to store a kref in a
skb pseudo header and properly unref it at all the right times..

The other is to factor out the AH extraction from ipoib_start_xmit
into a helper function and have all the rn drivers call it to get the
AH.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
