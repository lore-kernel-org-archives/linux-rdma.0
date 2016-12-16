From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet pacing
Date: Thu, 15 Dec 2016 21:48:35 -0500
Message-ID: <20161216024834.GA27188@phlsvsds.ph.intel.com>
References: <1480592596-20126-1-git-send-email-leon@kernel.org> <1480592596-20126-3-git-send-email-leon@kernel.org> <1828884A29C6694DAF28B7E6B8A82373AB0BA789@ORSMSX109.amr.corp.intel.com> <20161202143957.GF4497@leon.nu> <HE1PR0501MB28122735F9F3DFD700B43BFBB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com> <67d4e948-0ada-bd75-8855-79eed2ae9a7b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <67d4e948-0ada-bd75-8855-79eed2ae9a7b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 14, 2016 at 02:03:14PM -0500, Doug Ledford wrote:
> On 12/4/2016 6:53 AM, Liran Liss wrote:
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> > 
> >>
> >> On Thu, Dec 01, 2016 at 07:40:44PM +0000, Hefty, Sean wrote:
> >>>>  enum ib_qp_state {
> >>>> @@ -1151,6 +1152,7 @@ struct ib_qp_attr {
> >>>>  	u8			rnr_retry;
> >>>>  	u8			alt_port_num;
> >>>>  	u8			alt_timeout;
> >>>> +	u32			rate_limit;
> >>>>  };
> >>>
> >>> And I still disagree with this approach, as there is already an existing field in the
> >> API that limits rate.
> >>
> >> Hi Sean,
> >>
> >> We would like to elaborate more on the subject, and we need your help here.
> >> Our cover letter [1] has description why the existing field is not enough. Can you
> >> write a little bit more why you didn't like the proposed approach to an existing
> >> and real problem?
> >>
> > 
> > Clearly, we need a new field that is greater than 8 bits that uses different encoding (actual rate rather than a predefined enumeration of values).
> > 
> > However, this is not only a new field - this rate is also conceptually different than AH static rate:
> > 1) It is not related to the fabric path.
> > 2) It is determined by the application rather than the fabric.
> > 3) It needs to apply to QPs that don't use AH (raw Ethernet QPs)
> > 
> > Of course, we might require raw Ethernet QPs to use an AH just for the sake of rate-limiting.
> > But 1) + 2) indicate that this should be a concept orthogonal to network paths. In fact, it could apply to RC and UD QPs as well.
> > In addition, if we implement full connection establishment in the kernel (i.e., the static_rate field is filled in the kernel), we would still like to allow applications to further restrict their rate using a different component mask.
> > --Liran
> > 
> 
> I applied this series.  I agree with Liran that the need for something
> other than an enum to denote rates is needed.  We will have to work out
> exactly how to present this to user space (keep both, replace
> static_rate and bumb the verbs API number, other options?)

I think in the new ioctl interface values like this should be more generic.
MTU is another example.

FWIW I agree with Sean that static rate should have been changed to accommodate
this expanded meaning.

With this new structure definition which rate is in effect?  Are devices
supposed to take the min of the 2?

Ira

> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
