From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Thu, 29 Oct 2015 17:24:00 +0200
Message-ID: <56323A10.7030103@dev.mellanox.co.il>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
 <56262676.7000403@dev.mellanox.co.il> <563185AC.10804@redhat.com>
 <CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>
 <56322A41.9050004@redhat.com> <56322E39.6020602@dev.mellanox.co.il>
 <5632305A.6050800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5632305A.6050800-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I can provide a patch for hfi, anything else needed?
>
> It breaks all of them in staging, not just hgi1.  So, hfi1, amso1100,
> ipath, and ehca.

hfi1: Does not support FRWR at all, there are just some copy-paste
sections that supposedly handle it - so I'll drop any sign of it from
the code. We'll add this support to the generic for qib, hfi, softroce.

ipath: same

amso1100 & ehca: it does not have FRWR at all - no sign of it in terms
of code... did they really break?

I'll send a patch for hfi1 and ipath.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
