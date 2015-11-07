From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND 11/11] staging/rdma/hfi1: Workaround to prevent
 corruption during packet delivery
Date: Fri, 6 Nov 2015 19:25:31 -0800
Message-ID: <20151107032531.GA4920@kroah.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
 <1446858426-30509-12-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1446858426-30509-12-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Jubin John <jubin.john@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 06, 2015 at 08:07:06PM -0500, Jubin John wrote:
> --- a/drivers/staging/rdma/hfi1/hfi.h
> +++ b/drivers/staging/rdma/hfi1/hfi.h
> @@ -1084,6 +1084,10 @@ struct hfi1_devdata {
>  	/* Save the enabled LCB error bits */
>  	u64 lcb_err_en;
>  	u8 dc_shutdown;
> +
> +	/* receive context tail dummy address */
> +	volatile __le64 *rcvhdrtail_dummy_kvaddr;

There's no way that volatile here is actually correct, please fix.
