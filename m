From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Fri, 1 Mar 2019 18:15:53 +0000
Message-ID: <010001693a7840a4-9fc27417-7088-431a-9ecd-6836c3293c9d-000000@email.amazonses.com>
References: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu> <1551394596.31902.209.camel@acm.org> <abf425b1-19ba-9cf5-8288-87ac0dbf6ac7@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <abf425b1-19ba-9cf5-8288-87ac0dbf6ac7@cs.utah.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaobo He <shaobo@cs.utah.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 Feb 2019, Shaobo He wrote:

> I think maybe the more problematic issue is that the value of a freed pointer
> is intermediate.

The pointer is not affected by freeing the data it points to. Thus it
definitely has the same value as before and is not indeterminate.

The pointer points now to an area of memory that could now be in use for
different purposes so maybe it could be taken as a dangerous situation.

But situations like that are common in code.
