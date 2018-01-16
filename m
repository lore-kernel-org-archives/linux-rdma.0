From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iscsi_iser: Re-enable 'iser_pi_guard' module parameter
Date: Mon, 15 Jan 2018 21:57:07 -0500
Message-ID: <yq1r2qqy0ho.fsf@oracle.com>
References: <1515575256-9949-1-git-send-email-hare@suse.de>
        <20180110230240.GR4518@ziepe.ca>
        <CY4PR0601MB35860D768905FF165DB99A048C160@CY4PR0601MB3586.namprd06.prod.outlook.com>
        <a3d8060a-3926-0ba1-8963-b66d37172027@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a3d8060a-3926-0ba1-8963-b66d37172027-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> (Sagi
        Grimberg's message of "Sun, 14 Jan 2018 11:34:20 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "Schremmer, Steven" <Steve.Schremmer-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Sagi,

> Isn't a bit backwards that each individual driver needs this knob to
> modify the block layer behavior? I think a better approach would be to
> get rid of the drivers modparams and simply add a block sysfs knob
> that would take the knob guard if supported...

Originally the IP checksum thing was an optimization for a single
device. But others adopted it as well so it grew from being a driver
tweak to a common feature.

I don't have a problem adding a way to toggle it at the block layer. But
it would have to be an additional knob. We can't nuke the module
parameters without breaking a ton of stuff...

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
