From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V5 0/2] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Wed, 20 Aug 2014 10:26:32 -0600
Message-ID: <20140820162632.GB12605@obsidianresearch.com>
References: <1408517381-17523-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1408517381-17523-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 20, 2014 at 09:49:39AM +0300, Matan Barak wrote:
> Hi Roland,
> 
> This series adds support for Ethernet L2 address resolution for RoCE UD QPs,
> whose L2 address-handles, unlike RC/UC/XRC/etc QPs are set from user space
> without going through uverbs and the kernel IB core. The code is also
> compatible both with old kernels that don't run IP based addressing.

I think this looks much better now, avoiding churning the public API
has made this much less risky..

I'm not sure Roland's feeling on the subject, but I would like to see
your code be more consistent with the rest of verbs:
 - No 'reversed equal' ie verbs doesn't do: 'NULL == foo'
 - Pointless '^' equality 'optimization'
 - Wouldn't hurt to fix the various checkpatch warnings (for the most
   part verbs is in the style of Linux)
 - System libraries should not be randomly printing things in error
   cases. Use errno properly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
