From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] iscsi_iser: Re-enable 'iser_pi_guard' module parameter
Date: Wed, 17 Jan 2018 11:59:06 +0200
Message-ID: <651bc1dd-f019-637c-1f76-07938b3041ce@grimberg.me>
References: <1515575256-9949-1-git-send-email-hare@suse.de>
 <20180110230240.GR4518@ziepe.ca>
 <CY4PR0601MB35860D768905FF165DB99A048C160@CY4PR0601MB3586.namprd06.prod.outlook.com>
 <a3d8060a-3926-0ba1-8963-b66d37172027@grimberg.me>
 <yq1r2qqy0ho.fsf@oracle.com> <22838a0f-29d5-7351-12d3-05a0948fd0ba@suse.com>
 <yq1d129ul4d.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1d129ul4d.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Cc: "Schremmer, Steven" <Steve.Schremmer-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hannes,
> 
>> Do we need to keep the parameter?
>> If so we really should be re-enable it; ATM it's just a no-op leading
>> the user to believe something has actually happened.
> 
> The driver module parameters existed mainly for the purpose of hw
> testing. One could disable IP checksum and revert to CRC to ensure both
> code paths were working properly. But it wasn't really meant to be
> something ordinary users would ever muck with. Why would anybody use the
> much slower CRC when IP checksum was supported by the hardware? (*)

Agree, but I definitely might not see the full picture here.

> Anyway. I think Sagi's iser_pi_guard patch was a result of that
> transition from driver global checksum setting to per-I/O ditto.

Correct, and due to your comment above.

> I don't have a problem with having a block-level preference knob
> (slightly convoluted to implement since they are different integrity
> profiles). But I do question whether it is worth the hassle. What
> exactly is your use case that requires twiddling this?

I'm not sure its worth it either, I can easily ack this one if that's
the case.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
