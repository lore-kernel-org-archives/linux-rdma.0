From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 6/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 12:27:45 -0700
Message-ID: <CAL1RGDVZjTD0_B+Gp2e15eg1BeWwUS1LN3JFm2dFYNQynMkHjQ@mail.gmail.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-3-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-4-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-5-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-6-git-send-email-parav.pandit@emulex.com>
 <5abe3043-81f8-448a-9e55-b29e23f4eb9a@exht1.ad.emulex.com>
 <4F6A130E.2030602@systemfabricworks.com> <CAL1RGDXaV5nWoa5eHBHPCAomx04NHK2bA+yuuf4cqmF6RodrkQ@mail.gmail.com>
 <88B766C272F2C64B944B21AD078333151C964A63E7@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88B766C272F2C64B944B21AD078333151C964A63E7-/SwythR3zqxVRK6PHKByhFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> It does returns ocrdma_mr* on success. Why do you think it doesn't return? Below is the snippet.

Sorry, you're absoutely right.  I was looking at ocrdma_mbx_alloc_lkey().

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
