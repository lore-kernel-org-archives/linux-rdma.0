From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/hfi: Properly set permissions for user device files
Date: Thu, 17 Sep 2015 17:15:04 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CB963AD@CRSMSX101.amr.corp.intel.com>
References: <1442439695-14275-1-git-send-email-ira.weiny@intel.com>
 <55FAE7C7.3070003@redhat.com> <20150917162355.GA8736@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917162355.GA8736-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Sep 17, 2015 at 06:18:15PM +0200, Michal Schmidt wrote:
> > On 09/16/2015 11:41 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > @@ -125,7 +151,20 @@ int __init dev_init(void)
> > >  		ret = PTR_ERR(class);
> > >  		pr_err("Could not create device class (err %d)\n", -ret);
> > >  		unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);
> > > +		goto done;
> > >  	}
> > > +	class->devnode = hfi1_devnode;
> > > +
> > > +	user_class = class_create(THIS_MODULE, class_name_user());
> > > +	if (IS_ERR(user_class)) {
> > > +		ret = PTR_ERR(user_class);
> > > +		pr_err("Could not create device class for user accisble files
> > > +(err %d)\n",
> >
> > ^^^^^^^^ Typo in error message.
> 
> And what is the deal with all these pr_err's? This is a driver, it needs to use
> dev_err and related always. Does thatneed to go in the todo list?
> 
> I'm also skeptical we need a print on every error case :|
> 

This is very early in the driver code and we don't have a struct device at this point.

The bulk of the driver uses macros which use dev_*.  So no I don't think we need to add anything to the todo list.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
