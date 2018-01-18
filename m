From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iscsi_iser: Re-enable 'iser_pi_guard' module parameter
Date: Wed, 17 Jan 2018 21:04:49 -0500
Message-ID: <yq18tcvsz0e.fsf@oracle.com>
References: <1515575256-9949-1-git-send-email-hare@suse.de>
        <20180110230240.GR4518@ziepe.ca>
        <CY4PR0601MB35860D768905FF165DB99A048C160@CY4PR0601MB3586.namprd06.prod.outlook.com>
        <a3d8060a-3926-0ba1-8963-b66d37172027@grimberg.me>
        <yq1r2qqy0ho.fsf@oracle.com>
        <22838a0f-29d5-7351-12d3-05a0948fd0ba@suse.com>
        <yq1d129ul4d.fsf@oracle.com>
        <651bc1dd-f019-637c-1f76-07938b3041ce@grimberg.me>
        <CY4PR0601MB3586E4314AF5B70DDA8F381A8CE90@CY4PR0601MB3586.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR0601MB3586E4314AF5B70DDA8F381A8CE90-HWnCAiYGO2rYxEunYmvS1/tZqYE1FQh9nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
        (Steven Schremmer's message of "Wed, 17 Jan 2018 20:43:19 +0000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Schremmer, Steven" <Steve.Schremmer-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Steven,

> If the target uses CRC, the host will need a way to match.  AFAIK,
> there is no way in the SCSI protocol to determine this,

The IP checksum feature is entirely DIX, so no.

There is no guard format feature discovery taking place since only the
initiator supports IP checksum. It is always T10 CRC on the wire between
initiator and target on SAS/FC.

> This patch would restore the previous knob which meets the need
> for now. If a better method is developed in the future, then great.

I'm not against moving the checksum selection up the stack in
principle. But it's a lot of churn for little gain, IMHO. So I think I'm
in favor of reviving the iser_pi_guard parameter. At least in the short
term.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
