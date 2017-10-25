From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Wed, 25 Oct 2017 14:57:20 -0400
Message-ID: <1508957840.3325.54.camel@redhat.com>
References: <20171024123957.32207.70888.stgit@phlsvslse11.ph.intel.com>
         <20171024144152.GH16127@mtr-leonro.local>
         <14063C7AD467DE4B82DEDB5C278E8663875E153D@FMSMSX108.amr.corp.intel.com>
         <20171024151958.GI16127@mtr-leonro.local>
         <14063C7AD467DE4B82DEDB5C278E8663875E15AD@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663875E15AD-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-24 at 15:42 +0000, Ruhl, Michael J wrote:
> > > have the same issue.  Specific index validation is needed, and
> > > should probably
> > 
> > be
> > > addressed with a different patch.
> > 
> > .doit exists for RDMA_NL_LS and for other .dumpit exists, so no
> > actual
> > check is needed.
> > 
> > if you want to be on the safe side, please extend is_nl_valid().
> > IMHO,
> > it will keep code cleaner, the checks in one localized place and
> > execution
> > is not mixed with the validity checks.
> 
> Leon,
> 
> I do not disagree with you on this.  My patch is to fix the Oops, and
> make
> sure it can't happen with the current code.
> 
> Extending is_nl_valid() to be more complete seems to be out of scope
> for
> the current issue of making the Oops go away.
> 
> I can probably work on is_nl_valid(), but I will need much more time
> to make sure
> that it is correct, and don't feel that I can get it done with in the
> appropriate
> time frame (i.e. sometime this week).

I agree with Michael that tweaking this code to be optimal versus
plainly failsafe is a patch for another day.  I've taken this one. 
Thanks Michael.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
