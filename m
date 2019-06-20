From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 20 Jun 2019 17:42:50 -0600
Message-ID: <3379917c-0ebc-0019-a71c-12248f4668ee@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <91eba9a0-27b4-08b4-7c12-86e24e1bfe85@deltatee.com>
 <CAPcyv4gPOXaL3qks6RMufu==O9RV2m_-7bBmJqKOFYTf4v_jXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gPOXaL3qks6RMufu==O9RV2m_-7bBmJqKOFYTf4v_jXQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-20 5:40 p.m., Dan Williams wrote:
> This seems to be the most salient point. I was missing the fact that
> this replaces custom hacks and "special" pages with an explicit "just
> pass this pre-mapped address down the stack". It's functionality that
> might plausibly be used outside of p2p, as long as the driver can
> assert that it never needs to touch the data with the cpu before
> handing it off to a dma-engine.

Yup, that's a good way to put it. If I resend this patchset, I'll
include wording like yours in the cover letter.

Logan
