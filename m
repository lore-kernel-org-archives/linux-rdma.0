From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC 3/3] RDMA/virtio-rdma: VirtIO rdma driver
Date: Mon, 15 Apr 2019 18:07:52 -0700
Message-ID: <f133d122-5b00-2e3b-f5cc-efc6d2cc3d3b@acm.org>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
	<20190411110157.14252-4-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20190411110157.14252-4-yuval.shaia@oracle.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Yuval Shaia <yuval.shaia@oracle.com>, virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org, mst@redhat.com, cohuck@redhat.com, marcel.apfelbaum@gmail.com, linux-rdma@vger.kernel.org, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On 4/11/19 4:01 AM, Yuval Shaia wrote:
> +++ b/drivers/infiniband/hw/virtio/Kconfig
> @@ -0,0 +1,6 @@
> +config INFINIBAND_VIRTIO_RDMA
> +	tristate "VirtIO Paravirtualized RDMA Driver"
> +	depends on NETDEVICES && ETHERNET && PCI && INET
> +	---help---
> +	  This driver provides low-level support for VirtIO Paravirtual
> +	  RDMA adapter.

Does this driver really depend on Ethernet, or does it also work with
Ethernet support disabled?

> +static inline struct virtio_rdma_info *to_vdev(struct ib_device *ibdev)
> +{
> +	return container_of(ibdev, struct virtio_rdma_info, ib_dev);
> +}

Is it really worth to introduce this function? Have you considered to
use container_of(ibdev, struct virtio_rdma_info, ib_dev) directly instead
of to_vdev()?

> +static void rdma_ctrl_ack(struct virtqueue *vq)
> +{
> +	struct virtio_rdma_info *dev = vq->vdev->priv;
> +
> +	wake_up(&dev->acked);
> +
> +	printk("%s\n", __func__);
> +}

Should that printk() be changed into pr_debug()? The same comment holds for
all other printk() calls.

> +#define VIRTIO_RDMA_BOARD_ID	1
> +#define VIRTIO_RDMA_HW_NAME	"virtio-rdma"
> +#define VIRTIO_RDMA_HW_REV	1
> +#define VIRTIO_RDMA_DRIVER_VER	"1.0"

Is a driver version number useful in an upstream driver?

> +struct ib_cq *virtio_rdma_create_cq(struct ib_device *ibdev,
> +				    const struct ib_cq_init_attr *attr,
> +				    struct ib_ucontext *context,
> +				    struct ib_udata *udata)
> +{
> +	struct scatterlist in, out;
> +	struct virtio_rdma_ib_cq *vcq;
> +	struct cmd_create_cq *cmd;
> +	struct rsp_create_cq *rsp;
> +	struct ib_cq *cq = NULL;
> +	int rc;
> +
> +	/* TODO: Check MAX_CQ */
> +
> +	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
> +	if (!cmd)
> +		return ERR_PTR(-ENOMEM);
> +
> +	rsp = kmalloc(sizeof(*rsp), GFP_ATOMIC);
> +	if (!rsp) {
> +		kfree(cmd);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	vcq = kzalloc(sizeof(*vcq), GFP_KERNEL);
> +	if (!vcq)
> +		goto out;

Are you sure that you want to mix GFP_ATOMIC and GFP_KERNEL in a single
function?

Thanks,

Bart.
