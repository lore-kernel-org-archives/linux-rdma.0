From: Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH] opensm: fixed segfault in osm_destroy
Date: Thu, 12 Jan 2012 11:07:40 -0600 (CST)
Message-ID: <alpine.DEB.2.02.1201121104200.7415@cantor.americas.sgi.com>
References: <20120112141435.GC6571@calypso>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120112141435.GC6571@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 12 Jan 2012, Alex Netes wrote:

> Fixed segfault in osm_destroy() when hop_weights_file,
> port_search_ordering_file or io_guid_file are configured.
>
> The segfault introduced by d71a924736707400bed47a3c69395cf864c970bb.
>
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> opensm/main.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
>

The fix looks good, and works too!  Thanks.

Dale
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
