From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC 2/3] hw/virtio-rdma: VirtIO rdma device
Date: Fri, 19 Apr 2019 19:20:22 -0400
Message-ID: <20190419191910-mutt-send-email-mst@kernel.org>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
	<20190411110157.14252-3-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20190411110157.14252-3-yuval.shaia@oracle.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: linux-rdma@vger.kernel.org, cohuck@redhat.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 11, 2019 at 02:01:56PM +0300, Yuval Shaia wrote:
> diff --git a/include/standard-headers/linux/virtio_ids.h b/include/standard-headers/linux/virtio_ids.h
> index 6d5c3b2d4f..bd2c699450 100644
> --- a/include/standard-headers/linux/virtio_ids.h
> +++ b/include/standard-headers/linux/virtio_ids.h
> @@ -43,5 +43,6 @@
>  #define VIRTIO_ID_INPUT        18 /* virtio input */
>  #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
>  #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
> +#define VIRTIO_ID_RDMA         26 /* virtio crypto */
>  
>  #endif /* _LINUX_VIRTIO_IDS_H */


Please reserve an ID with the virtio TC.
Process:
- create a github issue
- post patch with Fixes: tag
- wait a bit
- if no comments on either ask for a vote

> -- 
> 2.20.1
