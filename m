From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Why don't we always check that attr->port_num is valid?
Date: Tue, 3 Oct 2017 19:52:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB19A8A5@ORSMSX109.amr.corp.intel.com>
References: <20171002113431.lqkf4ilmimjfouc7@mwanda>
 <20171002152033.GB12331@obsidianresearch.com>
 <20171003052159.GB26055@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171003052159.GB26055-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > We deliberately allow invalid attr->port_nums if IB_QP_PORT is not
> set.
> > > Why must we do that?  From a kernel hardening perspective it would
> > > be better to ban invalid values all together...
> >
> > It is part of the user ABI, so it has to stay that way...
> 
> Can we pre-process all invalid parameters at the kernel entry points
> to ensure that drivers receive clean input?
> 
> For example, overwrite attr->port_nums to be zero if IB_QP_PORT is not
> set.

I'm not sure this helps much.  The value must still be ignored by the driver, whether it's in range or not.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
