From: David Dai <zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 2/2] rds kernel space part of change for rds-stress -D
 option failure
Date: Wed, 02 Mar 2016 18:16:27 -0600
Message-ID: <1456964187.4878.8.camel@dhcp-9-53-106-245.austin.ibm.com>
References: <1456796846-8596-1-git-send-email-zdai@linux.vnet.ibm.com>
	 <1456796846-8596-3-git-send-email-zdai@linux.vnet.ibm.com>
	 <20160301185530.GA5975@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301185530.GA5975-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, Yuval:
   Thanks for the commit number you pointed. 
   I am able to see the commit content. This is the same logic as I
submitted.

Thanks! - David
On Tue, 2016-03-01 at 20:55 +0200, Yuval Shaia wrote:
> Please check commit 1d2e3f39.
> 
> On Mon, Feb 29, 2016 at 07:47:26PM -0600, David Dai wrote:
> > ---
> >  net/rds/rdma.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> > index b08ca60..d603645 100755
> > --- a/net/rds/rdma.c
> > +++ b/net/rds/rdma.c
> > @@ -657,6 +657,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
> >  		ret = rds_pin_pages(iov->addr, nr, pages, !op->op_write);
> >  		if (ret < 0)
> >  			goto out;
> > +		ret = 0;	
> >  
> >  		rdsdebug("RDS: nr_bytes %u nr %u iov->bytes %llu iov->addr %llx\n",
> >  			 nr_bytes, nr, iov->bytes, iov->addr);
> > -- 
> > 1.7.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
