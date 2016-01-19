From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
Date: Tue, 19 Jan 2016 12:52:43 -0600
Message-ID: <00a201d152ea$94303ff0$bc90bfd0$@opengridcomputing.com>
References: <1452158369-2938-1-git-send-email-matanb@mellanox.com> <00d301d14d69$18257d70$48707850$@opengridcomputing.com> <CAAKD3BAWUfg6sVLCEtb-vBrC9kGtVYO784xg4_tGqiZaOVh-2Q@mail.gmail.com> <007b01d14e13$7fb5a190$7f20e4b0$@opengridcomputing.com> <56974AEE.6060201@mellanox.com> <004401d14edb$65c6b260$31541720$@opengridcomputing.com> <5697B80E.5090903@mellanox.com> <20160114174014.GA30615@leon.nu> <56994CE2.1060205@opengridcomputing.com> <569E8402.2080001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569E8402.2080001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >
> > Hey Doug, can you please accept this and add the Cc: line to get it into
> > stable-4.x?
> >
> > Thanks,
> >
> > Steve.
> 
> I've pulled this in.  I had to fix it up to work with some other code,
> and I added the Cc: to stable.
> 

Thanks Doug.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
