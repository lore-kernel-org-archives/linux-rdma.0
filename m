From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Tue, 7 Jun 2016 08:26:45 +0000
Message-ID: <VI1PR05MB1391BC017005F864E1DAE3C0D25D0@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-7-git-send-email-leon@kernel.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <85e56121-5911-37f4-2ac3-a1af561d5a7a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
> Sent: Tuesday, June 07, 2016 2:54 AM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
> 
> This patch is both right and wrong.  You're right with the intent (that
> there should be a total of 2 extra entries in the array size, one for
> the NULL termination and one for the lifespan entry), but wrong with the
> mechanics (unless I've missed something).  We already have two extra
> entries because sizeof(*hsag) includes our first counter, so just
> num_counters is actually enough to NULL terminate the list, and + 1
> gives us lifespan plus a NULL terminate spot.  The comment could be
> cleaned up to make this more clear though, so I'll do that.

Hi doug,
I might be missing something, but:

hsag = kzalloc(sizeof(*hsag) +
		sizeof(void *) * (stats->num_counters + 1)
                       	GFP_KERNEL);

So now we have hsag and after it num_counters + 1 slots.
Now we need attrs to point to a memory location, so we do:

hsag->attrs = (void *)hsag + sizeof(*hsag);

which means hsag->attrs is now pointing to a memory location right
after hsag (remember we have num_counters + 1) slots there.

for (i = 0; i < stats->num_counters; i++) {
                hsag->attrs[i] = alloc_hsa(i, port_num, stats->names[i]);
                if (!hsag->attrs[i])
                        goto err;
                sysfs_attr_init(hsag->attrs[i]);
}

/* treat an error here as non-fatal */
 hsag->attrs[i] = alloc_hsa_lifespan("lifespan", port_num);

The for loop fills num_counters slots, and after that alloc_hsa_lifespan uses another one.
Which means we used all our slots and we are missing one as the NULL slot.

Of course I might be wrong/missing something, it wouldn't be the first time :)

Mark

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
