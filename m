From: 'Christoph Hellwig' <hch@lst.de>
Subject: Re: [PATCH v4 1/9] IB/cma: pass the port number to ib_create_qp
Date: Wed, 9 Mar 2016 14:58:04 +0100
Message-ID: <20160309135804.GA32315@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-2-git-send-email-hch@lst.de> <20160308192709.GJ13396@leon.nu> <017b01d17972$11e5a3b0$35b0eb10$@opengridcomputing.com> <20160308195514.GK13396@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160308195514.GK13396@leon.nu>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Christoph Hellwig' <hch@lst.de>, dledford@redhat.com, bart.vanassche@sandisk.com, sagig@mellanox.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 09:55:14PM +0200, Leon Romanovsky wrote:
> > At the expense of replicating this code and forcing all users to remember to set this.
> 
> There are no much such users to update, these users need to set
> qp_init_attr structure anyway.

But they need to extract the port_num first, while we already get
the cm_id that has the right port_id passed to this function.  Not
setting it in the qp_init_attr changes the interface from one that
just works to one that is arcane, and prone to generate hard to
detect errors (passing a 0 port_num will just work for all current
drivers, but if someone at some point actually introduces different
capabilities for differnet ports it will break for just that case!)
