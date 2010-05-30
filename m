From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Sun, 30 May 2010 10:01:01 +0200
Message-ID: <AANLkTilFAY8K1ShAy8-btMCpBVJfRzBBiqcqroXttPFz@mail.gmail.com>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>
	<f3177b9e0911040802o7fce0f4fte02c52dfe940f582@mail.gmail.com>
	<3142CEFB1403044F9954E2DF6C85660FBB34BF@orca.penguincomputing.com>
	<f3177b9e0911041004t2e75d545v5cc10d5375550bde@mail.gmail.com>
	<654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4DD@orca.penguincomputing.com>
	<4AF29201.6000606@penguincomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF29201.6000606-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Cc: scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

(resending as plain text)

On Thu, Nov 5, 2009 at 10:51 AM, Philip Pokorny
<ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>
> [ ... ]
>
> Performance (when it's working) is generally good at 800MB/sec aggreg=
ate, but we'd like to see better. =A0It appeared we were getting 1.3GB/=
s at one point.

(replying to an e-mail that was posted several months ago)

You might have hit a limitation of Linux' asynchronous I/O subsystem
(at the SRP initiator side). Asynchronous I/O performance has been
improved significantly in the 2.6.33 kernel. The throughput I measured
with fio, QDR HCA's and a 2.6.34 initiator is as follows:
* 940 MB/s for asynchronous writes and 1240 MB/s for asynchronous
reads and a block size of 64 KB.
* 2200 MB/s for direct writes and 2900 MB/s for direct reads and a
block size of 64000 KB.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
