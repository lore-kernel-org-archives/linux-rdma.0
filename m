From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 13/14] staging/rdma/hfi1: Add TID entry program function
 body
Date: Thu, 17 Dec 2015 15:06:45 +0300
Message-ID: <20151217120645.GJ5284@mwanda>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com>
 <1450335624-12134-14-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1450335624-12134-14-git-send-email-ira.weiny@intel.com>
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
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, dledford@redhat.com, Mitko Haralanov <mitko.haralanov@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 17, 2015 at 02:00:23AM -0500, ira.weiny@intel.com wrote:
> +	mutex_lock(&uctxt->exp_lock);
> +	/*
> +	 * The first step is to program the RcvArray entries which are complete
> +	 * groups.
> +	 */
> +	while (ngroups && uctxt->tid_group_list.count) {
> +		struct tid_group *grp =
> +			tid_group_pop(&uctxt->tid_group_list);
> +
> +		ret = program_rcvarray(fp, vaddr, grp, pagesets,
> +				       pageidx, dd->rcv_entries.group_size,
> +				       pages, tidlist, &tididx, &mapped);
> +		/*
> +		 * If there was a failure to program the RcvArray
> +		 * entries for the entire group, reset the grp fields
> +		 * and add the grp back to the free group list.
> +		 */
> +		if (ret <= 0) {
> +			tid_group_add_tail(grp, &uctxt->tid_group_list);
> +			hfi1_cdbg(TID,
> +				  "Failed to program RcvArray group %d", ret);
> +			goto unlock;

We print a failure message but we still return success when ret == 0.

> +		}

regards,
dan carpenter
