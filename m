From: "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied by
 user verbs cmds
Date: Fri, 14 Jul 2017 14:54:13 +0000
Message-ID: <5C5647B5F4794941BAAC07CF28785CBC33E4FCFE@fmsmsx101.amr.corp.intel.com>
References: <20170713153957.515045341@linuxfoundation.org>
 <20170713153959.566717957@linuxfoundation.org>
 <5C5647B5F4794941BAAC07CF28785CBC33E4E81F@fmsmsx101.amr.corp.intel.com>
 <20170713162540.GB22870@kroah.com>
 <5C5647B5F4794941BAAC07CF28785CBC33E4EC25@fmsmsx101.amr.corp.intel.com>
 <20170714064908.GC16816@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170714064908.GC16816-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Polak <alexpo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Friday, July 14, 2017 1:49 AM
> To: Ismail, Mustafa <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Alex Polak
> <alexpo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon
> Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Subject: Re: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied
> by user verbs cmds
> 
> On Thu, Jul 13, 2017 at 06:44:38PM +0000, Ismail, Mustafa wrote:
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > > Sent: Thursday, July 13, 2017 11:26 AM
> > > To: Ismail, Mustafa <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> > > Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Alex Polak
> > > <alexpo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> Leon
> > > Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Doug Ledford
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Subject: Re: [PATCH 4.4 29/57] RDMA/uverbs: Check port number
> > > supplied by user verbs cmds
> > >
> > > On Thu, Jul 13, 2017 at 03:54:28PM +0000, Ismail, Mustafa wrote:
> > > > > Subject: [PATCH 4.4 29/57] RDMA/uverbs: Check port number
> > > > > supplied by user verbs cmds
> > > > >
> > > > > 4.4-stable review patch.  If anyone has any objections, please
> > > > > let me
> > > know.
> > > >
> > > > Yes, this breaks modify qp.
> > > > See https://patchwork.kernel.org/patch/9830663/
> > >
> > > I don't understand this response at all, sorry.
> > >
> > > What should I do about this?  Is this patch alone a problem?  Is
> > > there some other patch I should apply that is in Linus's tree?
> > > Where is the problem, only in this old release?
> > >
> > Applying this patch will break RDMA functionality with respect to
> modify_qp.
> > Specifically this part:
> > +	if (cmd.port_num < rdma_start_port(ib_dev) ||
> > +	    cmd.port_num > rdma_end_port(ib_dev))
> > +		return -EINVAL;
> > +
> > The cmd.port_num is only valid if (cmd->base.attr_mask & IB_QP_PORT).
> > So the above can be fixed with:
> > 	if ((cmd->base.attr_mask & IB_QP_PORT) &&
> > 	    (cmd.port_num < rdma_start_port(ib_dev) ||
> > 	    cmd.port_num > rdma_end_port(ib_dev)))
> > 		return -EINVAL;
> >
> > A version of this patch is in Linus's tree and it has the same problem:
> > commit 5ecce4c9b17bed4dc9cb58bfb10447307569b77b
> "RDMA/uverbs: Check port number supplied by user verbs cmds"
> >
> > We will be submitting a patch to fix this shortly.
> 
> Ok, so we will be "bug compatible" with Linus's tree then, right? :)
> 
> Should I hold off on applying this now, or just stay in sync and wait for your
> fixes to land in Linus's tree?  I vote stay-in-sync, as the other stable trees are
> also "broken" in the same way right now...
> 

I was thinking it would be better not to break iWARP and possibly other RDMA protocols, in  more stable trees if possible and apply the patch and fix at the same time.
But I see your point.

Regards,

Mustafa

> thanks,
> 
> greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
