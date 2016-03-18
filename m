From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure
 dynamic
Date: Thu, 17 Mar 2016 20:56:55 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1603172054540.18714@east.gentwo.org>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com> <20160317072354.GB25216@leon.nu>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160317072354.GB25216-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 17 Mar 2016, Leon Romanovsky wrote:

> On Tue, Mar 15, 2016 at 10:54:42AM -0500, Christoph Lameter wrote:
> > +static struct attribute *alloc_stats_port(u32 index, u8 port, char *name)
> > +{
> > +	struct ib_port_stats *ps;
> > +
> > +	ps = kmalloc(sizeof(*ps), GFP_KERNEL);
> > +	if (!ps)
> > +		return NULL;
>
> Out of curiosity, why are we returning NULL and not ERR_PTR(ENOMEM)?

Its the convention for kmalloc. Yes, I am the maintainer of the slab
allocators but this predates my earliest activities and this convention is
widely used throughout the kernel and NULL is the only way that
kmalloc signals an error condition.

> > +	u32 i;
> > +	int ret;
> > +
> > +	ret = device->get_protocol_stats(device, &stats, port);
> > +
> > +	if (ret || !stats.name)
>
> This check puzzles me, "stats" variable was declares on stack a couple
> of lines before. All values in it were assigned to zero, so my
> expectation that stats.name == 0 (null). Am I right?

The get_protocol_stats() function modifies the stats structure.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
