From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 19 Jul 2017 20:40:31 +0000
Message-ID: <1500496830.2494.5.camel@wdc.com>
References: <1500393061.23761.1.camel@redhat.com>
         <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg@mail.gmail.com>
         <1500404869.23761.9.camel@redhat.com>
         <CA+55aFxYrrWO0NFJLzMiSQxPKMcoLUD=xA0e-g01riFfX5-Vug@mail.gmail.com>
         <CAANLjFr9DxfoR_H5rp1ag_fC5AqxDJ5ZEj52wF-W2eGjof6iqg@mail.gmail.com>
         <1500486883.23761.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500486883.23761.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <0CB6C7516239584AA7F5803DC030E7B6-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-07-19 at 13:54 -0400, Doug Ledford wrote:
> On Tue, 2017-07-18 at 21:42 -0600, Robert LeBlanc wrote:
> > On Tue, Jul 18, 2017 at 1:26 PM, Linus Torvalds
> > <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > > On Tue, Jul 18, 2017 at 12:07 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > > wrote:
> > > >=20
> > > >=20
> >=20
> > I'm trying to understand why merges are being done instead of
> > rebases.
> > Since we don't want to include other people's work, it seems that it
> > is cleaner to do a rebase. This is more for my education with using
> > Git with such a large project rather than me suggesting something
> > useful. (I dropped Linus from this part of the thread so as not to
> > bother him with an off-topic conversation).
>=20
> Rebases change the history of a patch.  If I commit a patch on July
> 7th, and then rebase on July 20th, the patch gets rewritten with the
> new date.  In addition, they get new commit hashes.  So if someone
> pulls my tree on the 9th, sees the commit hash for their patch, and
> then references it in an email or a bug report, then I rebase on the
> 20th, the old commit hash is gone and will be replaced with a new one.=20
> Finally, if someone pulls my tree on the 8th, and then again on the
> 22nd, and they don't know I've rebased it, the pull will attempt to put
> all of the new hashes on top of the old hashes for the same commits.=20
> It creates a ton of merge work that is error prone.  Sometimes chunks
> get added twice, stuff like that.
>=20
> There are a few things you can do to get around this, and I sometimes
> use those tricks.  I've declared on-list that my github repo is subject
> to being rebased at any time, so people know this.  I also have my
> github repo as the source for my 0day testing.  So, I can push to
> github, wait for 0day test results, and if there was a problem, I can
> fix it using a rebase of whatever patch was broken, repush to github,
> and repeat until 0day testing passes, and only then do I push to my
> kernel.org repo, which is taken to be involate and rebases are
> forbidden.  But even there, if I *really* have to, I can rebase by
> deleting the branch I originally created and creating a new branch with
> the rebase on it under a different name.  That prevents someone from
> accidentally pulling the rebase on top of a previous pull.  But I
> *really* try to avoid that.

Hello Doug,

Rebases do not only change the commit ID of a patch but can also change the
patch itself. If e.g. a patch (a) that was posted on the linux-rdma mailing
list contains two changes and a patch (b) contains only one of two changes,
if the rdma tree gets rebased on top of a tree that has patch (b) then the
rebase will modify patch (a) such that only the changes that were not in
patch (b) remain. git will neither complain about this nor report it. Since
a rebase can modify a patch it also invalidates any testing and reviews for
that patch. This why Linus hates rebases and why nowadays Linus refuses to
accept any pull requests of trees that have been rebased. I hope I
misunderstood you but if you are routinely rebasing branches with patches
that come from the linux-rdma mailing list please stop doing this.

A model that some other kernel maintainers (e.g. Jens Axboe) follow is as
follows:
* Maintain one branch per pull request that will be sent to Linus, e.g.
  for-4.13/block. Never rebase this branch, never rewrite its history and
  only merge Linus' branch into this branch if absolutely necessary.
* Every time a patch has to be applied, use "git am" to apply it to the
  appropriate branch. Complain on the mailing list if "git am" complains.
  Add the maintainer Signed-off-by and edit the patch if this is considered
  necessary.
* Maintain a for-next branch that is the result of merging all branches tha=
t
  will be sent to Linus. Resolve any merge conflicts if necessary. Ensure
  that this branch is included in Steven Rostedt's linux-next tree and that
  it gets tested by the zero-day testing infrastructure.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
