From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: fix first byte overwritten for AF_IB
Date: Wed, 17 Dec 2014 12:40:04 +0200
Message-ID: <54915D84.5000405@mellanox.com>
References: <1418744596-25251-1-git-send-email-jinpu.wang@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418744596-25251-1-git-send-email-jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/16/2014 5:43 PM, Jack Wang wrote:
> If user attach private data for AF_IB,

Just out of curiosity, can you share what was the motivation for you to 
use AF_IB?


Or.

> the first byte will
> be overwritten, because we always set the cma version no matter
> family is AF_IB, so move the version set inside if condition.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
