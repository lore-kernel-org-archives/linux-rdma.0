From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Add packet pacing support for IB verbs
Date: Thu, 10 Nov 2016 09:47:53 -0700
Message-ID: <20161110164753.GD22004@obsidianresearch.com>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7B31@ORSMSX109.amr.corp.intel.com>
 <20161109064009.GE27883@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7F0A@ORSMSX109.amr.corp.intel.com>
 <20161110072242.GC28957@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161110072242.GC28957-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 10, 2016 at 09:22:42AM +0200, Leon Romanovsky wrote:
> I'll let to Bodong to elaborate on it more, but as far as I see, the AH
> attribute is relevant to UD QP only, while the packet pacing is intended
> for all types of QPs.

In IB static rate is supposed to work for all QP types.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
