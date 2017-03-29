From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB
 driver
Date: Wed, 29 Mar 2017 07:46:37 -0600
Message-ID: <20170329134637.GA1940@obsidianresearch.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com>
 <20170321114955.GB2079@mtr-leonro.local>
 <20170321161530.GB22216@obsidianresearch.com>
 <20170321164952.GE2079@mtr-leonro.local>
 <CAAk-MO_KEV9MA5Dcaz8SZagMeC4hQX456Cu8To-YRBNMeNu3pg@mail.gmail.com>
 <20170322165238.GA26589@obsidianresearch.com>
 <CAAk-MO_7LVUQS_8+h9shFEXkjT6NHkzXeYRH+_8Wcjr0P+dHAw@mail.gmail.com>
 <20170326204237.GB3113@obsidianresearch.com>
 <CAAk-MO8Z7wKGFU5empgHGpN73cGMkKMi+ijnTHpfXBD5oZ+cGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO8Z7wKGFU5empgHGpN73cGMkKMi+ijnTHpfXBD5oZ+cGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 28, 2017 at 02:40:21PM +0300, Erez Shitrit wrote:
> > Does mlx5 even need a 'AH'? Maybe allowing the driver to provide some
> > bytes in the pseudo header that match the HW SQE is an overall more
> > efficient direction.
> 
> For mlx5/mlx4, the details from the ah are required, (in order to
> build the datagram segment in the wqe(,

I mean you can extract the details from the AH and store them in the
pseudo header specifically for mlx5. This avoids the need to store a
pointer.

> but the ref count is seamless since the ah is not a hw resource, I
> can put that instead of the pseudo header in the driver start_xmit

You can't just stuff a pointer into a skb, it needs to be kref'd
properly, which means when the skb is finally done someone kref_put's
that pointer. That is the hard part, IMHO.

The best option might be to store some kind of lookup hint that allows
the AH pointer to be found O(1) in normal cases, and does not require
kref trickery.

But optimizing this for GSO is not really related to this netdev
rework..

> > Eh? Having ndo->ipoib->driver or ndo->driver->ipoib as a call chain
> > doesn't really matter one bit.
> 
> I meant that the extra call is time consuming, if we need one more
> function (to extract the ah) that needs to be exported.

It isn't really extra and there isn't an issue exporting functions,
IHMO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
