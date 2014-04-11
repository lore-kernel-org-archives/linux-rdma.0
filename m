From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] Clean index map on exit
Date: Fri, 11 Apr 2014 19:55:58 +0200
Message-ID: <94B40A72-96D0-4865-955B-90F3319EB35C@gmx.net>
References: <EB3C2705-3925-49DD-8DB2-07BAE9E60A05@gmx.net> <1397235970.29001.23.camel@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397235970.29001.23.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> 
> Is the array always full ?
No, but it has to be zero-initialized and free(NULL) is fine.

idm_set() does:
if (!idm->array[idx_array_index(index)]) {
		if (idm_grow(idm, index) < 0)
(idm_grow does calloc().)

So I concluded unused entries have to be zero already and I don't put
a new constraint on struct index_map.

> is the maximum index of the array
> IDX_ARRAY_SIZE or could it be lower ?
It's fixed:
struct index_map
{
	void **array[IDX_ARRAY_SIZE];
};

> And what about idm, is it free()'d somewhere else ?
The owner has to take care of its struct index_map.  I can only free
the resources the map itself holds.
For what it's worth: all struct index_maps are declared statically.

Again, thank you for your quick feedback.

Best regards,
Hannes
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
