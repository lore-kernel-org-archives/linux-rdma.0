From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Sat, 12 Mar 2016 07:12:32 +0100
Message-ID: <20160312061232.GA15236@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com> <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de> <56E071B6.8060809@sandisk.com> <20160310075722.GA551@lst.de> <56E1931C.1040206@sandisk.com> <20160310162150.GA9544@lst.de> <56E34914.2020108@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E34914.2020108-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 11, 2016 at 02:39:16PM -0800, Bart Van Assche wrote:
> The above is fine with me. But when I ran a test with rdma_rw_use_mr() 
> changed into "return true" the following error messages appeared in the 
> kernel log:
>
> [  364.460709] ib_srpt 0x1: parsing SRP descriptor table failed.
> [  383.604809] ib_srpt 0x0: parsing SRP descriptor table failed.
> [  383.605627] ib_srpt 0x2: parsing SRP descriptor table failed.
> [  386.702905] ib_srpt 0x3: parsing SRP descriptor table failed.
> [  386.703092] ib_srpt 0x4: parsing SRP descriptor table failed.
> [  386.703242] ib_srpt 0x5: parsing SRP descriptor table failed.
> [  386.703411] ib_srpt 0x6: parsing SRP descriptor table failed.
>
> Is this expected? I ran this test on a server equipped with two mlx4 HCAs 
> with latest firmware (2.36.5000). I installed git commit 
> c4c65482b56a433a82bc5b63db8ba125727e9f80 of the rdma-rw-api merged with 
> v4.5-rc7. Initiator and target drivers were running on the same server and 
> were communicating with each other via loopback. Before I modified 
> rdma_rw_use_mr() the same test passed on the same setup.

I think this might be the case when SRP gets multiple SGL entries.
In this case the number of MRs allocated is limited and srpt should
handle rdma_rw_ctx_init failures due to the lack of MRs.  If you add
the ib_mr_pool_get failure printk back that you asked me to remove
I bet it's going to trigger.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
