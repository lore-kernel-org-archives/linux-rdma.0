From: Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH] IB/rxe: double free on error
Date: Wed, 8 Mar 2017 18:44:15 +0200
Message-ID: <CAG9sBKNE1gm+WfXmsg1GR8n-VspMHtm-CHKCxBwHVEjhMA8OVg@mail.gmail.com>
References: <20170308052152.GA31503@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170308052152.GA31503@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 8, 2017 at 7:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> "goto err;" has it's own kfree_skb() call so it's a double free.  We
> only need to free on the "goto exit;" path.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static analysis.  Not tested.  Please review carefully.

Ack-by: Moni Shoua <monis@mellanox.com>
