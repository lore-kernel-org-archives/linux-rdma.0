From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH][V2] RDMA/nes: do not leak uninitialized resp.reserved to
 userspace Content-Type: text/plain; charset="utf-8"
 Content-Transfer-Encoding: 8bit
Date: Tue, 5 Sep 2017 15:45:09 +0100
Message-ID: <d999c3dc-6d24-84eb-0321-e5f97f3e7088@canonical.com>
References: <20170904133705.3980-1-colin.king@canonical.com>
 <20170905144041.GA13068@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170905144041.GA13068@ctung-MOBL3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chien Tin Tung <chien.tin.tung@intel.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 05/09/17 15:40, Chien Tin Tung wrote:
> On Mon, Sep 04, 2017 at 02:37:05PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> resp.reserved has not been initialized and so the copy_to_user (via
>> ib_copy_to_udata) is copying uninitialized data from the stack back
>> to user space which is a potential information leak. Fix this by
>> initializing all of resp to zero.
> 
> Reserved field is not copied as the length of reserved is subtracted
> from the size of resp and passed to ib_copy_to_udata.
> 
>  if (ib_copy_to_udata(udata, &resp, sizeof resp - sizeof resp.reserved)) {
> 
> 
> This patch is not necessary.

Apologies, I completely overlooked that.

> 
> Chien
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
