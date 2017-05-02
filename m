From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
Date: Tue, 2 May 2017 12:39:58 -0400 (EDT)
Message-ID: <665014226.4138173.1493743198816.JavaMail.zimbra@redhat.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com> <d697d360-99ca-c3ed-08e2-b89cc50a15b0@grimberg.me> <20170423121254.GD14088@mtr-leonro.local> <a3264968-2d9e-bda5-1f23-74da248cf4d5@grimberg.me> <9a9668fa-87a7-e730-27e2-8a2b3e7fbc36@mellanox.com> <8ed506ba-ae7b-af27-2d2a-9a434c22353c@grimberg.me> <1493664645.3041.184.camel@redhat.com> <4a1c94b5-fe13-8b34-762f-e7465182ed27@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4a1c94b5-fe13-8b34-762f-e7465182ed27-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> To: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, "keith busch" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
> linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Sent: Tuesday, May 2, 2017 12:14:33 PM
> Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
> 
> 
> 
> On 5/1/2017 9:50 PM, Doug Ledford wrote:
> > On Sun, 2017-04-23 at 17:35 +0300, Sagi Grimberg wrote:
> >>>
> >>> I actually answered here:
> >>> https://www.spinics.net/lists/linux-rdma/msg46412.html
> >>
> >> Did anything progress with the debug?
> >>
> >>>
> >>> Sagi,
> >>> As you mentioned the IO path is different in SRP and iSER so IMO we
> >>> should start with SRP debugging. NVMf is similar to iSER (and not
> >>> SRP)
> >>> and that's why I think we can apply this patchset.
> >>
> >> My concern is that this might be broken due to the fact that we don't
> >> know what triggers this.
> >>
> >>>
> >>> If you want to wait till we debug SRP issue it's fine, but I can't
> >>> repro
> >>> it in my lab so it can take longer.
> >>
> >> I'd prefer not to take a non-mandatory feature that is not guaranteed
> >> to work.
> >
> > Indeed.  I've left this series on hold (actually, I've removed it from
> > patchworks).  When we get this straightened, then please resubmit.
> >
> 
> Sure, no problem.
> 
> Max.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Max
The setup is in place, send me whatever it is you need for debug here.
Patches, instrumentation etc.
I will be happy to gather the debug.
Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
