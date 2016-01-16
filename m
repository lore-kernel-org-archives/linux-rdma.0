From: Leon Romanovsky <leon@leon.nu>
Subject: Re: InfiniBand-ocrdma: Delete unnecessary variable initialisations
 in 11 functions
Date: Sat, 16 Jan 2016 08:18:43 +0200
Message-ID: <20160116061843.GE32346@leon.nu>
References: <5697D865.5010507@users.sourceforge.net>
 <5697DE31.9040309@users.sourceforge.net>
 <20160115132014.GC30615@leon.nu>
 <56990733.7000506@users.sourceforge.net>
 <20160115150935.GA32346@leon.nu>
 <56990FAC.6000506@users.sourceforge.net>
 <20160115155938.GB32346@leon.nu>
 <56991D52.8030808@users.sourceforge.net>
 <20160115170048.GC32346@leon.nu>
 <56993833.2050809@users.sourceforge.net>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56993833.2050809@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 15, 2016 at 07:19:31PM +0100, SF Markus Elfring wrote:
> > [Q.] What did you try to achieve by this patch?
> 
> I would appreciate a bit more fine-tuning in the affected source files.

Please provide the numbers BEFORE and AFTER your change which can
support that your so called "fine-tuning" worked.

We are waiting to see it together with Tested-By tag to emphasize
that your code was tested on real HW and passed minimal sanity checks.

NAK on this patch.
