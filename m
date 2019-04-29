From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] rds: ib: force endiannes annotation
Date: Mon, 29 Apr 2019 14:37:23 +0200
Message-ID: <20190429123723.GA18362@osadl.at>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
 <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
 <20190429111836.GA17830@osadl.at>
 <20190429122132.GA32474@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429122132.GA32474@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Edward Cree <ecree@solarflare.com>, Nicholas Mc Guire <hofrat@osadl.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 05:21:32AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 29, 2019 at 01:18:36PM +0200, Nicholas Mc Guire wrote:
> > changing uncongested to __le64 is not an option here - it would only move
> > the sparse warnings to those other locatoins where the ports that 
> > became uncongested are being or'ed into uncongested.
> 
> Than fix that a well.  Either by throwing in a conversion, or
> add {be,le}XX_{and,or} helpers.

ok - that is an option in that case - will try that route

thx!
hofrat
