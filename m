From: Moni Shoua <monis@mellanox.com>
Subject: Re: [patch] IB/rxe: Remove unneeded cast in rxe_srq_from_attr()
Date: Thu, 17 Nov 2016 15:51:17 +0200
Message-ID: <CAG9sBKO3HzYV1w1=0oOEOGd8O3M6AUTTJpRY63YoeVjAOHUifw@mail.gmail.com>
References: <20161117110005.GB32143@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161117110005.GB32143@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 17, 2016 at 1:00 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> It makes me nervous when we cast pointer parameters.  I would estimate
> that around 50% of the time, it indicates a bug.  Here the cast is not
> needed becaue u32 and and unsigned int are the same thing.  Removing the
> cast makes the code more robust and future proof in case any of the
> types change.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Moni Shoua <monis@mellanox.com>
