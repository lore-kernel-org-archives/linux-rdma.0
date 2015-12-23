From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/10] iSER support for remote invalidate
Date: Wed, 23 Dec 2015 22:53:40 +0200
Message-ID: <CAJ3xEMjDpmQgt1RLnRuOP6b2EW=WQrER5d7A2NfQ6t5y4KCgMw@mail.gmail.com>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
	<1450671628.25674.27.camel@haakon3.risingtidesystems.com>
	<CAJ3xEMi58s6bWv7cyb+3v3H7e=4t6hRaOX0TvTyXRXLiUjxq+g@mail.gmail.com>
	<5677FEBB.7080904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5677FEBB.7080904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 3:29 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

>> Sagi, are you going to spin an increment in the initiator version?

> I don't know if it's worth a driver version update?

yes, I think it does. Finally we're getting real close to the visions
of the spec authors...  do you have some performance data showing the
gain of remote invalidation on certain HWs and IO benchmarks patterns.
Did we make sure to interoperate between patched initiator to
unpatched LIO or other targets which don't have this now (SCST, TGT)
and the other way around (unpatched initiator, patched LIO)?

> In case we do increment, I can send an incremental patch instead of
> re-spinning the entire series.

lets do that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
