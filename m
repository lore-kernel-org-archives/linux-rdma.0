From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Wed, 5 Sep 2018 16:47:27 +0100
Message-ID: <20180905164727.3108bce6@shemminger-XPS-13-9360>
References: <20180903161316.25121-1-ar@cs.msu.ru>
        <20180903161316.25121-4-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180903161316.25121-4-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon,  3 Sep 2018 19:13:16 +0300
Arseny Maslennikov <ar@cs.msu.ru> wrote:

> +	if (ndev->dev_id == ndev->dev_port) {
> +		netdev_info_once(ndev,
> +			"\"%s\" wants to know my dev_id. "
> +			"Should it look at dev_port instead?\n",
> +			current->comm);
> +		netdev_info_once(ndev,
> +			"See Documentation/ABI/testing/sysfs-class-net for more info.\n");
> +	}

Single line message is sufficient.
Also don't break strings in messages.

> +	}
> +
> +	ret = sprintf(buf, "%#x\n", ndev->dev_id);
> +
> +	return ret;

Why not?
	return sprintf...
