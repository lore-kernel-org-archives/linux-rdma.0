From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4] coding-style: Clarify the expectations around bool
Date: Sun, 13 Jan 2019 08:49:36 -0800
Message-ID: <20190113164936.GW6310@bombadil.infradead.org>
References: <20190110234805.GN6890@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190110234805.GN6890@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Joe Perches <joe@perches.com>, Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 10, 2019 at 11:48:13PM +0000, Jason Gunthorpe wrote:
> +The Linux kernel bool type is an alias for the C99 _Bool type. bool values can
> +only evaluate to 0 or 1, and implicit or explicit conversion to bool
> +automatically converts the value to true or false. When using bool types the
> +!! construction is not needed, which eliminates a class of bugs.
> +
> +When working with bool values the true and false definitions should be used
> +instead of 0 and 1.
> +
> +bool function return types and stack variables are always fine to use whenever
> +appropriate. Use of bool is encouraged to improve readability and is often a
> +better option than 'int' for storing boolean values.

It's awkward to start a sentence with a lower case letter.  How about
rephrasing this paragraph and the following one as:

  Using bool as the return type of a function or as a variable is always
  fine when appropriate.  It often improves readability and is a better option
  than int for storing boolean values.  Using bool in data structures is
  more debatable; its size and alignment can vary between architectures.

> +Do not use bool if cache line layout or size of the value matters, its size
> +and alignment varies based on the compiled architecture. Structures that are
> +optimized for alignment and size should not use bool.
> +
> +If a structure has many true/false values, consider consolidating them into a
> +bitfield with 1 bit members, or using an appropriate fixed width type, such as
> +u8.
