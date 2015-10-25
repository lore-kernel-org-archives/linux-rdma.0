From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] staging: rdma: ipath: Use setup_timer
Date: Sat, 24 Oct 2015 18:59:51 -0700
Message-ID: <20151025015951.GB30763@kroah.com>
References: <1445653168-2883-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1445653168-2883-1-git-send-email-falakreyaz@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 24, 2015 at 07:49:28AM +0530, Muhammad Falak R Wani wrote:
> Use the timer API function setup_timer instead of init_timer, removing
> the structure field assignments.
> 
> <smpl>
> 
> @timer@
> expression e1,e2,e3,fn_ptr;
> @@
> -init_timer(&e1);
> +setup_timer(&e1, fn_ptr, e2);
> ... when != fn_ptr = e3
> -e1.function = fn_ptr;
> -e1.data = e2;
> 
> </smpl>
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  drivers/staging/rdma/ipath/ipath_driver.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

You sent me 4 patches all with the same subject :(

Please fix this up and resend.

thanks,

greg k-h
