From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
Date: Sat, 23 Sep 2017 11:03:25 -0400
Message-ID: <1506179005.120853.67.camel@redhat.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A75B9FB085-5FK+k9557ZBZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sending to list and changing subject because my answer raises an issue
that I need to make others aware of...

On Tue, 2017-09-19 at 18:34 +0000, Saleem, Shiraz wrote:
> Hi Doug,
> 
> Hope you're doing well and had a good vacation.
> 
> With respect to i40iw patch submissions, the typical workflow we have
> followed is to submit i40iw patches and patch series to the mailing
> list. And you pick them up from the mailing list after feedback.
> 
> If it makes sense and makes your life easier, I could send a pull
> request for the i40iw patches submitted to the mailing list.
> 
> The pull request would be sent at some point in the future (example
> +1 week) from submission to mailing list; after the patches have got
> a chance for community feedback. I could send it on a day of the week
> specified by you. 
> 
> Let me know what you think about this suggested workflow.

That won't make much difference.  I'm pretty efficient at patchworks. 
The only time it really helps is when you need to prepare a shared pull
request, and in that case, it *must* be a pull request.

So, what am I talking about with a shared pull request?

That's my answer to people not necessarily wanting to wait until kernel
n+1 to use features they put in their net driver in kernel n.  So, this
applies to the mlx4, mlx5, cxgb3, cxgb4, bnxt_re, hns_roce, and i40iw
drivers off the top of my head.

I have no intention of pulling Dave Miller's net-next tree on any sort
of regular basis.  I will admit that there are certain circumstances
where it can't be avoided (a specific case being if someone introduces
a new core net feature, and the only consumer of that feature is their
net driver, so they are required to submit both the feature and the
first consumer together, and then if their dependent rdma driver also
needs updating to work with the modified net driver, then I have no
choice but to take a snapshot of net-next with the new core feature and
update the rdma driver or else we might end up with a broken tree). 
Waiting on things to land in net-next takes too much time and
coordination, pulling his tree pollutes mine with tons of additional
patches beyond just what's needed, and doing so played a direct role in
me missing the 4.13 merge window (there were other factors too, so I'm
not saying it was the sole reason, but it was certainly a significant
one) so I'm reluctant to do this any more than absolutely necessary.

So, what I want as the normal, day to day workflow for drivers that
need to have dependent code in the RDMA stack based upon code in the
net-next area is shared pull requests instead.

There are requirements for submitting pull requests.  It is preferred
to have a tree either on k.o or some similar place, and it is required
by Linus that a pull request from any place other than kernel.org
*must* be a PGP signed tag (but even for pull requests on trees hosted
on kernel.org, he prefers to still use PGP signed tags), so any pull
request to Dave Miller and myself will have the same requirements.

Mellanox has been doing shared pull requests for a year or so now, so
feel free to look at the mailing list archives and find one of their
pull requests to see how they do it.  They list the pull request in the
cover letter and still send the patch series (unlike the pull request I
send to Linus which is just a cover letter and none of the patches).

I want any shared pull requests to be based on nothing newer than an
rc2 kernel.  I branch my for-next branch at rc2, so if your pull
request is on something later it will pollute my main for-next branch
to merge it.  I plan to merge my own -rc pull requests after rc2 into
my for-next branch, so you won't be missing code that goes into later
rcs if you base your work on my for-next branch, so that's a second
alternative starting point for your shared pull requests should you
need it.

All of this causes me to bring up another point as well.  For-next
testing.  I've sent an email to Stephen to change his setup.  Right
now, he only pulls my for-next tag, so in order to get for-next
testing, I have to put things under my for-next tag, and this can cause
confusion and make people think I've accepted things I haven't if I
want to get early testing on code that's still waiting to be approved. 
I've requested that he change his setup to pull all of my branches on
k.o that start with k.o/for-next, so I might have one official k.o/for-
next branch for the code that's accepted, then I might create a
k.o/for-next-mlx5-pending for a branch that isn't yet approved and
merged into for-next, but it would still get for-next testing.  So, my
point here is that people shouldn't make assumptions about branches on
k.o.  Unless I've mailed the list to say the patches are accepted,
their presence in a branch on k.o is simply for advanced for-next
testing.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
