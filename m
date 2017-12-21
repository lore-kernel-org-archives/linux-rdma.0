From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 4/4] RDMA/vmw_pvrdma: Remove usage of BIT() from
 UAPI header
Date: Thu, 21 Dec 2017 09:34:33 -0700
Message-ID: <20171221163433.GD20015@ziepe.ca>
References: <20171220192305.GA28403@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171220192721.GA32622@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171221130034.GH2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221130034.GH2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 03:00:34PM +0200, Leon Romanovsky wrote:
> On Wed, Dec 20, 2017 at 11:27:28AM -0800, Bryan Tan wrote:
> > BIT() should not be used in the UAPI header. Remove it.
> >
> > Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> >  include/uapi/rdma/vmw_pvrdma-abi.h | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> IMHO, it should go to -rc.
> Doug, Jason?

I can't decide if any of the -abi.h changes should be for-rc material
or not..

The BIT() issue is being worked around in userspace today, so this
seems even less for-rc'y?

I'm leaning toward 'not' as we can and do cherry pick a for-next
uapi header into rdma-core, so there isn't really an actual reason to
put changes to those headers into for-rc?

Thoughts?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
