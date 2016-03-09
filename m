From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v4 1/9] IB/cma: pass the port number to ib_create_qp
Date: Wed, 9 Mar 2016 16:52:08 +0100
Message-ID: <20160309155208.GA1878@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-2-git-send-email-hch@lst.de> <20160308192709.GJ13396@leon.nu> <017b01d17972$11e5a3b0$35b0eb10$@opengridcomputing.com> <20160308195514.GK13396@leon.nu> <20160309135804.GA32315@lst.de> <00a901d17a1b$890559f0$9b100dd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00a901d17a1b$890559f0$9b100dd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2016 at 09:51:25AM -0600, Steve Wise wrote:
> While I'm for keeping your change as-is, it turns out the port numbers
> are 1 relative, so 0 could be treated as an error. From
> read_port_immutable():

I'll add a check for 0, but will keep things as-is otherwise.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
