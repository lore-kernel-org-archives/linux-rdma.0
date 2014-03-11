From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/iser: Suppress completion for fast registration
 work requests
Date: Tue, 11 Mar 2014 16:53:18 +0200
Message-ID: <531F235E.3080604@mellanox.com>
References: <1390473088-5160-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390473088-5160-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 23/01/2014 12:31, Or Gerlitz wrote:
> From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> In case iSER uses fast registration method, it should not
> request for successful completions on fast registration nor
> local invalidate. We color wr_id with ISER_FRWR_LI_WRID in
> order to correctly consume error completions.

Hi Roland, just a reminder that this is pending for 3.15, and also 
needed as pre-patch for the initiator T10 patches,
and other initiator patches we intend to submit soon.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
