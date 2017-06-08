From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] IB/core: Add generic function to extract IB speed
 from netdev
Date: Thu, 8 Jun 2017 16:27:04 +0300
Message-ID: <20170608132703.GA12619@yuvallap>
References: <20170606193622.25552-1-yuval.shaia@oracle.com>
 <20170607165022.GF1127@mtr-leonro.local>
 <20170607194635.GA7042@yuvallap>
 <CAG9sBKNK9MXq+x=f+H6TnZVQP1t7X=2bZEpCjzYrNtCQxq2xsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNK9MXq+x=f+H6TnZVQP1t7X=2bZEpCjzYrNtCQxq2xsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 08, 2017 at 08:43:41AM +0300, Moni Shoua wrote:
> >> >
> >> > +void ib_get_speed(struct net_device *netdev, u8 *speed, u8 *width)
> >> > +{
> >> > +   int rc;
> >> > +   u32 netdev_speed = SPEED_UNKNOWN;
> >> > +
> >
> > [1]
> >
> I think it should be clear that this function is good only for RoCE
> If you pass struct ib_device* instead of struct net_device* you can
> check link layer and return bad status of it is not Ethernet

Will do.

> The net_device will be obtained via get_netdev() hook.

So every explicit usage of ibdev->netdev can be considered as bed practice?

> Consider adding _eth_ to the name of the function (e.g. ib_get_etht_speed)

Will do.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
