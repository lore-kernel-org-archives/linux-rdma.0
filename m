From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: Remove unused field sent_ts
Date: Tue, 3 Feb 2015 17:21:57 +0000
Message-ID: <1EEBC91386407A4A8D1EBE1DD5AA52125CF8D291@FMSMSX114.amr.corp.intel.com>
References: <20150203114747.GA7370@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150203114747.GA7370@tinar>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tina Ruchandani <ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> From: Tina Ruchandani [mailto:ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, February 03, 2015 5:48 AM
> 
> This patch removes the unused field sent_ts from struct nes_cm_tcp_context.
> This patch is part of an effort to clean up instances of timekeeping data-types
> like 'struct timeval' which will overflow on 32-bit systems in year 2038 and
> beyond.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> --
> 2.2.0.rc0.207.ga3a616c

Acked-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
