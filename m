From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC] iw_cxgb4: drop check - dead code
Date: Sun, 20 Jan 2019 19:05:40 -0700
Message-ID: <20190121020540.GB18017@ziepe.ca>
References: <1547947633-10515-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547947633-10515-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Raju Rangoju <rajur@chelsio.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 20, 2019 at 02:27:13AM +0100, Nicholas Mc Guire wrote:

> Q:This also has an interesting dependency with no effect:
>   Depends on:... (INFINIBAND_USER_ACCESS [=n] || !INFINIBAND_USER_ACCESS [=n])
>   I assume htat INFINIBAND_USER_ACCESS=y should be required here ?

This has the effect to ensure that if USER_ACCESS is a module then so
is cxgb4, otherwise USER_ACCESS can be enabled or disabled

Jason
