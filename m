From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC v2 07/10] IB/mlx5: Keep mlx5 MRs in a radix tree under
 device
Date: Fri, 01 Nov 2013 13:46:20 -0700
Message-ID: <5274131C.90601@acm.org>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-8-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-8-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/10/2013 5:24, Sagi Grimberg wrote:
> +	/* connect to MR tree */
> +	write_lock_irq(&table->lock);
> +	err = radix_tree_insert(&table->tree, mr->key & 0xffffff00, mr);
> +	write_unlock_irq(&table->lock);

The conversion from MR key into radix tree index occurs three times so 
maybe it's worth to introduce an (inline) helper function for this 
conversion.

Another comment about this conversion: is the mlx5 driver supported on 
32-bit platforms ? I think that 0xffffff00 should be changed into 
0xffffff00u to avoid that a compiler warning is triggered on 32-bit 
platforms.

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
