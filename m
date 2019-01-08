From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Return the correct opcode
 when creating WR
Date: Tue, 8 Jan 2019 16:48:57 -0700
Message-ID: <20190108234857.GC30436@ziepe.ca>
References: <1546903346-15461-1-git-send-email-aditr@vmware.com>
 <20190107232815.GP27929@mellanox.com>
 <ccacbd86-8d35-06a4-fe04-0144405d4638@vmware.com>
 <20190108031051.GC5336@ziepe.ca>
 <01aef10a-8b54-5ff5-0f90-d74d8c4c70cc@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01aef10a-8b54-5ff5-0f90-d74d8c4c70cc@vmware.com>
Sender: stable-owner@vger.kernel.org
To: Adit Ranadive <aditr@vmware.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Pv-drivers <Pv-drivers@vmware.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 08, 2019 at 06:39:02PM +0000, Adit Ranadive wrote:

> >> Not sure if I follow you. We can post a failure but that would be 
> >> in pvrdma_qp.c when it looks at the opcode returned from here. We 
> >> would have to handle all the IB enums here though if you don't want 
> >> a default case (you would get compiler warnings otherwise).  
> > 
> > You'd do something like
> > 
> > default:
> >    return PVRDMA_WR_ERROR;
> > 
> > And something, somewhere, should fail the posting.
> > 
> > Jason
> > 
> 
> Okay. So maybe something like this, would work:

Yes, this is what I was thinking, please send a patch

Jason
