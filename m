From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/mlx4: Spread completion vectors for proxy CQs
Date: Wed, 20 Feb 2019 10:14:41 -0700
Message-ID: <20190220171441.GH8429@ziepe.ca>
References: <20190218183302.1242676-1-haakon.bugge@oracle.com>
 <38187795-4082-42C2-AF56-E6C89EE7DE39@oracle.com>
 <66C92ED1-EE5E-4136-A7D7-DBF8A0816800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <66C92ED1-EE5E-4136-A7D7-DBF8A0816800@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, jackm@dev.mellanox.co.il, majd@mellanox.com, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 19, 2019 at 06:32:50PM +0100, Håkon Bugge wrote:
>    Anyway, Jason mentioned in a private email that maybe we could use the
>    new completion API or something? I am not familiar with that one
>    (yet).

I was thinking of the stuff in core/cq.c - but it also doesn't have
automatic comp_vector balancing. It is the logical place to put
something like that though..

An API to manage a bundle of CPU affine CQ's is probably what most
ULPs really need.. (it makes little sense to create a unique CQ for
every QP)

alloc_bundle()
get_cqn_for_flow(bundle)
alloc_qp()
destroy_qp()
put_cqn_for_flow(bundle)
destroy_bundle();

Let the core code balance the cqn's and allocate (shared) CQ
resources.

Jason
