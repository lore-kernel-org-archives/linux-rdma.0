From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Thu, 17 Mar 2016 10:17:16 +0200
Message-ID: <20160317081716.GD25216@leon.nu>
References: <20160315155441.222586021@linux.com>
 <20160315155455.173645653@linux.com>
 <20160317072354.GB25216@leon.nu>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160317072354.GB25216-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 17, 2016 at 09:23:54AM +0200, Leon Romanovsky wrote:
> On Tue, Mar 15, 2016 at 10:54:42AM -0500, Christoph Lameter wrote:
> > +static struct attribute_group *create_protocol_stats(struct ib_device *device,
> > +						     struct kobject *kobj,
> > +						     u8 port) {
> > +	struct attribute_group *ag;
> > +	struct rdma_protocol_stats stats = {0};
> > +	u32 counters;
> > +	u32 i;
> > +	int ret;
> > +
> > +	ret = device->get_protocol_stats(device, &stats, port);
> > +
> > +	if (ret || !stats.name)
> 
> This check puzzles me, "stats" variable was declares on stack a couple
> of lines before. All values in it were assigned to zero, so my
> expectation that stats.name == 0 (null). Am I right?
> So what do you check here?

Reply to myself, after internal conversation.
The stats.name is filled by get_protocol_stats function in case of
counter was found.

I didn't check for other proposals except mlx5 but I assume that in case nothing was filled
there, this function should return NOSUPPORT.

> 
> > +		return NULL;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
