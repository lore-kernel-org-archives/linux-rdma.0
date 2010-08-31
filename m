From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [ofw] What is an IOC device ID and what is DriverStore
Date: Tue, 31 Aug 2010 07:58:53 +0200
Message-ID: <AANLkTimXbsUxuQqNC0WkHJXu=sj_1aij8-SGvv1ra4LN@mail.gmail.com>
References: <AANLkTikKcUwO59Pkmeu3kG_FBwpg=SXj3P0Ud3rsq4Mw@mail.gmail.com>
	<946F457324732742B1457FAFC8CF1ECB012DD2B0842A@EXCHANGE2.sbcounty.gov>
	<AANLkTin_3d64+U2aiQg6E8DMNY0FsjMUVfgjrtR2O2PR@mail.gmail.com>
	<AANLkTi=-4NqF-B61teg4shWciMcea11yD3i8wsiUUQ_5@mail.gmail.com>
	<AANLkTi=9SLO+mP5MxwPhV8pC2_Yvd4KMWafgh7Y+zPVN@mail.gmail.com>
	<AANLkTimdpC88_jDJyv9vd=hoHhur8fXG0kSUo323ekyF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimdpC88_jDJyv9vd=hoHhur8fXG0kSUo323ekyF-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Uri Habusha <urih-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 31, 2010 at 1:58 AM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, Aug 30, 2010 at 5:46 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Hint:
> >
> > SCST rev 1901 ends compatibility w/ Windows; r1900 works fine.
>
> srpt_autodetect_cred_req was added in r1901, with default "Y".
> Setting it to "N"... or in later revs, "1", allows Windows to work
> again.

(resending as plain text)

That means there is a serious bug in the Windows SRP initiator.
Setting srpt_autodetect_cred_req=Y causes ib_srpt to test whether the
initiator supports SRP_CRED_REQ by sending a single SRP_CRED_REQ
information unit to the SRP initiator. Support for SRP_CRED_REQ is
required by the SRP (draft) standard and should not cause an initiator
to stop functioning properly.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
