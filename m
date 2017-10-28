From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Sat, 28 Oct 2017 09:39:44 +0200
Message-ID: <cd1c87f8-84f5-ccff-2bf3-9c46de3c0f5e@users.sourceforge.net>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <20171027193902.GJ16127@mtr-leonro.local>
 <5cc2ecf7-cc6e-76e0-c73b-08ce717fef83@users.sourceforge.net>
 <7c5a7827-209c-9bb7-5b77-ac62d3d54604@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <7c5a7827-209c-9bb7-5b77-ac62d3d54604@intel.com>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

>> I guess that the shown change possibility can reduce the object code size
>> for the affected function.
…
> You guess?

I am convinced somehow!

 
> Well perhaps you should find out for certain.

I am trying to point another general implementation detail out:
A jump to an existing call of a function like “mlx4_free_cmd_mailbox”
can be useful if you would like to optimise also this software for
smaller code size.

Are you looking for an information source which you would trust
more (than me)?


> Is it an appreciable impact?

I hope so.

But I showed only the replacement of two function calls here.
I am curious if you care for a small effect at a special place.

A similar refactoring can have a bigger influence in other
software modules, can't it?


There might be an other useful side effect. My concrete proposal
can be questionable as usual.
It seems that the software development attention was increased
a bit so that contributors started thinking about the relevance
of the error code “-EINVAL” at another source code place again.

Regards,
Markus
