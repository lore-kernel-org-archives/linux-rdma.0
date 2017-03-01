From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC for accelerated IPoIB 00/27] Enhanced mode for IPoIB driver
Date: Wed, 1 Mar 2017 11:28:33 -0700
Message-ID: <20170301182833.GD14791@obsidianresearch.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 04:02:08PM +0200, Erez Shitrit wrote:
>     However, New features are exisiting in common network interfaces that
>     are very hard to implement in IPoIB interfaces while it uses the RDMA
>     layer, examples include TSS and RSS, tunneling offloads, and XDP.
>     Rather than continuously porting IP network interface developments into
>     the RDMA stack, we propose adding an abstract network data-path interfaces
>     to RDMA devices.

I should also say that we have discussed this for a while and I am
broadly in favor of this approach of delegating IPoIB skb transmit
directly to the low level driver.

There are too many optimizations that do not fit sanely into verbs,
and the entire overhead of building a verbs wr and posting it then
translating that to a driver wr is unnecessary layering.

Longer term, it might be quite nice if the part verbs specific part of
ipoib was cleanly split out into the 'default' implementation of your
get_ipoib_accel_ops.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
