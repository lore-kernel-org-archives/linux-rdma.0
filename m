From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sun, 06 Nov 2011 12:10:45 -0800
Message-ID: <1320610245.10690.10.camel@haakon2.linux-iscsi.org>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	 <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
	 <1320574170.5859.370.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-p0gLueksp7a8RVm9A1Qe_9xc-fNSNX0NY0W7CNtGnSYw@mail.gmail.com>
	 <CAO+b5-r51b_scUC4bGf_ZGADpLf0W7R1eBXdLW_hxcKApPni1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-r51b_scUC4bGf_ZGADpLf0W7R1eBXdLW_hxcKApPni1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2011-11-06 at 18:42 +0100, Bart Van Assche wrote:
> On Sun, Nov 6, 2011 at 2:20 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> > On Sun, Nov 6, 2011 at 11:09 AM, Nicholas A. Bellinger
> > <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> >> We have also discussed srpt_service_guid a bit before, which you
> >> indicated needed to stay in current code as global scope, and presumably
> >> should not change value after loading.  Looking at the actual usage, one
> >> post merge improvement we can consider is seeing if it's possible to
> >> move ib_cm_listen() out of srpt_add_one() and have it driven instead by
> >> configfs context in order to optionally set srpt_service_guid on a per
> >> target endpoint basis to get us some more flexibility.
> >
> > ib_sprt defines a single I/O controller profile and hence there should
> > be exactly one GUID associated with it.
> 
> (replying to my own e-mail)
> 
> Note: I'm not sure anyone is using the srpt_service_guid kernel module
> parameter. One possible approach is to leave out that kernel module
> parameter for the initial merge. If later on anyone asks for restoring
> that functionality we can evaluate at that time what would be the best
> way to restore it.
> 

Well, when this was discussed this before we concluded (via your input)
that this should stay in place for the initial merge.

So it's a bit late to drop this now, as the PULL request has gone out to
Linus, and has been acked by Roland.  But if you think it should
removed, I'm happy to drop it in the first set of post-merge
target-pending rc-fixes.

Thanks,

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
