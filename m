From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/22] Add SRIOV support for IB interfaces
Date: Sun, 12 Aug 2012 12:34:56 +0300
Message-ID: <502778C0.9050200@mellanox.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/08/2012 11:40, Jack Morgenstein wrote:
> This patch set adds SRIOV support for IB interfaces.
>
> Patches 1-4 are "precondition" patches.
> Patches 5-22 actually implement the feature.
>
> NOTE:  Patch 18 depends on patch IB/mlx4: fix possible deadlock with sm_lock spinlock
>         (a separately-submitted patch) being applied previously to the for-next git.

Hi Roland,

Any feedback on the patches? we want to see things are converging 
towards the 3.7 merge
window, such that people who want IB on their SRIOV systems have it. So 
if taking into account the volume of changes there's not too much 
time... can the review be continued?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
