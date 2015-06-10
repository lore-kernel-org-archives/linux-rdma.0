From: Diego Crupnicoff <Diego-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>
Subject: LINUX RDMA MAILING LIST MONITOR ALERT - RE: [PATCH for-next V5 00/12]
 Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 23:17:26 +0000
Message-ID: <AM2PR05MB0866392FDB15F32719EE692DC5BD0@AM2PR05MB0866.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here Sean reacts to our RoCEv2 patches (same thread as the one I sent before with Jason's feedback).
Sean is not even making technical statements to dismiss our patches. He has been rejecting all our previous revs of this set with loose FUD comments. In this case he chose to count the lines of code. 


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> Sent: Wednesday, June 10, 2015 12:10 PM
> To: Or Gerlitz; Doug Ledford; Jason Gunthorpe
> Cc: Matan Barak; Moni Shoua; Somnath Kotur; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [PATCH for-next V5 00/12] Move RoCE GID management to
> IB/Core
> 
> > Sean, this change is needed b/c two drivers have (mlx4 and ocrda) and
> > more two to come soon (mlx5 and soft-Roce) would have the very same
> > logic of constructing the port GID table according to netdev events
> > and such, no point in repeating this logic/code over and over.
> >
> > Matan explained why we don't have 2 x Y deletions and 1 x Y insertions.
> 
> It more than doubles the amount of code.  That's not a cleanup.  It introduces
> a bunch of new functionality.  Jason has asked repeatedly to remove the
> RoCEv2 code, and that has been ignored repeatedly.  As far as I'm concerned,
> this patch is not worth my time, and I will no longer even bother following
> this series.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
