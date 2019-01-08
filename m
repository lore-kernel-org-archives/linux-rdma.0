From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] IB/srp: Use struct_size() in kzalloc()
Date: Tue, 08 Jan 2019 12:32:57 -0800
Message-ID: <1546979577.83374.30.camel@acm.org>
References: <20190108160805.GA22698@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108160805.GA22698@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2019-01-08 at 10:08 -0600, Gustavo A. R. Silva wrote:
+AD4 One of the more common cases of allocation size calculations is finding the
+AD4 size of a structure that has a zero-sized array at the end, along with memory
+AD4 for some number of elements for that array. For example:
+AD4 
+AD4 struct foo +AHs
+AD4     int stuff+ADs
+AD4     void +ACo-entry+AFsAXQA7
+AD4 +AH0AOw
+AD4 
+AD4 instance +AD0 kzalloc(sizeof(struct foo) +- sizeof(void +ACo) +ACo count, GFP+AF8-KERNEL)+ADs
+AD4 
+AD4 Instead of leaving these open-coded and prone to type mistakes, we can now
+AD4 use the new struct+AF8-size() helper:
+AD4 
+AD4 instance +AD0 kzalloc(struct+AF8-size(instance, entry, count), GFP+AF8-KERNEL)+ADs
+AD4 
+AD4 This code was detected with the help of Coccinelle.
+AD4 
+AD4 Signed-off-by: Gustavo A. R. Silva +ADw-gustavo+AEA-embeddedor.com+AD4
+AD4 ---
+AD4  drivers/infiniband/ulp/srp/ib+AF8-srp.c +AHw 3 +---
+AD4  1 file changed, 1 insertion(+-), 2 deletions(-)
+AD4 
+AD4 diff --git a/drivers/infiniband/ulp/srp/ib+AF8-srp.c b/drivers/infiniband/ulp/srp/ib+AF8-srp.c
+AD4 index 31d91538bbf4..0f855294ff3f 100644
+AD4 --- a/drivers/infiniband/ulp/srp/ib+AF8-srp.c
+AD4 +-+-+- b/drivers/infiniband/ulp/srp/ib+AF8-srp.c
+AD4 +AEAAQA -443,8 +-443,7 +AEAAQA static struct srp+AF8-fr+AF8-pool +ACo-srp+AF8-create+AF8-fr+AF8-pool(struct ib+AF8-device +ACo-device,
+AD4  	if (pool+AF8-size +ADwAPQ 0)
+AD4  		goto err+ADs
+AD4  	ret +AD0 -ENOMEM+ADs
+AD4 -	pool +AD0 kzalloc(sizeof(struct srp+AF8-fr+AF8-pool) +-
+AD4 -		       pool+AF8-size +ACo sizeof(struct srp+AF8-fr+AF8-desc), GFP+AF8-KERNEL)+ADs
+AD4 +-	pool +AD0 kzalloc(struct+AF8-size(pool, desc, pool+AF8-size), GFP+AF8-KERNEL)+ADs
+AD4  	if (+ACE-pool)
+AD4  		goto err+ADs
+AD4  	pool-+AD4-size +AD0 pool+AF8-size+ADs

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4-
