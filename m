From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 18 Jul 2017 15:07:49 -0400
Message-ID: <1500404869.23761.9.camel@redhat.com>
References: <1500393061.23761.1.camel@redhat.com>
         <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-07-18 at 11:24 -0700, Linus Torvalds wrote:
> On Tue, Jul 18, 2017 at 8:51 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > 
> > This is the first round of fixes for the -rc cycle.
> 
> Pulled. However, I want to complain (again!) about bad merge commits.
> 
> You're not the only one doing this, so this is not rdma-specific, but
> I complain when I notice.
> 
> There's a merge commit in there that has no explanation. This is the
> totality of the commit message:
> 
>     Merge tag 'v4.13-rc1' into k.o/for-4.13-rc
> 
>     Linux v4.13-rc1
> 
> and I want to point out that there is *nothing* there that explains
> why that merge exists.

Fair enough.  My branch still had two unpulled commits and was based on
v4.12-rc3.  But, you had already taken the SELinux/RDMA patches through
the SELinux tree during this merge window, and two of the fix  patches
in my pull request would have produced conflicts for you if I didn't
merge up to a common ancestor that had the SELinux/RDMA patches prior
to applying those patches to my tree (these two in particular):

f7c8f2e9ddc7 IB/uverbs: Make use of ib_modify_qp variant to avoid
resolving DMAC
a512c2fbef9c IB/core: Introduce modify QP operation with udata

So I didn't want to abandon the branch with those commits in them,
hence I did the forward merge and then proceeded with applying the
commits for you to pull.

> A merge? There *has* to be an explanation for why the merge exists.
> What problem did that merge fix? Why was it done in the first palce?
>
> And if the only reason for that merge is "sync with upstream", then
> no, that is not a sufficient reason. It has to have an actual real
> reason, and it needs to be stated.

Does this apply to the for-next area as well?  In particular, I was
planning on changing my process so that my for-next branch would
regularly sync with tagged rc releases (I believe this is what Dave
Miller does with his tree, or else he's getting updates to later -rcs
by pulling from other people, but I know I see merge commits for your
-rc releases in his history when I go scanning through it).  This is
how I intended to get the -rc fixes I send you into my for-next area so
that for-next development is against the RDMA subsystem as it exists
including the -rc fixes, and not as it existed when I branched off the
for-next branch.  I can merge my -rc branch instead if that is
preferred, and only merge the -rcs if I need one for a specific out-of-
RDMA area feature for building against.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
