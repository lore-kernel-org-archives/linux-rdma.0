From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 2/2] RDMA/vmw_pvrdma: Update device query
 parameters and port caps
Date: Wed, 23 Aug 2017 11:08:01 -0700
Message-ID: <34d28cff-79a5-b604-fc1e-8d083f53225d@vmware.com>
References: <cover.1503468979.git.aditr@vmware.com>
 <a31ee424df9ad51371ff38e4f8239a390df13947.1503468979.git.aditr@vmware.com>
 <20170823090920.GN1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823090920.GN1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 23, 2017 at 12:09:20AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 22, 2017 at 11:19:01PM -0700, Adit Ranadive wrote:
> > Added support for two device caps - max_sge_rd, max_fast_reg_page_list_len
> > and the IP_BASED_GIDS port cap flag.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 9 ++++++++-
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   | 9 +++++++++
> >  2 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > index 3a308ff..df0a6b5 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > @@ -149,6 +149,13 @@
> >  	((_dev->dsr->caps.mode == PVRDMA_DEVICE_MODE_ROCE) &&		\
> >  	 (PVRDMA_IS_VERSION17(_dev) || PVRDMA_IS_VERSION18(_dev)))
> >
> > +/*
> > + * Get capability values based on device version.
> > + */
> > +
> > +#define PVRDMA_GET_CAP(_dev, _old_val, _val) \
> > +	((PVRDMA_IS_VERSION18(_dev)) ? _val : _old_val)
> > +
> 
> The current macro implementation will require you to go and update all
> the places once you will move to new version. In simple case, everything
> is supported and you will change your check of PVRDMA_IS_VERSION18 to
> something PVRDMA_IS_VERSIONXXX and it will work.

Thanks for taking a look. That's the intention I wrote the macro with so it
should pick up the value based on the current device version. If you are
concerned that we will change device caps without changing the PVRDMA
version, that's something we avoid for compatibility reasons.

> In more complex case, when one of the features is supported in one version
> but isn't supported in another you will need to add "if(specific_feature)" magic
> into it.

This will not happen based on how our version model currently works.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
