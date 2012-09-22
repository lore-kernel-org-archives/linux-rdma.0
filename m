From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next V2 21/22] {NET,IB}/mlx4: Modify proxy/tunnel QP
 mechanism so that guests do no calculations
Date: Sat, 22 Sep 2012 03:25:47 -0700
Message-ID: <CAL1RGDXL1avTr-ZUC+aGpq5Z03X9H1scMm1GL3rw91qnhm-Prw@mail.gmail.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-22-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-22-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 3, 2012 at 1:40 AM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Previously, the structure of a guest's proxy QPs followed the structure of the PPF
> special qps (qp0 port 1, qp0 port 2, qp1 port 1, qp1 port 2, ...).
> The guest then did offset calculations on the sqp_base qp number that the PPF passed
> to it in QUERY_FUNC_CAP().
>
> This is now changed so that the guest does no offset calculations regarding proxy or
> tunnel QPs to use.  This change frees the PPF from needing to adhere to a specific
> order in allocating proxy and tunnel QPs.

It seems a little strange that you rewrite code that is only added
earlier in the same
patch series.  Is there any reason why we can't just add the right
code in the first place?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
