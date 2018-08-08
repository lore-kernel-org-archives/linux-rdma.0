From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v4 0/3] overflow.h: Add left-shift helper
Date: Wed, 8 Aug 2018 09:53:03 -0600
Message-ID: <20180808155303.GA6761@ziepe.ca>
References: <20180801212541.22889-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801212541.22889-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, Randy Dunlap <rdunlap@infradead.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 01, 2018 at 02:25:38PM -0700, Kees Cook wrote:
> This adds the left-shift overflow helper, selftests, and first usage.
> 
> -Kees
> 
> v4:
> - actually fix docs typo
> - rename to check_shl_overflow()
> v3:
> - add even more test cases (type mismatches, more signed overflows).
> - fix documentation typo on argument name.
> v2:
> - swap out selftests with framework from Rasmus, add lots more tests.
> - drop double-assignment in helper.
> 
> 
> Jason Gunthorpe (1):
>   overflow.h: Add arithmetic shift helper
> 
> Kees Cook (1):
>   test_overflow: Add shift overflow tests
> 
> Leon Romanovsky (1):
>   RDMA/mlx5: Fix shift overflow in mlx5_ib_create_wq

Applied to the RDMA for-next tree, thanks

Jason
