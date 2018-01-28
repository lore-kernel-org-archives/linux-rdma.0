From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 0/3] IB-iSER: Adjustments for three function
 implementations
Date: Sun, 28 Jan 2018 16:41:16 +0200
Message-ID: <5b2d2862-5694-a10a-be3e-17d2f4687d1e@mellanox.com>
References: <00e8b16f-c856-8999-fe93-2724a2f6a56e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00e8b16f-c856-8999-fe93-2724a2f6a56e@users.sourceforge.net>
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 1/27/2018 8:17 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 27 Jan 2018 19:02:34 +0100
> 
> Three update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (3):
>    Delete an error message for a failed memory allocation in iser_send_data_out()
>    Delete an unnecessary variable initialisation in iser_send_data_out()
>    Combine substrings for three messages
> 
>   drivers/infiniband/ulp/iser/iser_initiator.c | 16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
> 

This series looks good to me,

Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
