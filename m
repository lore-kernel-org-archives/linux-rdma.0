From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Fix Last WQE handling
Date: Tue, 8 Nov 2011 08:21:54 +0100
Message-ID: <CAO+b5-oJx3knOG+6ra3j-TtOuc9y0ueaCofLbwoB5=gcECJ=fA@mail.gmail.com>
References: <201111061831.17756.bvanassche@acm.org>
	<CAL1RGDW+um6nT=K+0x4ibR41TeQZVcVvXH1ZS=32tx=Fp5ZtXg@mail.gmail.com>
	<CAO+b5-pLv9PeO1E2kG7utsP4_rh49NfmPji2SVxBJQ2+OTZg4w@mail.gmail.com>
	<1320698766.30780.35.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320698766.30780.35.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 7, 2011 at 9:46 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> On Mon, 2011-11-07 at 20:00 +0100, Bart Van Assche wrote:
>> On Mon, Nov 7, 2011 at 7:10 PM, Roland Dreier <roland-BHEL68pLQRHS2c0oH+HQlg@public.gmane.org=
m> wrote:
>> > On Sun, Nov 6, 2011 at 9:31 AM, Bart Van Assche <bvanassche-y/PYEvSCHaw@public.gmane.org=
g> wrote:
>> >> Make sure that the last WQE event is handled properly if it arriv=
es
>> >> before the QP has been transitioned into the error state.
>
> This patch fails to compile with the following:
>
> drivers/infiniband/ulp/srpt/ib_srpt.c: In function =91srpt_perform_rd=
mas=92:
> drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: =91CH_RELEASING=92=
 undeclared (first use in this function)
> drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: (Each undeclared i=
dentifier is reported only once
> drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: for each function =
it appears in.)
>
> I'm assuming this needs to be changed to CH_DRAINING instead, yes..?

Yes. The tests I ran were with that change included - I'm not sure how
it's possible that that change was not included in the patch I posted.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
