From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 opensm] Add support for synchronizing in memory files
 with storage
Date: Sat, 21 Dec 2013 14:57:49 +0100
Message-ID: <52B59E5D.4000207@acm.org>
References: <52B58F98.7040804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B58F98.7040804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Mott <jim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/21/13 13:54, Hal Rosenstock wrote:
> -int osm_db_store(IN osm_db_domain_t * p_domain)
> +int osm_db_store(IN osm_db_domain_t * p_domain,
> +		 IN boolean_t fsync_high_avail_files)

Version two of this patch looks fine to me, but while reviewing this
patch I noticed two issues in osm_db_store() that might need to be
addressed:
* With p_domain_imp->dirty == FALSE cl_spinlock_release() is called
without having invoked cl_spinlock_acquire() first. Can the 'dirty' flag
be modified concurrently with the test of the 'dirty' flag ? If so, the
test of this flag probably has to occur after the spinlock has been
acquired.
* If the malloc() call for allocating the temporary file name fails then
strcpy() will be called with NULL as first argument. Shouldn't the
return value of malloc() be checked ?

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
