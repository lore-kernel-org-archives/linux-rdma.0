From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/5] verbs: Use ccan list.h instead of open
 coding lists
Date: Fri, 1 Sep 2017 19:47:56 -0600
Message-ID: <20170902014756.GA866@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <b4255929-e0bc-d779-7190-f38fea24395e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b4255929-e0bc-d779-7190-f38fea24395e-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 01, 2017 at 09:05:33AM +0200, Nicolas Morey-Chaisemartin wrote:
> > For ibv_sysfs_dev, ibv_driver_name and ibv_driver internal structs. ccan
> > lists are easier to understand and use than the open coded versions.
> >
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >  libibverbs/init.c | 62 +++++++++++++++++++++++++------------------------------
> >  1 file changed, 28 insertions(+), 34 deletions(-)
> >
> > diff --git a/libibverbs/init.c b/libibverbs/init.c
> [...]
> > @@ -156,7 +156,8 @@ static int find_sysfs_devs(struct ibv_sysfs_dev **tmp_sysfs_dev_list)
> >  		else
> >  			sysfs_dev->abi_ver = 0;
> >  
> > -		*tmp_sysfs_dev_list = sysfs_dev;
> > +		list_node_init(&sysfs_dev->entry);
> > +		list_add(tmp_sysfs_dev_list, &sysfs_dev->entry);
> 
> I don't think you need to init the node.
> According to the header file: " * The new list_node does not need to be initialized; it will be overwritten."

Right you are, all fixed.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
