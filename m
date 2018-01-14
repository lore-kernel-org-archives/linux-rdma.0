From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] iscsi_iser: Re-enable 'iser_pi_guard' module parameter
Date: Sun, 14 Jan 2018 11:34:20 +0200
Message-ID: <a3d8060a-3926-0ba1-8963-b66d37172027@grimberg.me>
References: <1515575256-9949-1-git-send-email-hare@suse.de>
 <20180110230240.GR4518@ziepe.ca>
 <CY4PR0601MB35860D768905FF165DB99A048C160@CY4PR0601MB3586.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR0601MB35860D768905FF165DB99A048C160-HWnCAiYGO2rYxEunYmvS1/tZqYE1FQh9nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Schremmer, Steven" <Steve.Schremmer-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Steven and Hannes,

>> On Wed, Jan 10, 2018 at 10:07:36AM +0100, Hannes Reinecke wrote:
>>> The module parameter 'iser_pi_guard' has been disabled by commit
>>> 5bb6e543d2a7d58 ("IB/iser: DIX update"), but the functionality
>>> to select the guard algorithm is still required.
>>
>> Commit should explain why it is still required? What is the actual bug here?
>>
>> Someone who understands this is going to have to Ack it for it to go
>> through the rdma tree..
>>
> Without the module parameter, there is no way to actually use the CRC guard format.
> Currently, iscsi_iser_session_create() indicates support for both IP and CRC formats, but
> sd_dif_config_host() always checks for IP support first, so CRC guard won't be used.

Isn't a bit backwards that each individual driver needs this knob to
modify the block layer behavior? I think a better approach would be to
get rid of the drivers modparams and simply add a block sysfs knob that
would take the knob guard if supported...

Thoughts?

CCing Martin...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
