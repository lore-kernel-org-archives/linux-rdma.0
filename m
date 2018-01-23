From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v5 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Tue, 23 Jan 2018 10:54:33 -0700
Message-ID: <20180123175433.GI30670@ziepe.ca>
References: <20180122125119.26419-1-leon@kernel.org>
 <20180122125119.26419-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180122125119.26419-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 22, 2018 at 02:51:14PM +0200, Leon Romanovsky wrote:
> +	mutex_lock(&dev->res.mutex);
> +	hash_del_rcu(&res->node);
> +	mutex_unlock(&dev->res.mutex);
> +
> +	res->valid = false;
> +
> +	if (res->task)
> +		put_task_struct(res->task);
> +	synchronize_srcu(&dev->res.srcu);
> +}

This locking is wrong..

Nothing can invalidate internal elements of 'res' until
synchronize_srcu() returns, otherwise it creates races.

Eg here:

+	key = srcu_read_lock(&device->res.srcu);
+	hash_for_each_possible_rcu(device->res.hash, res, node, RDMA_RESTRACK_QP) {
+		if (idx < start) {
+			idx++;
+			continue;
+		}
+
+		if ((rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) != &init_pid_ns) ||
+		    (!rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) != task_active_pid_ns(res->task)))

Will use-after-put res->task

Didn't audit closely enough to tell if valid is OK or not. Why isn't
the hash_del sufficient? Why does valid exist?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
