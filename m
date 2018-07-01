From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] vmw_pvrdma: Release netdev when vmxnet3 module is removed
Date: Sun, 1 Jul 2018 08:18:58 -0400
Message-ID: <20180701121857.GA20336@neilslaptop.think-freely.org>
References: <20180628135938.19625-1-nhorman@tuxdriver.com>
 <20180630191507.dtzpvvvicmphnzsz@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180630191507.dtzpvvvicmphnzsz@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@01.org, kbuild-all@01.org, linux-rdma@vger.kernel.org, Adit Ranadive <aditr@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 30, 2018 at 10:15:07PM +0300, Dan Carpenter wrote:
> Hi Neil,
> 
> I love your patch! Perhaps something to improve:
> 
> url:    https://github.com/0day-ci/linux/commits/Neil-Horman/vmw_pvrdma-Release-netdev-when-vmxnet3-module-is-removed/20180628-232414
> 
> smatch warnings:
> drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c:987 pvrdma_pci_probe() warn: variable dereferenced before check 'dev->netdev' (see line 985)
> 
Appreciate the smatch check, but this was caught by visual review and fixed in V2 already.

Best
Neil
