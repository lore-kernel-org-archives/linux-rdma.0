From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
Date: Wed, 29 Sep 2010 11:52:10 -0700
Message-ID: <ada8w2k2xid.fsf@cisco.com>
References: <20100929141112.26944.21931.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100929141112.26944.21931.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Wed, 29 Sep 2010 09:11:12 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > --- a/drivers/infiniband/hw/cxgb4/device.c
 > +++ b/drivers/infiniband/hw/cxgb4/device.c
 > @@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
 >  	.open    = qp_open,
 >  	.release = qp_release,
 >  	.read    = debugfs_read,
 > +	.llseek  = default_llseek,
 >  };
 >  
 >  static int dump_stag(int id, void *p, void *data)
 > @@ -255,6 +256,7 @@ static const struct file_operations stag_debugfs_fops = {
 >  	.open    = stag_open,
 >  	.release = stag_release,
 >  	.read    = debugfs_read,
 > +	.llseek  = default_llseek,
 >  };
 >  
 >  static int setup_debugfs(struct c4iw_dev *devp)
 > 
 > 

Steve, can you also do a quick test to make sure this works OK with
generic_file_llseek instead of default_llseek?

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
