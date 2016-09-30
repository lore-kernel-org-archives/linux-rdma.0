From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Re: Towards qedr patch series
Date: Fri, 30 Sep 2016 13:04:39 +0000
Message-ID: <SN1PR07MB22077D482047551775FE4BCFF8C10@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <DM3PR07MB2201E202E535C987EEAA3BFDF8CA0@DM3PR07MB2201.namprd07.prod.outlook.com>,<57EC1C46.6070502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57EC1C46.6070502-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> There are currently 5 (5!!!) entirely new drivers that people want to
> get merged.=A0 Reviewing those monstrous beasts is a nightmare.=A0 The
> chances that I will get to yours for 4.9 are slim at best.

Phew, that is a awful lot.
We will do all that we can on our side to increase the chances of making it=
 to 4.9.

> However, on the off chance that I might get to it, base the qed patches
> against Dave's net-next (up until the merge window opens, then base it
> on his net tree as that's what will get merged).=A0 The qedr patches
> should be based on my current k.o/for-4.9 branch off of k.o.=A0 When you
> submit any patches, I would suggest doing it in two separate submissions
> (if possible).=A0 One that is just the preparatory qed patches.=A0 They
> should be sent to netdev@ and linux-rdma@.=A0 The submission should note
> that they are intended to be taken with the qedr driver.=A0 If netdev@
> reviews/acks the series, then Dave can let me know if he wants me to
> take the series and keep with with the remaining qedr series, or if he
> wants to take them himself and I just make sure my pull request of the
> qedr patches goes to Linus after his.=A0
> The second set would obviously be
> the new qedr driver.=A0 It need not go to netdev.=A0 Once it's here, then
> it's a matter of the netdev@ people signing off on the qed series
> changes, me signing off on the qedr changes, then it can go in.

OK=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
