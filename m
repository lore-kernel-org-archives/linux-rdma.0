From: Moni Shoua <monis@mellanox.com>
Subject: Re: [patch] IB/rxe: fix error code in rxe_srq_from_init()
Date: Mon, 13 Jun 2016 10:24:30 +0300
Message-ID: <CAG9sBKN-XzPvhpFgxiBpB7FW6c0+PP7uF74zD4Had+368G9ViA@mail.gmail.com>
References: <20160613065341.GA5993@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160613065341.GA5993@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 13, 2016 at 9:53 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> If copy_to_user() fails then it returns the number of bytes not copied.
> It would be between 1-4 here.  Later the callers dereference it leading
> to an Oops.
>
> It was sort of hard to fix this without making the code confusing so I
> did a little cleanup.
>
> Fixes: 443c15d23220 ('IB/rxe: Shared Receive Queue (SRQ) manipulation functions')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan
I'll merge it to next series
