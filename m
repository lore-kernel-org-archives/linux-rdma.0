From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Add Quality of Service support
Date: Mon, 10 Oct 2016 12:58:10 -0500
Message-ID: <20161010175810.GA3312@horosco-MOBL2.amr.corp.intel.com>
References: <20161007204747.6420-1-henry.orosco@intel.com>
 <20161010042710.GH9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161010042710.GH9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2016 at 07:27:10AM +0300, Leon Romanovsky wrote:
> On Fri, Oct 07, 2016 at 03:47:47PM -0500, Henry Orosco wrote:
> 
> <...>
> 
> >
> >  	switch (iwdev->init_state) {
> >  	case RDMA_DEV_REGISTERED:
> > @@ -1628,6 +1642,7 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
> >  		iwdev->init_state = RDMA_DEV_REGISTERED;
> >  		iwdev->iw_status = 1;
> >  		i40iw_port_ibevent(iwdev);
> > +		iwdev->param_wq = create_singlethread_workqueue("l2params");
> >  		i40iw_pr_info("i40iw_open completed\n");
> 
> No, please don't use this interface, For reference, see latest work from Bhaktipriya
> Shridhar to eliminate this call. Doug and Dave sent a pull request with it to Linus in
> last merge cycle.
> 

Ah, missed that. Will send out another version. Thanks!

> Also, 1) you should check if this call succeeded and 2) ask yourself if
> special workqueue is needed.
> 
> >  		return 0;
> >  	} while (0);
> 
> Thanks.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
