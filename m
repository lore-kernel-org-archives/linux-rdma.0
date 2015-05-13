From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Wed, 13 May 2015 17:46:04 +0300
Message-ID: <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	<1431485563.43876.93.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431485563.43876.93.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 13, 2015 at 5:52 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2015-05-12 at 21:31 +0000, Hefty, Sean wrote:
>> Doug,
>>
>> Do you plan on only using your kernel.org tree going forward, or will you maintain your github tree as well?
>
> I plan to keep both repos.  The one on github will have stuff sooner,
> but it is likely that portions of it will see rebases.  I've taken to a
> very obvious branch naming scheme if I think that I'm going to rebase a
> branch.  I'm also keeping the github repo as the one I have in the 0day
> testing framework so that more of the stuff gets tested sooner.
>
> When I'm satisfied that a branch has passed all of the 0day testing and
> I'm no longer going to consider any changes to the patches in that
> branch, then I'll make a k.o/<branchname> branch and I only push those
> branches to the kernel.org repo.  Once a branch lands there, it is a
> fast-forward only branch and will not see any rebases or edits of
> patches.
>
> I'm doing this because of the large number of interrelated patches that
> different people are working on right now.  This makes it easier for
> people to be able to base their work off of the latest interrelated
> patches from other people.  Once this backlog clears out, it might be
> possible for me to drop the github repo.  Right now it's the only way I
> have to provide the sort of early access sandbox that people need to get
> their patches in without taking too many consecutive release cycles.

Doug,

Still, as things are now, you've already accepted patches for 4.2
which are dependent on other patches which you've accepted too (e.g
Ira's patches on top of Michael's patches) --> @ this point (post
4.1-rc3) **something** has to be in your kernel.org branch for 4.2 --
else the chain of dependencies can become really non-traceable.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
