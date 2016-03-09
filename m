From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v4 1/9] IB/cma: pass the port number to ib_create_qp
Date: Wed, 9 Mar 2016 09:51:25 -0600
Message-ID: <00a901d17a1b$890559f0$9b100dd0$@opengridcomputing.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-2-git-send-email-hch@lst.de> <20160308192709.GJ13396@leon.nu> <017b01d17972$11e5a3b0$35b0eb10$@opengridcomputing.com> <20160308195514.GK13396@leon.nu> <20160309135804.GA32315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160309135804.GA32315-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Tue, Mar 08, 2016 at 09:55:14PM +0200, Leon Romanovsky wrote:
> > > At the expense of replicating this code and forcing all users to
> remember to set this.
> >
> > There are no much such users to update, these users need to set
> > qp_init_attr structure anyway.
> 
> But they need to extract the port_num first, while we already get
> the cm_id that has the right port_id passed to this function.  Not
> setting it in the qp_init_attr changes the interface from one that
> just works to one that is arcane, and prone to generate hard to
> detect errors (passing a 0 port_num will just work for all current
> drivers, but if someone at some point actually introduces different
> capabilities for differnet ports it will break for just that case!)

While I'm for keeping your change as-is, it turns out the port numbers
are 1 relative, so 0 could be treated as an error. From
read_port_immutable():


        /**
         * device->port_immutable is indexed directly by the port number
to make
         * access to this data as efficient as possible.
         *
         * Therefore port_immutable is declared as a 1 based array with
         * potential empty slots at the beginning.
         */
        device->port_immutable = kzalloc(sizeof(*device->port_immutable)
                                         * (end_port + 1),
                                         GFP_KERNEL);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
