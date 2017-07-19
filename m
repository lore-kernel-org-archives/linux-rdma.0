From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 19 Jul 2017 13:54:43 -0400
Message-ID: <1500486883.23761.14.camel@redhat.com>
References: <1500393061.23761.1.camel@redhat.com>
         <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg@mail.gmail.com>
         <1500404869.23761.9.camel@redhat.com>
         <CA+55aFxYrrWO0NFJLzMiSQxPKMcoLUD=xA0e-g01riFfX5-Vug@mail.gmail.com>
         <CAANLjFr9DxfoR_H5rp1ag_fC5AqxDJ5ZEj52wF-W2eGjof6iqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFr9DxfoR_H5rp1ag_fC5AqxDJ5ZEj52wF-W2eGjof6iqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-07-18 at 21:42 -0600, Robert LeBlanc wrote:
> On Tue, Jul 18, 2017 at 1:26 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > On Tue, Jul 18, 2017 at 12:07 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > wrote:
> > > 
> > > 
> I'm trying to understand why merges are being done instead of
> rebases.
> Since we don't want to include other people's work, it seems that it
> is cleaner to do a rebase. This is more for my education with using
> Git with such a large project rather than me suggesting something
> useful. (I dropped Linus from this part of the thread so as not to
> bother him with an off-topic conversation).

Rebases change the history of a patch.  If I commit a patch on July
7th, and then rebase on July 20th, the patch gets rewritten with the
new date.  In addition, they get new commit hashes.  So if someone
pulls my tree on the 9th, sees the commit hash for their patch, and
then references it in an email or a bug report, then I rebase on the
20th, the old commit hash is gone and will be replaced with a new one. 
Finally, if someone pulls my tree on the 8th, and then again on the
22nd, and they don't know I've rebased it, the pull will attempt to put
all of the new hashes on top of the old hashes for the same commits. 
It creates a ton of merge work that is error prone.  Sometimes chunks
get added twice, stuff like that.

There are a few things you can do to get around this, and I sometimes
use those tricks.  I've declared on-list that my github repo is subject
to being rebased at any time, so people know this.  I also have my
github repo as the source for my 0day testing.  So, I can push to
github, wait for 0day test results, and if there was a problem, I can
fix it using a rebase of whatever patch was broken, repush to github,
and repeat until 0day testing passes, and only then do I push to my
kernel.org repo, which is taken to be involate and rebases are
forbidden.  But even there, if I *really* have to, I can rebase by
deleting the branch I originally created and creating a new branch with
the rebase on it under a different name.  That prevents someone from
accidentally pulling the rebase on top of a previous pull.  But I
*really* try to avoid that.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
