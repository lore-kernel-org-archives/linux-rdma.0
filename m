From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Thu, 29 Oct 2015 07:42:00 +0200
Message-ID: <CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
	<56262676.7000403@dev.mellanox.co.il>
	<563185AC.10804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <563185AC.10804-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2015 at 4:34 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Yes, I've pulled this in for 4.4.  Thanks!

Doug, we want to run regression over the 4.4 bits, when do you expect
for them to show up @ your kernel.org tree? some of them are there but
@ least 3-4 series which you said "applied" aren't, AFAIR last time it
was only about whole ten days after the merge window opened. Also,
without the patches being there the code isn't subject to linux-next
merge test (also after being there neither, since the branch name
changes for each release and I didn't see you setting a flying tag, or
you did so?)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
