From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Why don't we always check that attr->port_num is valid?
Date: Mon, 2 Oct 2017 09:20:33 -0600
Message-ID: <20171002152033.GB12331@obsidianresearch.com>
References: <20171002113431.lqkf4ilmimjfouc7@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171002113431.lqkf4ilmimjfouc7@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 02, 2017 at 02:34:31PM +0300, Dan Carpenter wrote:

> We deliberately allow invalid attr->port_nums if IB_QP_PORT is not set.
> Why must we do that?  From a kernel hardening perspective it would be
> better to ban invalid values all together...

It is part of the user ABI, so it has to stay that way...

Can some code restructuring bring both things under the same if
somehow?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
