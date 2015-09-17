From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/hfi: Properly set permissions for user device files
Date: Thu, 17 Sep 2015 10:23:55 -0600
Message-ID: <20150917162355.GA8736@obsidianresearch.com>
References: <1442439695-14275-1-git-send-email-ira.weiny@intel.com>
 <55FAE7C7.3070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55FAE7C7.3070003-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 17, 2015 at 06:18:15PM +0200, Michal Schmidt wrote:
> On 09/16/2015 11:41 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > @@ -125,7 +151,20 @@ int __init dev_init(void)
> >  		ret = PTR_ERR(class);
> >  		pr_err("Could not create device class (err %d)\n", -ret);
> >  		unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);
> > +		goto done;
> >  	}
> > +	class->devnode = hfi1_devnode;
> > +
> > +	user_class = class_create(THIS_MODULE, class_name_user());
> > +	if (IS_ERR(user_class)) {
> > +		ret = PTR_ERR(user_class);
> > +		pr_err("Could not create device class for user accisble files (err %d)\n",
>                                                                ^^^^^^^^
> Typo in error message.

And what is the deal with all these pr_err's? This is a driver, it
needs to use dev_err and related always. Does thatneed to go in the
todo list?

I'm also skeptical we need a print on every error case :|

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
