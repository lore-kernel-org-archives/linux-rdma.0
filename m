From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH libibverbs V5 2/2] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Thu, 28 Aug 2014 17:48:42 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FE48637@CMEXMB1.ad.emulex.com>
References: <1408517381-17523-1-git-send-email-matanb@mellanox.com>
 <1408517381-17523-3-git-send-email-matanb@mellanox.com>
 <20140820170142.GC12605@obsidianresearch.com>
 <53F9EDCD.9060105@mellanox.com> <20140825183325.GC1298@obsidianresearch.com>
 <5C3BB7B1-07E6-431F-98E5-13543AAA897D@redhat.com>
 <53FC7B1D.6050501@mellanox.com>
 <20140826160853.GA31127@obsidianresearch.com>
 <EE7902D3F51F404C82415C4803930ACD3FE48403@CMEXMB1.ad.emulex.com>
 <53FF56DF.1050207@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53FF56DF.1050207-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Matan,

Thanks for quick response, my further comments are inline below:

> -----Original Message-----
> From: Matan Barak [mailto:matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Thursday, August 28, 2014 9:51 PM
> To: Devesh Sharma; Jason Gunthorpe; Or Gerlitz
> Cc: Doug Ledford; Roland Dreier; Yishai Hadas; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH libibverbs V5 2/2] Use neighbour lookup for RoCE UD
> QPs Eth L2 resolution
> 
> On 28/8/2014 12:48 PM, Devesh Sharma wrote:
> > Hi Matan,
> >
> > I have been watching this thread for quite some time. I have a Basic
> > question, do you think ib_uverbs_create_ah() in uverbs_cmd.c Should
> > resolve to l2 address? Presently it is not calling
> rdma_addr_find_dmac_by_grh(), am I missing something here?
> >
> > -Regards
> >   Devesh
> >
> 
> Hi Devesh,
> 
> Some vendors don't call ib_uverbs_create_ah and do all this creation in
> userspace only. It's true that it might be a lot easier to do that resolution in
> kernel, but it could create dependency of new versions of libibverbs and the
Which dependency you are specifying here, I see the scheme posted in this series adds dependency on libibverbs.
Do you anticipate modification even when uverbs interface is used?
> provider library tn new kernels only.
> I would like to avoid creating such a dependency.

Okay, got it, any suggestions for those who use uverbs interface.
I think another patch is needed for such vendors?

> 
> Matan
> 
> >> -----Original Message-----
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> >> Sent: Tuesday, August 26, 2014 9:39 PM
> >> To: Or Gerlitz
> >> Cc: Doug Ledford; Matan Barak; Roland Dreier; Yishai Hadas; linux-
> >> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Subject: Re: [PATCH libibverbs V5 2/2] Use neighbour lookup for RoCE
> >> UD QPs Eth L2 resolution
> >>
> >> On Tue, Aug 26, 2014 at 03:18:37PM +0300, Or Gerlitz wrote:
> >>> On 25/08/2014 22:33, Doug Ledford wrote:
> >>>>> On Aug 25, 2014, at 1:33 PM, Jason Gunthorpe
> >> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >>>>>
> >>>>>>>> +    timer_fd = timerfd_create(CLOCK_MONOTONIC,
> >> TFD_NONBLOCK | TFD_CLOEXEC);
> >>>>>>>> +    if (-1 == timer_fd) {
> >>>>>>>> +        print_err("Couldn't create timer\n");
> >>>>>>>> +        return timer_fd;
> >>>>>>>> +    }
> >>>>>>>
> >>>>>>> The use of timerfd will impact the minimum OS version, have you
> >>>>>>> checked this is OK? Does RHEL5 still work?
> >>>>>
> >>>>>> It was added in linux v2.6.25. I think that an API that's more
> >>>>>> than
> >>>>>> 6.5 years old is valid.
> >>>>>
> >>>>> RHEL5 is using 2.6.18 as their base kernel. You should at least
> >>>>> consult with the OFED people to determine if this is a problem for
> >>>>> them.
> >>>>
> >>>> Please don't.  This code should not be changed for something as
> >>>> ancient
> >> as rhel5.
> >>>
> >>> Indeed. Telling people to avoid using constructs/mechanisms ~6-7
> >>> years after they were introduced isn't something we want nor need to
> do.
> >>
> >> I looked myself and it looks like OFED has dropped support for these
> >> old distros so there isn't any problem.
> >>
> >> However, I still think this use of timerfd is fairly gratuitous, and
> >> looking closer, causes little bugs:
> >>
> >> +		if (timerfd_settime(timer_fd, 0, &timer_time, NULL)) {
> >> +		   			      print_err("Couldn't set timer\n");
> >> +			return -1;
> >>                       ^^^^^^^^^^^^^^
> >> leaks timer_fd
> >>
> >>
> >> Alos, I noticed:
> >>
> >> +     	/* wait for an incoming message on the netlink socket */
> >> +	   ret = select(nfds, &fdset, NULL, NULL, NULL);
> >> +
> >> +		if (ret) {
> >>
> >> Fails to detect error return from select.
> >>
> >> Jason
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> >> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> >> info at http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
