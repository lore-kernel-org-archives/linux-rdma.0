From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/6] treewide: Add and use dev_fmt similar to pr_fmt
Date: Wed, 09 May 2018 10:04:50 -0700
Message-ID: <ee5a0e0065047cd4d1da340f6ee924f3a31b0fac.camel@perches.com>
References: <cover.1525878372.git.joe@perches.com>
         <4a397208-bd6c-a6c3-c161-4de8579ca17e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4a397208-bd6c-a6c3-c161-4de8579ca17e@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: minyard@acm.org, openipmi-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-05-09 at 11:47 -0500, Corey Minyard wrote:
> On 05/09/2018 10:15 AM, Joe Perches wrote:
> > The pr_fmt mechanism exists for pr_<level> logging message prefixing,
> > but no similar capability exists for dev_<level> message prefixing.
> > 
> > Many uses of dev_<level> have an embedded prefix for logging output.
> > 
> > So add a similar dev_fmt macro that can automatically prefix the
> > dev_<level> logging output.
> > 
> > Rename the existing dev_<level> functions to _dev_<level> and add new
> > macros that call _dev_<level> with the desired prefix if defined.
> > 
> > The new default #define for dev_fmt is blank.
> > 
> > Convert ipmi and infiniband to use this mechanism.
> 
> The IPMI changes look good to me.

Oh good.

> There are some conflicts with a patch I have pulling out the proc 
> interface that is destined for 3.18.

I'm sure you mean 4.18.

> I can take the IPMI changes into my tree, if you want.

These patches are not at all urgent and were done
on top of next-20180509.

As there are dependencies between the patch that
introduces dev_fmt and the reset of the patches,
I think it makes sense to take these as a single
patchset rather than take parts into various trees.

Respinning the IPMI patches is trivial and can be
done whenever appropriate.

When do you expect your IPMI patches to hit -next?
