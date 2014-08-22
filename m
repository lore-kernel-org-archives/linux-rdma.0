From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 0/7] Signature feature update
Date: Fri, 22 Aug 2014 11:22:46 -0700
Message-ID: <1408731766.24496.2.camel@haakon3.risingtidesystems.com>
References: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407948875-733-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi & Co,

On Wed, 2014-08-13 at 19:54 +0300, Sagi Grimberg wrote:
> Lately MKP posted some block data integrity updates over Linux-scsi (see https://lwn.net/Articles/606820/).
> These changes follow DIX draft 1.1 (see see https://oss.oracle.com/~mkp/docs/dix-1.1.pdf).
> The draft updates the execution parameters passed from SCSI midlayer
> to the LLDs with respect to data integrity feature.
> 
> This set updates signature feature accordingly.
> 
> Once Martin's patches will land mainline I'll also modify iSER
> to take relevant parameters from the scsi command structure.
> 
> This set consists of:
> - Patches #1, #2, #3 are minor fixes
> - Patch #4 is a preparation patch
> - Patches #5, #6 are code centralization
> - Patch #7 is an API update (modifies ib_core, mlx5, iser, isert)
> 
> Roland, there are some patches in iser-target code, but I'm pretty
> sure that they can go from your tree. Right Nic?
> 

Yep, no target dependencies here, so they should go through
infiniband.git.

Roland, are you planning to pick these up for v3.18..?

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
