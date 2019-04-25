From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
Date: Wed, 24 Apr 2019 17:36:16 -0700
Message-ID: <20190424173616.03e69af2@cakuba.netronome.com>
References: <20190412175504.GA20857@kadam>
        <VI1PR0501MB22714D465D6CD60511FDFFD5D1280@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190415094610.GO6095@kadam>
        <VI1PR0501MB22713CCB1141529CCB6934B1D12B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190416082112.GA27670@kadam>
        <AM4PR0501MB22609E4C9D126A096DD7F614D1240@AM4PR0501MB2260.eurprd05.prod.outlook.com>
        <20190420095102.GA14798@kadam>
        <VI1PR0501MB22713B232B3CF42B849F959BD1220@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190423154943.GC14820@kadam>
        <AM4PR0501MB2260ADC1DA37E87D01979969D1230@AM4PR0501MB2260.eurprd05.prod.outlook.com>
        <20190424140820.GB14798@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190424140820.GB14798@kadam>
Sender: netdev-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Eli Cohen <eli@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 24 Apr 2019 17:08:20 +0300, Dan Carpenter wrote:
> To me making "vf" a u32 throughout seems like a good idea but it's an
> extensive patch and I'm not really able to test it at all.  But maybe
> there is a better place to check for negatives.  Or maybe we are already
> checking for negatives and I haven't seen it.  (I don't know this code
> very well at all).

Could we please add the checks in the core?

We already have the infra in place for calculating dump sizes - i.e.

int num_vfs = dev_num_vf(dev->dev.parent);

We just need to validate the set params.


Callback parameters should really be validated by the core to the extent
possible, unfortunately driver authors have little incentive to improve
that once an API is implemented, realistically we all need to support
old kernels wouldn't do the checking..
