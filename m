From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging/rdma/hfi1: Delete unnecessary checks before two
 function calls
Date: Thu, 5 Nov 2015 11:18:00 +0300
Message-ID: <20151105081800.GU18797@mwanda>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <563B0F07.3090301@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <563B0F07.3090301@users.sourceforge.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: devel@driverdev.osuosl.org, Julia Lawall <julia.lawall@lip6.fr>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 09:10:47AM +0100, SF Markus Elfring wrote:
> diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
> index aae9826..204d1d0 100644
> --- a/drivers/staging/rdma/hfi1/file_ops.c
> +++ b/drivers/staging/rdma/hfi1/file_ops.c
> @@ -313,7 +313,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
>  	case HFI1_CMD_SDMA_STATUS_UPD:
>  		break;
>  	case HFI1_CMD_CREDIT_UPD:
> -		if (uctxt && uctxt->sc)
> +		if (uctxt)
>  			sc_return_credits(uctxt->sc);

Relying on hidden sanity checks makes the code harder to read.

regards,
dan carpenter
