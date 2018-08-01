From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 1/3] overflow.h: Add arithmetic shift helper
Date: Wed, 1 Aug 2018 11:07:24 +0300
Message-ID: <20180801080724.2vgzagooda56aypw@mwanda>
References: <20180801000039.44314-1-keescook@chromium.org>
 <20180801000039.44314-2-keescook@chromium.org>
 <20180801075744.qpppbaywp5dklxul@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801075744.qpppbaywp5dklxul@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 01, 2018 at 10:57:44AM +0300, Dan Carpenter wrote:
> The idea is nice, but I don't like the API.  The "_overflow" feels too
> specific because maybe we could check for other things in the future.
> Normally boolean macros should say they are boolean in the name and I
> would prefer if it returned zero on failure.
> 
> 	if (!checked_shift(dest, mask, shift)) {
> 	if (!shift_ok(dest, mask, shift)) {
> 	if (!safe_shift(dest, mask, shift)) {

Huh...  It turns out I put the argument order different as well.

If we wanted to keep it returning 1 on failure then some other names
are:

	if (shift_failed(dest, mask, shift)) {
	if (shift_error(dest, mask, shift)) {
	if (shift_overflow(dest, mask, shift)) {

regards,
dan carpenter
