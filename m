From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 05/11] xprtrdma: Do not wait if ib_post_send() fails
Date: Thu, 10 Mar 2016 09:31:52 -0600
Message-ID: <7b2101d17ae1$f88597b0$e990c710$@opengridcomputing.com>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org> <20160304162801.13590.89343.stgit@oracle120-ib.cthon.org> <56DF1186.3030303@dev.mellanox.co.il> <8696EFBA-B7DB-42AC-AB57-C656070F4ED3@oracle.com> <56E00483.2060304@dev.mellanox.co.il> <6B59B087-9CFA-458B-8848-B08B8E14E2C7@oracle.com> <56E14BA2.2050504@dev.mellanox.co.il> <7abb01d17ade$1faf0ff0$5f0d2fd0$@opengridcomputing.com> <AC62FAB3-5569-4FA3-93AF-35CD2A1869EF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AC62FAB3-5569-4FA3-93AF-35CD2A1869EF-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, 'Linux RDMA Mailing List' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Linux NFS Mailing List' <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > On Mar 10, 2016, at 10:04 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> wrote:
> >
> >>>> Moving the QP into error state right after with rdma_disconnect
> >>>> you are not sure that none of the subset of the invalidations
> >>>> that _were_ posted completed and you get the corresponding MRs
> >>>> in a bogus state...
> >>>
> >>> Moving the QP to error state and then draining the CQs means
> >>> that all LOCAL_INV WRs that managed to get posted will get
> >>> completed or flushed. That's already handled today.
> >>>
> >>> It's the WRs that didn't get posted that I'm worried about
> >>> in this patch.
> >>>
> >>> Are there RDMA consumers in the kernel that use that third
> >>> argument to recover when LOCAL_INV WRs cannot be posted?
> >>
> >> None :)
> >>
> >>>>> I suppose I could reset these MRs instead (that is,
> >>>>> pass them to ib_dereg_mr).
> >>>>
> >>>> Or, just wait for a completion for those that were posted
> >>>> and then all the MRs are in a consistent state.
> >>>
> >>> When a LOCAL_INV completes with IB_WC_SUCCESS, the associated
> >>> MR is in a known state (ie, invalid).
> >>>
> >>> The WRs that flush mean the associated MRs are not in a known
> >>> state. Sometimes the MR state is different than the hardware
> >>> state, for example. Trying to do anything with one of these
> >>> inconsistent MRs results in IB_WC_BIND_MW_ERR until the thing
> >>> is deregistered.
> >>
> >> Correct.
> >>
> >
> > It is legal to invalidate an MR that is not in the valid state.  So you
don't
> > have to deregister it, you can assume it is valid and post another LINV WR.
> 
> I've tried that. Once the MR is inconsistent, even LOCAL_INV
> does not work.
>

Maybe IB Verbs don't mandate that invalidating an invalid MR must be allowed?
(looking at the verbs spec now).



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
