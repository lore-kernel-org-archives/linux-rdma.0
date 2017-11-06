From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] RDMA/bnxt_re: Add memory barriers when processing
 CQ/EQ entries
Date: Mon, 6 Nov 2017 23:33:10 +0530
Message-ID: <CA+sbYW1yjzO4-hJCLPPKg_sduKP0kpLBXngpU+SoBoTc+r4wZw@mail.gmail.com>
References: <1509984452-18336-1-git-send-email-selvin.xavier@broadcom.com>
 <1509984452-18336-2-git-send-email-selvin.xavier@broadcom.com> <20171106171925.GB18802@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106171925.GB18802-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 6, 2017 at 10:49 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Mon, Nov 06, 2017 at 08:07:29AM -0800, Selvin Xavier wrote:
>> From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>
>> The code determines if the next ring entry is valid before proceeding
>> further to read the rest of the entry. The CPU can re-order and read
>> the rest of the entry first, possibly reading a stale entry, if DMA
>> of a new entry happens right after reading it.
>
> Please make sure the bnxt user space stuff in rdma-core does not have the
> same problem...
Sure..  will do the necessary changes in user space driver also.
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
