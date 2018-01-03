From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: ethernet: mlx4: Delete an error message for a failed memory
 allocation in five functions
Date: Wed, 3 Jan 2018 15:22:03 +0100
Message-ID: <d693dbdb-f3a2-5194-07e9-7c56e9ccbb2b@users.sourceforge.net>
References: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net>
 <0fea8f2f-f8fc-ce2e-3d33-44227de3637a@mellanox.com>
 <alpine.DEB.2.20.1801030904290.5305@hadrien>
 <adfc3229-d3f9-afb9-00e6-9f765af0cbe8@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <adfc3229-d3f9-afb9-00e6-9f765af0cbe8@mellanox.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> I don't really accept this claim...
> Short informative strings worth the tiny space they consume.

There can be different opinions for their usefulness.


> In addition, some out-of-memory errors are recoverable, even though their backtrace is also printed.

How do you think about to suppress the backtrace generation for them?


> For example, in function mlx4_en_create_cq (appears in patch) we have a first allocation attempt (kzalloc_node)

Would it be helpful to pass the option “__GFP_NOWARN” there?


> and a fallback (kzalloc). I'd prefer to state a clear error message only when both have failed,
> because otherwise the user might be confused whether the backtrace should indicate a malfunctioning interface, or not.

Can the distinction become easier by any other means?

Regards,
Markus
