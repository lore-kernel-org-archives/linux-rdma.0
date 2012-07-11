From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/6] IB/mthca: Events received for non-existent
 QPs should generate a warning
Date: Wed, 11 Jul 2012 08:40:11 -0700
Message-ID: <CAL1RGDUdUm2=UR4N4McTFJ7S9YJPzhH_V4Eym3DFjj5fzXgpYQ@mail.gmail.com>
References: <1342020825-18878-1-git-send-email-ogerlitz@mellanox.com> <1342020825-18878-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342020825-18878-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 11, 2012 at 8:33 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> -               mthca_warn(dev, "Async event for bogus QP %08x\n", qpn);
> +               mthca_warn(dev, "Async event %d for bogus QP %08x\n",
> +                         (int) event_type, qpn);

Looks fine -- just wondering if there's a reason to cast from enum to int?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
