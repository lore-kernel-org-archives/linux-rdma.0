From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] RDMA/amso1100: deprecate the amso1100 provider
Date: Tue, 4 Aug 2015 13:05:54 -0500
Message-ID: <00a401d0cee0$34c75820$9e560860$@opengridcomputing.com>
References: <20150729144646.C1FF1E0B55@smtp.ogc.us> <55B8ED2B.1020206@redhat.com> <32E1700B9017364D9B60AED9960492BC2577970C@fmsmsx120.amr.corp.intel.com> <008501d0ced8$c3ee5a60$4bcb0f20$@opengridcomputing.com> <D2F193D21ECD8C45917AD3D5B26513300C564060@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D2F193D21ECD8C45917AD3D5B26513300C564060-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Dalessandro, Dennis'" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Marciniszyn, Mike'" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > > This might run into the same issue as in
> > https://lists.01.org/pipermail/kbuild-all/2015-August/011216.html.
> > >
> >
> > Hey Mike, what is the issue exactly?
> 
> The problem is when CONFIG_INFINIBAND=n and CONFIG_INFINIBAND_HFI1=y. Here is what I did for ipath which had the same issue:
> 
> http://marc.info/?l=linux-rdma&m=143870511731459&w=2
> 
> -Denny

Thanks.  I'll submit a patch for amso1100 shortly.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
