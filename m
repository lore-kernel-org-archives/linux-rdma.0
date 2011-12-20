From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib/core: Protect QP mcast list
Date: Tue, 20 Dec 2011 23:28:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325661CF9@ORSMSX102.amr.corp.intel.com>
References: <20111219070952.GA11530@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111219070952.GA11530@mtldesk30>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -1910,12 +1911,15 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file
> *file,
> 
>  	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
> 
> +	spin_lock(&qp->mcast_lock);
>  	list_for_each_entry(mcast, &obj->mcast_list, list)
>  		if (cmd.mlid == mcast->lid &&
>  		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
>  			ret = 0;
> +			spin_unlock(&qp->mcast_lock);
>  			goto out_put;
>  		}
> +	spin_unlock(&qp->mcast_lock);

Does the lower level code protect against trying to join the same group twice?  The locking ends up looking racy here, with the lock being dropped between checking the list and adding the new entry.

> @@ -1961,6 +1968,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file
> *file,
> 
>  	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
> 
> +	spin_lock(&qp->mcast_lock);
>  	list_for_each_entry(mcast, &obj->mcast_list, list)
>  		if (cmd.mlid == mcast->lid &&
>  		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
> @@ -1968,6 +1976,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file
> *file,
>  			kfree(mcast);
>  			break;
>  		}
> +	spin_unlock(&qp->mcast_lock);

I wonder if the uverbs code should prevent the user from trying to join a group twice and prevent it from leaving a group that it hasn't joined.  This is a separate question from these patches, but it would affect how the locking is held. 

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
