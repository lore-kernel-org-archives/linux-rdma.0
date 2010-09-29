From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
Date: Wed, 29 Sep 2010 21:29:31 +0200
Message-ID: <201009292129.31415.arnd@arndb.de>
References: <20100929141112.26944.21931.stgit@build.ogc.int> <201009292117.54828.arnd@arndb.de> <ada4od82w5x.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <ada4od82w5x.fsf@cisco.com>
Sender: linux-next-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wednesday 29 September 2010 21:21:14 Roland Dreier wrote:
> 
>  > The main difference between default_llseek and generic_file_llseek
>  > is that default_llseek doesn't care about the maximum file size
>  > of the underlying file system, which is ULONG_MAX on debugfs,
>  > so they are equivalent.
> 
> I thought default_llseek also takes the BKL still?

Not any more in linux-next.

>  > In general, the preferred one is no_llseek for those files where
>  > you know you do not need to seek. If you do, I'd use default_llseek
>  > for character devices and generic_file_llseek for file systems
>  > that set the s_maxbytes.
> 
> The case in question is for debugfs files, so we should use
> generic_file_llseek, right?

Yes, but it's a very weak "should". My automatic conversion script
uses default_llseek.

	Arnd
