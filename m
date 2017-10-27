From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Fri, 27 Oct 2017 22:53:18 +0200
Message-ID: <5cc2ecf7-cc6e-76e0-c73b-08ce717fef83@users.sourceforge.net>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <20171027193902.GJ16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027193902.GJ16127@mtr-leonro.local>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> This change adds nothing except code churn.

I guess that the shown change possibility can reduce the object code size
for the affected function.
Do you care for such an detail?

Regards,
Markus
