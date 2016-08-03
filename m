From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/hfi1: Allocate cpu mask on the heap to silence
 warning
Date: Wed, 3 Aug 2016 23:17:31 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E22F4FEAB@CRSMSX101.amr.corp.intel.com>
References: <1470249441-22787-1-git-send-email-ira.weiny@intel.com>
 <20160803185403.GH27667@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160803185403.GH27667-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Struk, Tadeusz" <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, Aug 03, 2016 at 02:37:21PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > If CONFIG_FRAME_WARN is small (1K) and CONFIG_NR_CPUS big then a
> frame
> > size warning is triggered during build.
> > Allocate the cpu mask dynamically to silence the warning.
> >
> > Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/hfi1/affinity.c | 20 +++++++++++++-------
> >  1 file changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/hfi1/affinity.c
> > b/drivers/infiniband/hw/hfi1/affinity.c
> > index 79575ee873f2..62be2eda1b96 100644
> > --- a/drivers/infiniband/hw/hfi1/affinity.c
> > +++ b/drivers/infiniband/hw/hfi1/affinity.c
> > @@ -682,7 +682,7 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata
> *dd, const char *buf,
> >  			   size_t count)
> >  {
> >  	struct hfi1_affinity_node *entry;
> > -	struct cpumask mask;
> > +	cpumask_var_t mask;
> >  	int ret, i;
> >
> >  	spin_lock(&node_affinity.lock);
> > @@ -692,19 +692,24 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata
> *dd, const char *buf,
> >  	if (!entry)
> >  		return -EINVAL;
> >
> > -	ret = cpulist_parse(buf, &mask);
> > -	if (ret)
> > +	ret = zalloc_cpumask_var(&mask, GFP_KERNEL);
> > +	if (!ret)
> >  		return ret;
> 
> Ira,
> Are you aware that before this change you returned value different from
> zero in case of error and now you will return zero?
> 

No I did not realize that zalloc_cpumask_var returns bool...

Thanks, v2 on it's way.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
