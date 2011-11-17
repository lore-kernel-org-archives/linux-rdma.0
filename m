From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: linux-next: Tree for Nov 16 (infiniband: ib_srpt.c)
Date: Thu, 17 Nov 2011 19:51:35 +0100
Message-ID: <CAO+b5-q8doXbGBVkCD+jSjov8ermfVCgBB+WJUPXj=eVh1z87A@mail.gmail.com>
References: <20111116133342.3eb15cac16f4c081dc6ed009@canb.auug.org.au>
	<4EC472A1.6000407@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EC472A1.6000407@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux RDMA <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 17, 2011 at 3:34 AM, Randy Dunlap <rdunlap@xenotime.net> wr=
ote:
> On 11/15/2011 06:33 PM, Stephen Rothwell wrote:
>> Hi all,
>
>
> When CONFIG_BUG is not enabled:
>
> next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'sr=
pt_cm_dreq_recv':
> next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c:2761:3: error: i=
mplicit declaration of function '__WARN'
>
>
> jbd2 has a similar issue (still unpatched). =A0One of the comments in=
 that thread
> was that ext4 probably should use WARN_ON() instead of __WARN().
>
> Or (Arnd said):
> Hmm, my feeling is that we shouldn't do that either, and that jbd2 sh=
ould
> be changed. If we want a function that does what __WARN() does today,=
 we
> should probably make a conscious decision about what we want it to be=
 called
> and not have it start with "__". <end Arnd>

Thanks for reporting this. The __WARN() statements in ib_srpt are
present in code paths that should never be reached. I'll post a patch
that addresses the build failure.

Bart.
