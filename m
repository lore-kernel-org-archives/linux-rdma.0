From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm SA DB: dump only if modified
Date: Tue, 12 Jan 2010 16:36:00 +0200
Message-ID: <20100112143600.GD574@me>
References: <4B4AE5B3.10504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B4AE5B3.10504-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:47 Mon 11 Jan     , Yevgeny Kliteynik wrote:
> Currently, if dumping SA DB is enabled, the file is dumped
> at every sweep. This patch adds "dirty" flag that denotes
> whether the SA DB needs to be dumped or not.
> 
> SA DB contains 3 types of data:
>  - informinfo records
>  - service records
>  - mcmember records
> 
> So the flag must be set in 6 places:
>  - add/remove informinfo record
>  - add/remove service records
>  - add/remove mcmember records
> 
> Another possible place for setting this flag is mcgroup
> create/delete (this is sometimes duplicated by the add/remove
> mcmember records), but I think that this is not needed:
> 
> The mcgroups w/o mcmembers can be created in two ways:
> 
> 1. By creating well-known mcgroup for a partition.
>    In this case when new instance of OSM is launched,
>    the same mcgroup should be creted anyway from the
>    partition configuration, so no need to force its
>    duplication in the SA DB file.
> 
> 2. By loading mcgroup from SA DB file.
>    In this case it's either mcgroup w/o members, which
>    is what's handled by (1), or it's mcgroup with members,
>    butthe members just weren't loaded yet.
> 
> So in both cases, no need to force SA DB dump.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
