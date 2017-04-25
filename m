From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/vmw_pvrdma: Spare annotate imm_data
Date: Tue, 25 Apr 2017 15:43:12 -0400
Message-ID: <1493149392.3041.94.camel@redhat.com>
References: <20170406223314.GA3893@obsidianresearch.com>
         <c9d760af-2437-b377-3663-9df0973e542e@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c9d760af-2437-b377-3663-9df0973e542e-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: VMware PV-Drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-06 at 18:17 -0700, Adit Ranadive wrote:
> On Thu, Apr 06, 2017 at 4:33:14PM -0600, Jason Gunthorpe wrote:
> > 
> > imm_data is copied directly from the ib_send_wr and ib_wc which
> > have
> > it marked as __be32, copy that mark into the uapi structures as
> > well.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > ---
> >  include/uapi/rdma/vmw_pvrdma-abi.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > This fixes sparse errors in user space and kernel space
> > 
> 
> Thanks!
> 
> Tested-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Acked-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
