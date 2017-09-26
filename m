From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] IB/ocrdma: pr_err() strings should end with newlines
Date: Tue, 26 Sep 2017 08:23:07 -0700
Message-ID: <1506439387.29089.10.camel@perches.com>
References: <28298577a7f6111b2d40780dddd3c87a32168ab7.1506408446.git.arvind.yadav.cs@gmail.com>
         <20170926071920.GD5825@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170926071920.GD5825@yuvallap>
Sender: linux-kernel-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>, Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: selvin.xavier@broadcom.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 10:19 +0300, Yuval Shaia wrote:
> On Tue, Sep 26, 2017 at 12:21:44PM +0530, Arvind Yadav wrote:
> > pr_err() messages should end with a new-line to avoid other messages
> > being concatenated.
[]
> > diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
[]
> > @@ -658,7 +658,7 @@ static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
> >  		if (reset) {
> >  			status = ocrdma_mbx_rdma_stats(dev, true);
> >  			if (status) {
> > -				pr_err("Failed to reset stats = %d", status);
> > +				pr_err("Failed to reset stats = %d\n", status);
> >  				goto err;
> >  			}
> >  		}
> 
> While there, can you also fix line 1096 in ocrdma_hw.c?
> 
> (is it too naive to expect checkptahc to catch such errors?)

Yes.  It is not reasonable.

There would be way too high a false positive rate
as checkpatch could not trace whether or not there
is a printk(KERN_CONT or pr_cont after that.
