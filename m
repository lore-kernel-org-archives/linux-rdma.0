From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: IB/core: Fine-tuning for ib_is_udata_cleared()
Date: Mon, 22 Aug 2016 11:46:55 +0200
Message-ID: <1471859215.2764.24.camel@opteya.com>
References: <566ABCD9.1060404@users.sourceforge.net>
         <f7bb3caf-81cd-fba9-afc8-5fac72b8a4b3@users.sourceforge.net>
         <1471802623.3746.1.camel@perches.com>
         <683187e0-2e6a-88c0-f87a-9c5f0489370a@users.sourceforge.net>
         <1471809188.3746.18.camel@perches.com>
         <5e87f691-edb9-0a12-ff7a-59854c2ca2f8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5e87f691-edb9-0a12-ff7a-59854c2ca2f8@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Joe Perches <joe@perches.com>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 21 août 2016 à 22:15 +0200, SF Markus Elfring a écrit :
> > 
> > > 
> > > > 
> > > > Don't introduce a defect in patch 1 and correct
> > > > that introduced defect in patch 2.
> > > Which detail do you not like here?
> > 
> > See above.
> 
> This feedback is not clearer.
> 

It's clear enough: your second patch fixes an issue you introduced in
your first patch by removing the code which made use of the ret
initialization value:

-       if (copy_from_user(buf, p, len))
-               goto free;

> I find that the two update steps should work in principle,
> shouldn't they?
> 

It would be better to squash them here.

Regards.

-- 
Yann Droneaud
OPTEYA
