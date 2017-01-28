From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] IB/cma: Fix reversed test
Date: Sat, 28 Jan 2017 09:59:27 +0300
Message-ID: <20170128065927.GP4149@mwanda>
References: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
 <1485552696.13218.0.camel@sandisk.com>
 <1485561952.2432.31.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485561952.2432.31.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 27, 2017 at 07:05:52PM -0500, Doug Ledford wrote:
> > Do you think this patch needs "Fixes:" and "Cc: stable" tags?
> 
> It does not.

We always should have fixes tags.

When I'm reviewing, I try to look up the patch which introduced the bug
so I can figure out what the intent was.  Having a Fixes tag speeds up
my work.

Looking at how the bug was introduced sometimes helps to prevent bugs
from recurring in the future.  For example, I've seen several bugs
introduced because the right people weren't on the CC to review it.  For
this particular bug it feels like probably this bug could have been
detected with more testing.  I doubt it would have made it into a
released kernel.

Also it let's you CC the original authors and hopefully they can Ack it.

regards,
dan carpenter
