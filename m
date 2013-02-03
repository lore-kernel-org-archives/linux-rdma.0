From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] infiniband-diags: add dump_fts tool
Date: Sun, 03 Feb 2013 10:46:41 -0500
Message-ID: <510E8661.9070501@dev.mellanox.co.il>
References: <20130202163631.a57e92cf1988aed94a24a5f3@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130202163631.a57e92cf1988aed94a24a5f3-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/2/2013 7:36 PM, Ira Weiny wrote:
>>From 2708d0965e03de1f9ae722e38c8b72a808718a0d Mon Sep 17 00:00:00 2001
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Fri, 1 Feb 2013 18:13:59 -0500
> Subject: [PATCH 2/2] infiniband-diags: add dump_fts tool
> 
> dump_fts adds a faster version of the functionality of dump_[l|m]fts.sh.  This
> code is based off of the ibroute code and simply uses libibnetdisc to scan the
> fabric instead of using ibnetdiscover and letting ibroute requery all that data
> over again.  This improves things in 3 ways.
> 
> 1) performance improves by nearly 2 orders of magnitude.
> 2) this version greatly reduces the mads required and thus reduces the
>    impact on the fabric.
> 3) Everything is queried with DR paths which ensures if the routing tables are
>    bad on the cluster the query will still complete and give you the
>    information you were looking for.  (To be fair dump_lft.sh has the DR option
>    but it is currently buggy.)

Sweet ;-)

> Example runs on the ~1400 nodes of the Hyperion test cluster show:
> 
> 13:45:46 > time ./dump_lfts.sh > /dev/null
> 
> real    4m58.175s
> user    0m6.407s
> sys     0m17.983s
> 
> 13:53:12 > time ./dump_fts > /dev/null
> dump tables: linear forwarding table get failed

It would be helpful to print node name, guid, and/or LID such failures.

Also, in this specific case, any idea why get LFT failed ?

-- Hal

> 
> real    0m8.121s
> user    0m3.032s
> sys     0m3.342s
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
