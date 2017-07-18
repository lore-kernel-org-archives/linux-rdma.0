From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 18 Jul 2017 12:26:57 -0700
Message-ID: <CA+55aFxYrrWO0NFJLzMiSQxPKMcoLUD=xA0e-g01riFfX5-Vug@mail.gmail.com>
References: <1500393061.23761.1.camel@redhat.com> <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg@mail.gmail.com>
 <1500404869.23761.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500404869.23761.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 18, 2017 at 12:07 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Fair enough.  My branch still had two unpulled commits and was based on
> v4.12-rc3.  But, you had already taken the SELinux/RDMA patches through
> the SELinux tree during this merge window, and two of the fix  patches
> in my pull request would have produced conflicts for you if I didn't
> merge up to a common ancestor that had the SELinux/RDMA patches prior
> to applying those patches to my tree (these two in particular):

Please don't worry about conflicts, unless they are something really
really fundamentally hard to merge. And even then, for rdma, I
probably want to see them, just to see what the hell went wrong *this
time*.

>> And if the only reason for that merge is "sync with upstream", then
>> no, that is not a sufficient reason. It has to have an actual real
>> reason, and it needs to be stated.
>
> Does this apply to the for-next area as well?

Largely, yes. Because the further away "for-next" gets from what you
then eventually send me, if your for-next branch has odd useless
merges, then either what you send me will have them too, or what you
send me will be something entirely different and rebased.

Basically, "automated merges" is wrong and bad. The ACPI people used
to do them, and at some point their pull requests had more merge
commits than they had actual changes.

Merges should be generally *minimized*. They make it much harder to
see what is actually your new independent work, and what is work that
is on top of random other things.

Regular automated merges is exactly the wrong thing to do, because it
basically guarantees that you don't have a nice stand-alone
development series (everything you do will be punctuated by those
merges), _and_ that the merge commits are bad and have no good reason
for them.

Finally, the merges have a fundamental problem that is from past
problems with rdma - in particular the history of mixing stuff up and
having teams within one single company not even being able to talk or
synchronize with each other.

If you need merges for conflict resolution, it indicates to me that
rdma *still* has that issue where people fight over the direction and
the drivers between different teams.

So while merges in general are something that should be avoided, when
it comes to rdma in _particular_ I don't like seeing them, because I
get the feeling that they are papering over the nasty development
problems you guys have had, and are done as a way to handle the
conflicts that were due to bad hygiene.

So the *one* kind of merge that is good is the "development of this
topic branch is finished and done, let's merge it up". But that is
never about time, that's about "I'm done with this series, it's good
to go into my main branch". That's a "forward merge", where you really
merge the new and finished development tree into the base.

The back-merges, when you merge some unrelated development, is
generally a bad sign. It inevitably happens for various reasons, but
it should be seen as the exception, not the rule, and it should
*always* have an explanation.

                      Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
