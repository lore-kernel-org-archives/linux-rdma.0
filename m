From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA patches for 4.1 (was: "Stepping down as maintainer" (was Re:
 [PATCH for-next 0/9] mlx4 changes [...]))
Date: Wed, 15 Apr 2015 11:12:51 -0700
Message-ID: <CAG4TOxO=z3_KLy+_86BS29-ZByuJbj6dWte14bi5oasinkbtzA@mail.gmail.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC0120@ORSMSX109.amr.corp.intel.com>
 <1428858993.3470.12.camel@dworkin> <20150413164238.GB17521@obsidianresearch.com>
 <4EC214DA-97F8-4BCD-AEA6-6FB539E820F1@redhat.com> <20150414234258.GA25810@phlsvsds.ph.intel.com>
 <232BEA5DF26EF54583B8B332938DD0B84BB8E335@CMEXMB1.ad.emulex.com>
 <F6B0F954-1E60-4CE9-AF39-7A6E8C8EC47B@redhat.com> <552E6D7E.3090002@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552E6D7E.3090002-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Pradeep Kankipati <Pradeep.Kankipati-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 15, 2015 at 6:54 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> There were two trivial conflicts between the mlx4 changes to another mlx4
> series which is present in net-next, I resolved them and you can pull the
> fixed series from my git tree,SB.

Not sure how you expect this to work.  It is a hassle for both
maintainers if you are sending conflicting patches to different trees.

Do you want some of the mlx4 changes to go via Dave's tree and some to
go via my/Doug's tree?  If so do you expect us to rebase onto Dave's
tree?  Because I don't want to do that when I either need to rebase
onto some random point of net-next or some random point of Linus's
tree in the middle of the merge window.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
