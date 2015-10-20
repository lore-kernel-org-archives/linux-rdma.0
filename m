From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating
 AH from WC
Date: Tue, 20 Oct 2015 10:36:42 -0600
Message-ID: <20151020163642.GA24608@obsidianresearch.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
 <1444568298-17289-2-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734356@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734A57@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BAF763brdhsrHtpm_peHk--g3iza53AioiUefepHM_s2w@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A9735914@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BCdbD8MC4PJGuVzUxiq5wEbCNjX4e91vBkcoErJVM8FQg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A9736832@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9736832-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2015 at 03:57:54PM +0000, Hefty, Sean wrote:
> > Today, cm assumes paths are reversible primary_path->reversible = 1.
> 
> I can't quickly find a link, but I believe all CM MADs are
> reversible, per the spec.

But the Linux CM code doesn't always create the reverse CM MAD from
the GMP headers, it sometimes will do it by looking into the data path
in the MAD, which means it still could need to sleep to do the MAC
resolution.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
