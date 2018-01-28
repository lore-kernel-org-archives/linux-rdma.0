From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] IB-iSER: Adjustments for three function
 implementations
Date: Sun, 28 Jan 2018 14:10:50 -0700
Message-ID: <20180128211050.GM23869@ziepe.ca>
References: <00e8b16f-c856-8999-fe93-2724a2f6a56e@users.sourceforge.net>
 <5b2d2862-5694-a10a-be3e-17d2f4687d1e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5b2d2862-5694-a10a-be3e-17d2f4687d1e@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 04:41:16PM +0200, Max Gurtovoy wrote:
> 
> 
> On 1/27/2018 8:17 PM, SF Markus Elfring wrote:
> >From: Markus Elfring <elfring@users.sourceforge.net>
> >Date: Sat, 27 Jan 2018 19:02:34 +0100
> >
> >Three update suggestions were taken into account
> >from static source code analysis.
> >
> >Markus Elfring (3):
> >   Delete an error message for a failed memory allocation in iser_send_data_out()
> >   Delete an unnecessary variable initialisation in iser_send_data_out()
> >   Combine substrings for three messages
> >
> >  drivers/infiniband/ulp/iser/iser_initiator.c | 16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> >
> 
> This series looks good to me,
> 
> Reviewed-by: Max Gurtovoy <maxg@mellanox.com>

Okay, applied to for-next, thanks both

Jason
