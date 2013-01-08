From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 00/11] Critical bug fixes for RDMA/cxgb4
Date: Mon, 7 Jan 2013 16:33:11 -0800
Message-ID: <CAL1RGDWra_K=BKUY04dUdCQwJcCOf+FHYrsQb2jA9+eM2ygqCw@mail.gmail.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 7, 2013 at 5:11 AM, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> This patch series fixes critical bugs for RDMA/cxgb4. It fixes bugs in following
> areas:
> - Aborts connection in error scenarios
> - Logs only critical errors
> - Holds the reference of the QP untill TID is released
> - Avoids race condition in endpoint timeout
> - Fixes reconnect and version mismatch related bugs in MPAv2 related logic
> - Avoids removing hwtid which was not inserted
> - Addresses several sparse warnings

How can sparse warnings be a critical bug?

Which of these patches are really needed for 3.8?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
