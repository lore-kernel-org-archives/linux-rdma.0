From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 10 Sep 2015 09:20:27 +1000
Message-ID: <20150910092027.5d852732@canb.auug.org.au>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
	<CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
	<CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
	<55EFA2BF.7060006@redhat.com>
	<20150910074505.1b4eec1c@canb.auug.org.au>
	<55F0B371.2090403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F0B371.2090403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

On Wed, 9 Sep 2015 18:32:17 -0400 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 09/09/2015 05:45 PM, Stephen Rothwell wrote:
> > 
> > The only branch of yours that I have ever fetched is
> > git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git#for-next

Turns out that that "branch", is actually a tag (the only one I fetch,
but it doesn't cause any hassle).

> Hmmm...I could have sworn I hadn't pushed that branch to k.o by the time
> you sent the merge request.  If that's not the case, then I will have to
> figure out how I confused myself on that issue.

In case it helps, next-20150817 contained this as the for-next tag:

    Initial roundup of 4.3 merge window candidates
    
    # gpg: Signature made Sun 02 Aug 2015 07:21:56 AEST using RSA key ID 0E572FDD
    # gpg: Oops: keyid_from_fingerprint: no pubkey
    # gpg: Good signature from "Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>" [undefined]
    # gpg:                 aka "Doug Ledford (Personal email) <dledford-HHGe/kKACDifJOJzLBvvIA@public.gmane.org>" [unknown]
    # gpg:                 aka "[jpeg image of size 3057]" [unknown]
    # gpg: WARNING: This key is not certified with a trusted signature!
    # gpg:          There is no indication that the signature belongs to the owner.
    # Primary key fingerprint: AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

And the associated commit was:

153b7306b7c6 ("Merge branch 'hfi1-v4' into to-be-rebased/for-4.3")

>From next-20150903, the for-next tag pointed back into Linus' tree
("Linux 4.2").

-- 
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
