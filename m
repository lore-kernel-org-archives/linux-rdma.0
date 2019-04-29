From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] rds: ib: force endiannes annotation
Date: Mon, 29 Apr 2019 05:22:10 -0700
Message-ID: <20190429122210.GB32474@infradead.org>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
 <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
 <20190429111836.GA17830@osadl.at>
 <2ffed5fc-a372-3f90-e655-bcbc740eed33@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2ffed5fc-a372-3f90-e655-bcbc740eed33@solarflare.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Edward Cree <ecree@solarflare.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, Nicholas Mc Guire <hofrat@osadl.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 01:02:31PM +0100, Edward Cree wrote:
> ... are some bitwise ops on the values (bitwise ops are legal in any
>  endianness) and incrementation of the pointers (which cares only about
>  the pointee size, not type).

Oh, true.  That is why the underlying annotation is called __bitwise :)
I'll take my previous comment back.
