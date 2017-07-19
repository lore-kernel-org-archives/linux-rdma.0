From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 19 Jul 2017 13:46:18 -0400
Message-ID: <1500486378.23761.12.camel@redhat.com>
References: <1500393061.23761.1.camel@redhat.com>
         <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg@mail.gmail.com>
         <1500404869.23761.9.camel@redhat.com>
         <CA+55aFxYrrWO0NFJLzMiSQxPKMcoLUD=xA0e-g01riFfX5-Vug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFxYrrWO0NFJLzMiSQxPKMcoLUD=xA0e-g01riFfX5-Vug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-07-18 at 12:26 -0700, Linus Torvalds wrote:
> On Tue, Jul 18, 2017 at 12:07 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > 
> > Fair enough.  My branch still had two unpulled commits and was
> > based on
> > v4.12-rc3.  But, you had already taken the SELinux/RDMA patches
> > through
> > the SELinux tree during this merge window, and two of the
> > fix  patches
> > in my pull request would have produced conflicts for you if I
> > didn't
> > merge up to a common ancestor that had the SELinux/RDMA patches
> > prior
> > to applying those patches to my tree (these two in particular):
> 
> Please don't worry about conflicts, unless they are something really
> really fundamentally hard to merge. And even then, for rdma, I
> probably want to see them, just to see what the hell went wrong *this
> time*.

There wasn't anything wrong.  Not every conflict is a failure of
development hygiene as you call it below.  It's just that the SELinux
patches touched a lot of entry points...*not* conflicting with them
would have been more of a magic trick.

> > > And if the only reason for that merge is "sync with upstream",
> > > then
> > > no, that is not a sufficient reason. It has to have an actual
> > > real
> > > reason, and it needs to be stated.
> > 
> > Does this apply to the for-next area as well?
> 
> Largely, yes. Because the further away "for-next" gets from what you
> then eventually send me, if your for-next branch has odd useless
> merges, then either what you send me will have them too, or what you
> send me will be something entirely different and rebased.

I asked this question because I was going to try doing one continuous
branch for ongoing future development.  In that case, at an absolute
minimum, one merge is required to get from one development window to
the next.  However, in addition to that one merge, I would argue that
one of these two things should also be done:

1) I *should* merge the prior release's for-rc area into my for-next
branch on an as-needed basis.  This is so that we are developing and
testing against a complete RDMA subsystem, not the RDMA subsystem as it
was at -rc1 or -rc2 when we branched with all its bugs still intact.

or, optionally

2) I could merge the prior release's rc tags.  It serves the same
purpose (getting any -rc fixes I've sent you into the development
branch), but also serves the purpose of getting other subsystem's fixes
in as well so we won't be fighting against other bugs in our
development and testing (this aspect is highly relevant with the net
subsystem because of how tightly tied our subsystems are).

So, anyway, I still either have to branch off a new branch when I open
my for-next area at each cycle, or I have to merge up to a current
kernel.  I'll stick with creating a new branch as it keeps the merge
count down by one.  I also still see value in option #2 above, even if
you don't.  I'll avoid it, but I do so noting my dissenting opinion.

> Finally, the merges have a fundamental problem that is from past
> problems with rdma - in particular the history of mixing stuff up and
> having teams within one single company not even being able to talk or
> synchronize with each other.

Yes, some bad submissions happened in the past.  There were two
egregiously bad examples.  Remember, though, that one of the things you
yelled at me for during that time was for being unaware of the issues. 
You made it clear that my job is to stay on top of these things and
make sure that they aren't happening again.  I can't do that if I'm not
pulling things together myself and making sure it's all good in the
end.

> If you need merges for conflict resolution, it indicates to me that
> rdma *still* has that issue where people fight over the direction and
> the drivers between different teams.

Conflicts happen, and they don't always indicate the issues that
happened in the past.  In fact, *most* of the time, they don't indicate
anything along those lines.  They're more an indicator of ongoing
development across the subsystem.  Major features, like SELinux support
and namespace support, and even less invasive series that went through
other trees like the RDMA cgroup support, are highly likely to conflict
with your average typical development or bug fixes.

> So while merges in general are something that should be avoided, when
> it comes to rdma in _particular_ I don't like seeing them, because I
> get the feeling that they are papering over the nasty development
> problems you guys have had, and are done as a way to handle the
> conflicts that were due to bad hygiene.

Aka, we're still on probation.  I'll merge things up on a test branch
and then throw it away.  If I don't do the merge ups and check things,
I'm not staying on top of the stack and doing my job.  But if I submit
the final product to you, then I'm preventing you from doing it
yourself.

> So the *one* kind of merge that is good is the "development of this
> topic branch is finished and done, let's merge it up". But that is
> never about time, that's about "I'm done with this series, it's good
> to go into my main branch". That's a "forward merge", where you
> really
> merge the new and finished development tree into the base.

It's only a forward merge if my "main branch" is ahead of, or at the
same base as, the development branch.  That hasn't been the case in the
last few cycles when I was merging a shared common Mellanox base that
was also in Dave's tree.  I've quit doing that effective now, so it
won't be an issue, but, when I was doing it, I did what you call a
back-merge because it cleaned up the subsequent merge from Dave and
made understanding what my tree contained possible.  Without it, it was
a nightmare concoction off in la la land.

> The back-merges, when you merge some unrelated development, is
> generally a bad sign. It inevitably happens for various reasons, but
> it should be seen as the exception, not the rule, and it should
> *always* have an explanation.

As I said above, pulling from Dave made it not so much an exception,
but a necessary pre-step to clean up the merge I got from him. 
Otherwise, it was impossible to sort out what was his, what was yours,
or where my tree now stood.

And in this particular case, remember that this was originally a branch
intended for 4.13-rc cycles, so it was based on 4.13-rc2 or rc3.  I
would argue that sending patches that are against 4.13-rc2 into a 4.14-
rc1 kernel, *as a maintainer*, is leaving too much to chance.  An
entire kernel of changes between your base and what you are submitting
too?  That seems irresponsible on my end.  That's the reason I didn't
document the back-merge on this pull request.  It seemed (and to be
honest, in spite of your comments, *still* seems) like the sane thing
to do prior to submitting a pull request into 4.14-rc1.  If I'm doing
*my* job, I should *know* how this code is going to interact with the
kernel I'm submitting it to.  Clearly, you would prefer I had done a
throw away branch instead of polluting my actual pull branch, but I
don't believe for a second that I should have left things to chance and
not verified how this code would interact with that kernel release
worth of changes.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
