From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [0/2] RDMA/bnxt_re: Adjustments for bnxt_qplib_alloc_dpi_tbl()
Date: Mon, 29 Jan 2018 10:31:04 +0100
Message-ID: <fe3d92c5-8e51-ea72-7637-6545c1654dd3@users.sourceforge.net>
References: <19c755a6-8c52-bbd5-a425-48fc08cecd4f@users.sourceforge.net>
 <CANjDDBgyX0d7=5YvgYLew04ODn4hZhfLbvUbvP1BviiEOGWkJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANjDDBgyX0d7=5YvgYLew04ODn4hZhfLbvUbvP1BviiEOGWkJQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@broadcom.com>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Selvin Xavier <selvin.xavier@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-rdma@vger.kernel.org

> You don't need 2 patches when changing same lines of code.

Are these really the same?


> Could you squash both and send your changes in a single patch.

I prefer to keep the deletion of questionable error messages separate
from the refactoring for a bit of exception handling.


> The patches look good to me otherwise.

Thanks for your constructive feedback.

Regards,
Markus
