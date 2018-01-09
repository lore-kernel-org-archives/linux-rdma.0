From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Tue, 9 Jan 2018 10:17:18 -0700
Message-ID: <20180109171718.GC4518@ziepe.ca>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
 <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
 <e11259b7-5add-bf87-73d4-49483c90bf73@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e11259b7-5add-bf87-73d4-49483c90bf73@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "Amrani, Ram" <Ram.Amrani@cavium.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 07:04:16PM +0200, Max Gurtovoy wrote:
> hi Guys,
> did we forget taking this fix to mainline/stable or we found another
> solution ?

I thought it was going to NAB's tree.. My mistake, I put it back into
patchworks and it will get into for-next

Jason
