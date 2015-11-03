From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Tue, 3 Nov 2015 09:09:57 +0200
Message-ID: <CAJ3xEMjv-FG3xy1YC7xf5ziKTqOSv9cBn5z=t2EmUsh3t_kk5A@mail.gmail.com>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
	<56262676.7000403@dev.mellanox.co.il>
	<563185AC.10804@redhat.com>
	<CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>
	<56322A41.9050004@redhat.com>
	<CAJ3xEMjDpELFd5rMgRwtL4JhB_uHca6oE28exKamXUm4rmkrtg@mail.gmail.com>
	<20151102085651.1dafc855@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151102085651.1dafc855-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 1, 2015 at 11:56 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> On Sun, 1 Nov 2015 17:00:22 +0200 Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>> Stephen, is the framework for linux-next merge tests OK with this tag?
>> can you confirm that the-next bits of the rdma tree are covered fine?

> linux-next fetches the "for-next" tag for that tree.

Good!

Doug, did you also manage to register this tag habit to the 0-day
framework? we want all
our subsystem patches to go through 0-day before they hit upstream,
both rc fixes and next bits.

Also, Doug, how do you suggest someone that wants to automatically
track rc fixes branch? can
you make another flying "for-rc" tag?

Alaa, lets set our internal build system to follow on this tag too and let Doug
know if we fail so he can coach us further.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
