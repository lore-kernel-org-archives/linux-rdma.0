From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: External memory binding for HW resources
Date: Mon, 4 Sep 2017 19:46:56 -0600
Message-ID: <20170905014656.GA24178@obsidianresearch.com>
References: <1504533302-11998-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504533302-11998-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuemingl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 04, 2017 at 04:55:02PM +0300, Yishai Hadas wrote:
> From: Xueming Li <xuemingl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add a new DV API mlx5dv_set_context_attr() to enable setting an external
> memory allocator. This API will allow the application to use specific
> decisions about the memory allocation of HW resources (e.g. DV objects).
> Some examples are managing numa pinning per object, managing a
> hugepages resource pool, shared memory regions.
> 
> Also extend mlx5dv_get_qp() to return UAR mapping info. This can allow a
> process to share its doorbell access with secondary process by re-mmap
> the UAR address on the device and make it accessible as a user space
> address.

Why two unrelated changes in one patch?

Everything else looks fine to me

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
