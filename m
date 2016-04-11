From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH v2 00/13] SELinux support for Infiniband RDMA
Date: Mon, 11 Apr 2016 16:12:10 -0600
Message-ID: <20160411221210.GA5861@obsidianresearch.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <20160411201155.GC371@obsidianresearch.com>
 <DB5PR05MB111168B6670B36F12979705BC4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB5PR05MB111168B6670B36F12979705BC4940-8IvNv+8VlcBJTpKhoUy7I9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 08:38:50PM +0000, Daniel Jurgens wrote:

> > This seems superficially similar to netlabel, which I guess targets a
> > certain niche, but I'm really wondering with all the other container
> > patches if this was supposed to be done with namespaces...
> 
> I can't speak to the goals of the other container patches.
> 
> Netlabel can't label kernel bypassed packets.  It can be used for IPoIB
> though.

I guess I'm surprised the first pass at this wasn't to ride on
netlabel at least for all the parts that use IPoIB for addressing (eg
typical rdmacm)

> >> An Infiniband device (ibdev) is labeled by name and port number.  There is a
> >> single access vector for ibdevs as well, called "smi".
> > 
> > This is called an End Port (SMI is something else in the IB
> > spec). Please use the standard terminology.
> I see your point on the end port, I'll address this is the next series
> by updating the commit messages and replacing ibdev with ibendport.
> 
> I don't understand where you think I've gone wrong on SMI.

Well, this makes no sense:
 There is a single access vector for ibdevs as well, called "smi".

SMI is not umad. SMI should only refer to the SMA access channel on a
specific node, and I have no idea why someone would want to restrict
local SMA access independently of generic umad qp0 access. Just call
it QP0 or QP1 or umad.

SMI is an obscure internal term that should not be user facing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
