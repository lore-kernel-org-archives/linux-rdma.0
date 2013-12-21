From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 opensm] Add support for synchronizing in memory files
 with storage
Date: Sat, 21 Dec 2013 11:33:42 -0500
Message-ID: <52B5C2E6.9050905@dev.mellanox.co.il>
References: <52B58F98.7040804@dev.mellanox.co.il> <52B59E5D.4000207@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B59E5D.4000207-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Mott <jim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/21/2013 8:57 AM, Bart Van Assche wrote:
> On 12/21/13 13:54, Hal Rosenstock wrote:
>> -int osm_db_store(IN osm_db_domain_t * p_domain)
>> +int osm_db_store(IN osm_db_domain_t * p_domain,
>> +		 IN boolean_t fsync_high_avail_files)
> 
> Version two of this patch looks fine to me, but while reviewing this
> patch I noticed two issues in osm_db_store() that might need to be
> addressed:
> * With p_domain_imp->dirty == FALSE cl_spinlock_release() is called
> without having invoked cl_spinlock_acquire() first. Can the 'dirty' flag
> be modified concurrently with the test of the 'dirty' flag ? If so, the
> test of this flag probably has to occur after the spinlock has been
> acquired.

Yes; I'll fix this in a subsequent patch.

> * If the malloc() call for allocating the temporary file name fails then
> strcpy() will be called with NULL as first argument. Shouldn't the
> return value of malloc() be checked ?

Ditto.

Thanks.

-- Hal

> Thanks,
> 
> Bart.
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
