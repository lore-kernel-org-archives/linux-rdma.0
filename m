From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv7 2/3] IB/core: added support to use rdma cgroup
 controller
Date: Tue, 1 Mar 2016 11:12:06 +0200
Message-ID: <56D55CE6.7030103@mellanox.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
 <1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 28/02/2016 16:13, Parav Pandit wrote:
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 00da80e..54ea8ce 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -343,28 +343,38 @@ int ib_register_device(struct ib_device *device,
>  
>  	ret = read_port_immutable(device);
>  	if (ret) {
> -		printk(KERN_WARNING "Couldn't create per port immutable data %s\n",
> -		       device->name);
> +		pr_warn("Couldn't create per port immutable data %s\n",
> +			device->name);
>  		goto out;

This change doesn't belong in the patch.
