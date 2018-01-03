From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] ethernet: mlx4: Delete an error message for a failed
 memory allocation in five functions
Date: Wed, 3 Jan 2018 09:06:01 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801030904290.5305@hadrien>
References: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net> <0fea8f2f-f8fc-ce2e-3d33-44227de3637a@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0fea8f2f-f8fc-ce2e-3d33-44227de3637a@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On Wed, 3 Jan 2018, Tariq Toukan wrote:

>
>
> On 01/01/2018 10:46 PM, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Mon, 1 Jan 2018 21:42:27 +0100
> >
> > Omit an extra message for a memory allocation failure in these functions.
> >
> > This issue was detected by using the Coccinelle software.
> >
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
>
> Is this an issue? Why? What is your motivation?
> These are error messages, very informative, appear only upon errors, and in
> control flow.

Strings take up space.  Since there is a backtrace on an out of memory
problem, if the string does not provide any more information than the
position of the call, then there is not much added value.  I don't know
what was the string in this case.  If it provides some additional
information, then it would be reasonable to keep it.

julia

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
