From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied by
 user verbs cmds
Date: Mon, 17 Jul 2017 17:30:45 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC34341BF7@fmsmsx120.amr.corp.intel.com>
References: <20170713153957.515045341@linuxfoundation.org>
 <20170713153959.566717957@linuxfoundation.org>
 <5C5647B5F4794941BAAC07CF28785CBC33E4E81F@fmsmsx101.amr.corp.intel.com>
 <20170713162540.GB22870@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713162540.GB22870-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Polak <alexpo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied
> by user verbs cmds
> 
> On Thu, Jul 13, 2017 at 03:54:28PM +0000, Ismail, Mustafa wrote:
> > > Subject: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied
> by
> > > user verbs cmds
> > >
> > > 4.4-stable review patch.  If anyone has any objections, please let me
> know.
> >
> > Yes, this breaks modify qp.
> > See https://patchwork.kernel.org/patch/9830663/
> 
> I don't understand this response at all, sorry.
> 
> What should I do about this?  Is this patch alone a problem?  Is there
> some other patch I should apply that is in Linus's tree?  Where is the
> problem, only in this old release?
> 
> totally confused,
> 

This patch utterly breaks qib and hfi1 on at least 4.10.11 stable kernel.

I suspect and will soon verify that v4.13-rc1 is broke as well.

Mike


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
