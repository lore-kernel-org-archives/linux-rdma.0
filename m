From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma: 3.1.0-rc9 breaks UD
Date: Wed, 19 Oct 2011 01:05:11 +0200
Message-ID: <CAJZOPZ+M9xX94YfESmPTihCBtV+dnrdVq3a9vHZSkwmQ9C72Rg@mail.gmail.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home>
	<CAJZOPZJVNiwU-YA6KteOoFYX5M=BzPEZJsvRoFOz170O11qgeA@mail.gmail.com>
	<alpine.DEB.2.00.1110181013090.687@router.home>
	<CAJZOPZJvF1F1J_DYJf-v6JZx5pGv_sxTb8GgsF09HFj81jQ+sw@mail.gmail.com>
	<CAJZOPZJCzMemMboH0V83w87uHqggQ5zqtMR3eKocvWKdaypmZg@mail.gmail.com>
	<CAL1RGDWhg6mjn2qa6Dgm2Hc2NugMM=RuG_6HrpxEvrooAZOX3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWhg6mjn2qa6Dgm2Hc2NugMM=RuG_6HrpxEvrooAZOX3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 12:52 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:

> Do you understand why -s 100 fixes things? =A0If so can you explain i=
t to me? ;)

Oh sorry if I was a bit cryptic here (BTW 99 and 101 and 256,512,2048 w=
ould
work as well...), I'm not next to the code and writing from backoffice =
my
head cache, I think before that patch for some reason the rc/uc/srq
pingpongs were defaulted to 2048 wheres the ud pingpong wad defaulted t=
o
1024 and this patch changed also ud default to be 2048 so one side send=
s
2048 and the rx side does post receive of 1024 - will that hang the  te=
st or
should generate completion with error or actually no since its UD - in =
few
hours I will be next to the code/spec/setup...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
