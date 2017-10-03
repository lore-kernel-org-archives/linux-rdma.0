From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Why don't we always check that attr->port_num is valid?
Date: Tue, 3 Oct 2017 10:56:06 -0500
Message-ID: <20171003155606.GA12560@ctung-MOBL3.amr.corp.intel.com>
References: <20171002113431.lqkf4ilmimjfouc7@mwanda>
 <20171002152033.GB12331@obsidianresearch.com>
 <20171003052159.GB26055@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003052159.GB26055-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 03, 2017 at 08:21:59AM +0300, Leon Romanovsky wrote:
> On Mon, Oct 02, 2017 at 09:20:33AM -0600, Jason Gunthorpe wrote:
> > On Mon, Oct 02, 2017 at 02:34:31PM +0300, Dan Carpenter wrote:
> >
> > > We deliberately allow invalid attr->port_nums if IB_QP_PORT is not set.
> > > Why must we do that?  From a kernel hardening perspective it would be
> > > better to ban invalid values all together...
> >
> > It is part of the user ABI, so it has to stay that way...
> 
> Can we pre-process all invalid parameters at the kernel entry points to
> ensure that drivers receive clean input?

Which side?  I hope you meant the kernel side. I certainly wouldn't want
kernel to trust user input...

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
