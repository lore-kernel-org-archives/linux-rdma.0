From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [RFC 3/3] RDMA/virtio-rdma: VirtIO rdma driver
Date: Sun, 14 Apr 2019 08:20:25 +0300
Message-ID: <20190414052024.GA2842@lap1>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
	<20190411110157.14252-4-yuval.shaia@oracle.com>
	<199a70a8-5926-66af-d2d7-b19a0a0f46a2@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <199a70a8-5926-66af-d2d7-b19a0a0f46a2@oracle.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: Yanjun Zhu <yanjun.zhu@oracle.com>
Cc: mst@redhat.com, linux-rdma@vger.kernel.org, cohuck@redhat.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org

> > +
> > +	wake_up(&dev->acked);
> > +
> > +	printk("%s\n", __func__);
> 
> Cool:-)
> 
> this line should be for debug?

Yes

> 
> Zhu Yanjun
> 
