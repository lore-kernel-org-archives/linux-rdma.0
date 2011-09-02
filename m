From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] [PATCH] Fix invalid error check, which lead to segfault
Date: Fri, 2 Sep 2011 09:46:24 +0300
Message-ID: <20110902064208.GA1998@calypso>
References: <1314919847.25283.446.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1314919847.25283.446.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 16:30 Thu 01 Sep     , Albert Chu wrote:
> This patch fixes a bug from:
> 
> commit 350c6e49fe3ee492b397346633dee76d3cad9ade
> Author: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Mon Mar 7 10:03:59 2011 +0000
> 
>     opensm: fixed potential memory leak in osm_ucast_ftree()
> 
>     Need to free all the allocated variables in case of error.
> 
> The invalid error check would lead to sw_create() always returning NULL,
> leading to fabric_add_sw() never adding a switch to sw_tbl, leading to
> fabric_get_sw_by_guid() always returning NULL (i.e. can't find switch),
> leading to rank_leaf_switches() segfaulting.
>

Applied, thanks. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
