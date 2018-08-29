From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/3] IB/ipoib: Stop using dev_id to expose port numbers
Date: Wed, 29 Aug 2018 12:44:31 +0300
Message-ID: <d48633cb-a99a-50af-6e47-13b87008cddc@cogentembedded.com>
References: <20180828210117.6437-1-ar@cs.msu.ru>
 <20180828210117.6437-3-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828210117.6437-3-ar@cs.msu.ru>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>, linux-rdma@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello!

On 8/29/2018 12:01 AM, Arseny Maslennikov wrote:

> Some InfiniBand network devices have multiple ports on the same PCI
> function. Prior to this the kernel erroneously used the `dev_id' sysfs
> field of those network interfaces to convey the port number to userspace.
> 
> `dev_id' is currently reserved for distinguishing stacked ifaces
> (e.g: VLANs) with the same hardware address as their parent device.
> 
> Similar fixes to net/mlx4_en and many other drivers, which started
> exporting this information through `dev_id' before 3.15, were accepted
> into the kernel 4 years ago.
> See 76a066f2a2a0268b565459c417b59724b5a3197b, commit message:
> `net/mlx4_en: Expose port number through sysfs'.

    See commit 76a066f2a2a0 ("net/mlx4_en: Expose port number through sysfs").
> This commit is separated from the previous one since we may wish to
> preserve backwards compatibility with userspace being already dependent
> on `dev_id' being different.
> 
> Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
[...]

MBR, Sergei
