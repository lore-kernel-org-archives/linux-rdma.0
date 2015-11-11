From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 5/8] staging/rdma/hfi1: return early if setlink state was
 specified
Date: Wed, 11 Nov 2015 12:06:07 +0300
Message-ID: <20151111090607.GD18797@mwanda>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
 <1447220589-9067-6-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1447220589-9067-6-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: ira.weiny@intel.com
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, dledford@redhat.com, dennis.dalessandro@intel.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 12:43:06AM -0500, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Set link state was not supported and so we can return early in the parameter
> checks rather than falling through the switch clause.
> 
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  drivers/staging/rdma/hfi1/diag.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
> index 556a47591989..a489a79dd3b6 100644
> --- a/drivers/staging/rdma/hfi1/diag.c
> +++ b/drivers/staging/rdma/hfi1/diag.c
> @@ -999,16 +999,14 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
>  		 * Other are invalid.
>  		 */
>  		return -EINVAL;
> +	} else if (cmd == HFI1_SNOOP_IOCSETLINKSTATE) {
> +		/* We do not support the old setlink state */
> +		return -EINVAL;

Just delete it and let the default in the switch statement return
-ENOTTY.

regards,
dan carpenter
