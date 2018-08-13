From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] net, IB/ipoib: Use dev_port to disambiguate
Date: Mon, 13 Aug 2018 11:17:07 -0600
Message-ID: <20180813171707.GA13289@ziepe.ca>
References: <20180813114224.7065-1-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180813114224.7065-1-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 13, 2018 at 02:42:21PM +0300, Arseny Maslennikov wrote:
> Pre-3.15 userspace had trouble distinguishing different ports of a NIC
> on a single PCI bus/device/function. To solve this, a sysfs field `dev_port'
> was introduced quite a while ago (commit v3.14-rc3-739-g3f85944fe207), and
> some relevant device drivers were fixed to use it, but not in case of IPoIB.
> 
> The convention for some reason never got documented in the kernel, but
> was immediately adopted by userspace (notably udev[1][2], biosdevname[3])
> 
> 3/3 documents the sysfs field — that's why I'm CC-ing netdev.
> 
> This series was tested on current LTS and 4.18.
> 
> [1] https://lists.freedesktop.org/archives/systemd-devel/2014-June/020788.html
> [2] https://lists.freedesktop.org/archives/systemd-devel/2014-July/020804.html
> [3] https://github.com/CloudAutomationNTools/biosdevname/blob/c795d51dd93a5309652f0d635f12a3ecfabfaa72/src/eths.c#L38
> 
> Arseny Maslennikov (3):
>   IB/ipoib: Use dev_port to expose network interface port numbers
>   IB/ipoib: Stop using dev_id to expose port numbers
>   Documentation/ABI: document /sys/class/net/*/dev_port
> 
>  Documentation/ABI/testing/sysfs-class-net | 10 ++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)

This series doesn't apply to rdma for-next, and it is the merge window
now.

Can you resubmit this aginst 4.19-rc1 in two weeks? Thanks

Jason
