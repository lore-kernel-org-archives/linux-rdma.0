From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/core: Fix mgid key handling in SA agent multicast
 data-base
Date: Wed, 19 Nov 2014 11:13:27 +0200
Message-ID: <546C5F37.1090002@mellanox.com>
References: <1416388138-25669-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416388138-25669-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/19/2014 11:08 AM, Or Gerlitz wrote:
> Since this is a key field, correct handling requires that the group entry
> be deleted from the rb table, and then re-inserted with the new key,
> so that the table structure is properly maintained.
>
> The current code does not do this correctly. Correct operation
> requires that if the key-field gid has changed at all, it should
> be deleted and re-inserted, fix that.

Sean, FWIW and even just for the fun, SB some logs from Jack's debugging 
that could help you see the problem beyond the nice analysis done by 
Jack in the change-log:

> Suspected that re-balancing the rb tree confuses the find algorithm. 
> Verified:
> rdma_join_multicast: ENTERING
> CMA: ffff88087e0b4c00: cma_join_ib_multicast: cma_join_ib_multicast, 
> port=1, mgid = ff12:401b:ffff:0000:0000:0000:ffff:ffff
> mcast_find. ENTERING. port = 1, node=ffff8804543bf100
> ib_sa_get_mcmember_rec: mcast_find SUCCESS. dev=mlx5_0, start_port=1, 
> port=1, mgid=ff12:401b:ffff:0000:0000:0000:ffff:ffff
> mcast_insert.ENTERING. port = 1, *link = ffff8804543bf100
> mcast_insert. new grp mgid 0000:0000:0000:0000:0000:0000:0000:0000 , 
> curr group mgid ff12:401b:ffff:0000:0000:0000:ffff:ffff, 
> *link=ffff8804543bf100, -1
> mcast_insert. new grp mgid 0000:0000:0000:0000:0000:0000:0000:0000 , 
> curr group mgid ff12:a01b:fe80:0000:0000:de1e:0000:0000, 
> *link=ffff88086d74a900, -1
> mcast_insert. new grp mgid 0000:0000:0000:0000:0000:0000:0000:0000 , 
> curr group mgid ff12:a01b:fe80:0000:0000:e21e:0000:0000, 
> *link=ffff88084da54ac0, -1
> mcast_insert. new grp mgid 0000:0000:0000:0000:0000:0000:0000:0000 , 
> curr group mgid ff12:a01b:fe80:0000:0000:e41e:0000:0000, 
> *link=ffff8808976f5dc0, -1
> mcast_insert. new grp mgid 0000:0000:0000:0000:0000:0000:0000:0000 , 
> curr group mgid ff12:a01b:fe80:0000:0000:e61e:0000:0000, 
> *link=ffff880892e44ec0, -1
> mcast_insert. new grp mgid 0000:0000:0000:0000:0000:0000:0000:0000 , 
> curr group mgid ff12:a01b:fe80:0000:0000:e71e:0000:0000, 
> *link=ffff8804607d2ac0, -1
>
> mcast_insert. BEFORE insert color: root rb_node=ffff8804543bf100
> mcast_insert. AFTER root rb_node=ffff88086d74a900 <== rb tree 
> rebalanced (i.e., rotated) here.
>
> mcast_insert traversal. lgroup mgid 
> 0000:0000:0000:0000:0000:0000:0000:0000, node=ffff8807e987aac0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e71e:0000:0000, node=ffff8804607d2ac0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e61e:0000:0000, node=ffff880892e44ec0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e51e:0000:0000, node=ffff8802c5e0d700
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e41e:0000:0000, node=ffff8808976f5dc0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e31e:0000:0000, node=ffff88041a4f4f00
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e21e:0000:0000, node=ffff88084da54ac0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e11e:0000:0000, node=ffff88047244a1c0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:e01e:0000:0000, node=ffff880897de4dc0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:df1e:0000:0000, node=ffff8804904cfdc0
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:de1e:0000:0000, node=ffff88086d74a900
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:dd1e:0000:0000, node=ffff88038f5bf300
> mcast_insert traversal. lgroup mgid 
> ff12:a01b:fe80:0000:0000:dc1e:0000:0000, node=ffff88045c023f00
> mcast_insert traversal. lgroup mgid 
> ff12:401b:ffff:0000:0000:0000:0000:0001, node=ffff880451271b00
> mcast_insert traversal. lgroup mgid 
> ff12:401b:ffff:0000:0000:0000:ffff:ffff, node=ffff8804543bf100 <==== 
> Do not find this entry!
> mcast_insert traversal. lgroup mgid 
> ff12:601b:ffff:0000:0000:0000:0000:0001, node=ffff88045c023800
> mcast_insert traversal. lgroup mgid 
> ff12:601b:ffff:0000:0000:0000:0000:0002, node=ffff88046431aac0
> mcast_insert traversal. lgroup mgid 
> ff12:601b:ffff:0000:0000:0000:0000:0016, node=ffff88045c023300
> mcast_insert traversal. lgroup mgid 
> ff12:601b:ffff:0000:0000:0001:ff16:7520, node=ffff88047a04c600
> ucma_join_multicast: ENTERING
> rdma_join_multicast: ENTERING
> CMA: ffff880497488800: cma_join_ib_multicast: cma_join_ib_multicast, 
> port=1, mgid = ff12:401b:ffff:0000:0000:0000:ffff:ffff
> mcast_find. ENTERING. port = 1, node=ffff88086d74a900
> mcast_find. mgid ff12:401b:ffff:0000:0000:0000:ffff:ffff != group gid 
> ff12:a01b:fe80:0000:0000:de1e:0000:0000, node=ffff88086d74a900
> mcast_find. mgid ff12:401b:ffff:0000:0000:0000:ffff:ffff != group gid 
> ff12:a01b:fe80:0000:0000:e21e:0000:0000, node=ffff88084da54ac0
> mcast_find. mgid ff12:401b:ffff:0000:0000:0000:ffff:ffff != group gid 
> ff12:a01b:fe80:0000:0000:e41e:0000:0000, node=ffff8808976f5dc0
> mcast_find. mgid ff12:401b:ffff:0000:0000:0000:ffff:ffff != group gid 
> ff12:a01b:fe80:0000:0000:e61e:0000:0000, node=ffff880892e44ec0
> mcast_find. mgid ff12:401b:ffff:0000:0000:0000:ffff:ffff != group gid 
> ff12:a01b:fe80:0000:0000:e71e:0000:0000, node=ffff8804607d2ac0
> mcast_find. mgid ff12:401b:ffff:0000:0000:0000:ffff:ffff != group gid 
> ff12:a01b:fe80:0000:0000:e81e:0000:0000, node=ffff8807e987aac0
> mcast_find FAIL. loop=6, mgid=ff12:401b:ffff:0000:0000:0000:ffff:ffff
> ib_sa_get_mcmember_rec: mcast_find FAILED. dev=mlx5_0, start_port=1, 
> port=1, mgid=ff12:401b:ffff:0000:0000:0000:ffff:ffff
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
