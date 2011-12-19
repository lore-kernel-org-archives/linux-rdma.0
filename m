From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 11/14] ib_srp: Document sysfs attributes
Date: Mon, 19 Dec 2011 08:46:06 +0000
Message-ID: <CAO+b5-rb=Gtch0UCZPwTSCHhOdsUBecSpgYjaLvj5pbo9_1AeQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012009.12815.bvanassche@acm.org>
	<1324254811.17849.65.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324254811.17849.65.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 19, 2011 at 12:33 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrot=
e:
> On Thu, 2011-12-01 at 20:09 +0100, Bart Van Assche wrote:
>> + =A0 =A0 =A0 =A0 =A0 =A0 * cmd_sg_entries, the maximum number of me=
mory descriptors
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 that fit in a single SRP command when =
using the direct data
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 buffer descriptor format.
>
> s/direct/indirect/

=46or the current ib_srp implementation cmd_sg_entries is the maximum
number of direct data buffer descriptors allocated.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
