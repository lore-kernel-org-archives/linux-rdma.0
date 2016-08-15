From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] Add transactions per second to latency tests
Date: Mon, 15 Aug 2016 10:51:40 -0500
Message-ID: <01f401d1f70c$e9ca1be0$bd5e53a0$@opengridcomputing.com>
References: <4257b3f1d2c22af577a5e584d2a34013342fb0ca.1467907759.git.root@stevo1.asicdesigners.com> <013001d1d86a$5b3ea460$11bbed20$@opengridcomputing.com> <008e01d1e8e3$3a0a5170$ae1ef450$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <008e01d1e8e3$3a0a5170$ae1ef450$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ping...

Does anyone still maintain the perftest repo?


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Thursday, July 28, 2016 10:18 AM
> To: gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [PATCH] Add transactions per second to latency tests
> 
> Hey Gil, will you merge this?
> 
> Thanks,
> 
> Steve.
> 
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> > Sent: Thursday, July 07, 2016 11:12 AM
> > To: gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: RE: [PATCH] Add transactions per second to latency tests
> >
> >
> > > Subject: [PATCH] Add transactions per second to latency tests
> > >
> > > For duration (-D) latency tests, it is useful to have the average
> > > transactions per second (tps) output.  So ib_*_lat now shows
> > > average tps:
> > >
> > >
> >
>
--------------------------------------------------------------------------------
> > -------
> > >  #bytes        #iterations       t_avg[usec]    tps average
> > >  2             1008430           2.97           168068.16
> > >
> >
>
--------------------------------------------------------------------------------
> > -------
> > >
> > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > I should have added "perftest" to the subject.  This is a patch to
> > git://git.openfabrics.org/~grockah/perftest.
> >
> > Steve.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
