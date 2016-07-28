From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 06/15] IB/pvrdma: Add virtual device RDMA structures
Date: Thu, 28 Jul 2016 13:07:32 -0700
Message-ID: <20160728130732.35b8bcb3@adits-macbook-pro.local>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
	<1468352205-9137-7-git-send-email-aditr@vmware.com>
	<20160726054629.GF20674@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160726054629.GF20674-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 26 Jul 2016 08:46:29 +0300
Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Tue, Jul 12, 2016 at 12:36:36PM -0700, Adit Ranadive wrote:
> > This patch adds the various Verbs structures that we support in the
> > virtual RDMA device. We have re-mapped the ones from the RDMA core stack
> > to make sure we can maintain compatibility with our backend.
> > 
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h | 450
> > +++++++++++++++++++++++++ 1 file changed, 450 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h
> >   
> 
> ...
> 
> > +enum pvrdma_wc_opcode {
> > +	PVRDMA_WC_SEND,  
> 
> ...
> 
> > +	PVRDMA_WC_RECV_RDMA_WITH_IMM
> > +};  
> 
> ....
> > +
> > +enum pvrdma_wc_flags {
> > +	PVRDMA_WC_GRH			= 1 << 0,  
> ....
> 
> > +	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_VLAN,
> > +};
> > +  
> 
> Sometimes you put "," at the last line of enums, sometimes you don't.
> Can you please be more consistent?
> 
> Thanks.

Done. Added , to the enums missing it. Will send this out in v3.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
