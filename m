From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH/RFC] RDMA/iwcm: Get rid of enum iw_cm_event_status
Date: Tue, 10 May 2011 14:47:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373B9D9@ORSMSX101.amr.corp.intel.com>
References: <1305005199-4943-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305005199-4943-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> 
> The IW_CM_EVENT_STATUS_xxx values were used in only a couple of
> places;
> cma.c uses -Exxx values instead, and so do the amso1100, cxgb3 and cxgb4
> drivers -- only nes was using the enum values (with the mild consequence
> that all nes connection failures were treated as generic errors rather
> than reported as timeouts or rejections).
> 
> We can fix this confusion by getting rid of enum iw_cm_event_status and
> using a plain int for struct iw_cm_event.status, and converting nes to
> use -Exxx as the other iWARP drivers do.
> 
> This also gets rid of the warning
> 
>     drivers/infiniband/core/cma.c: In function 'cma_iw_handler':
>     drivers/infiniband/core/cma.c:1333:3: warning: case value '4294967185' not
> in enumerated type 'enum iw_cm_event_status'
>     drivers/infiniband/core/cma.c:1336:3: warning: case value '4294967186' not
> in enumerated type 'enum iw_cm_event_status'
>     drivers/infiniband/core/cma.c:1332:3: warning: case value '4294967192' not
> in enumerated type 'enum iw_cm_event_status'
> 
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
