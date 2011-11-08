From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Fix Last WQE handling
Date: Tue, 8 Nov 2011 12:24:19 +0100
Message-ID: <CAO+b5-qgGuGmHM1j_ND_m1huwX9w3h5LLkNQkfJpyc5FJmyQXA@mail.gmail.com>
References: <201111061831.17756.bvanassche@acm.org>
	<CAL1RGDW+um6nT=K+0x4ibR41TeQZVcVvXH1ZS=32tx=Fp5ZtXg@mail.gmail.com>
	<CAO+b5-pLv9PeO1E2kG7utsP4_rh49NfmPji2SVxBJQ2+OTZg4w@mail.gmail.com>
	<1320698766.30780.35.camel@haakon2.linux-iscsi.org>
	<CAO+b5-oJx3knOG+6ra3j-TtOuc9y0ueaCofLbwoB5=gcECJ=fA@mail.gmail.com>
	<1320746408.30780.174.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320746408.30780.174.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 8, 2011 at 11:00 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> Thanks for verifying this one. =A0Pushed into lio-core and will squas=
h
> into a single patch for target-pending.

I've had a quick look at
http://git.kernel.org/?p=3Dlinux/kernel/git/nab/lio-core.git;a=3Dblob;f=
=3Ddrivers/infiniband/ulp/srpt/ib_srpt.c.
Apparently the rdma_size value in the I/O controller profile is still
port-specific ? This is how the rdma_size is computed now:

iocp->rdma_size =3D
cpu_to_be32(min(sport->port_attrib.srp_max_rdma_size, 1U << 24));

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
