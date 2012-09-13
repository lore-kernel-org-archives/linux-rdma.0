From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 02/22] IB/core: change pkey table lookups
 to support full and partial membership for the same pkey
Date: Thu, 13 Sep 2012 11:18:38 +0300
Message-ID: <505196DE.2030304@mellanox.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <201209121056.00309.jackm@dev.mellanox.co.il> <5050BCDD.50106@redhat.com> <201209131035.15318.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201209131035.15318.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13/09/2012 10:35, Jack Morgenstein wrote:
> I seem to recall that there were problems with IPoIB when partial membership pkeys are used.

There are some issues in the overall solution, since ARPs sent over the 
broadcast group reach
also nodes with partial membership their HCA generated pkey violation 
errors which is a bit annoying,
the IBTA has been dealing with this for a while, not sure where it stands.

But, all in all, the approach taken by IPoIB is to always use the full 
form of a pkey e.g 0x8001
and not 0x0001 when dealing with the core helper functions and within 
ipoib internally.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
