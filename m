From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Thu, 28 Feb 2019 14:56:36 -0800
Message-ID: <1551394596.31902.209.camel@acm.org>
References: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaobo He <shaobo@cs.utah.edu>, linux-rdma@vger.kernel.org
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2019-02-28 at 15:38 -0700, Shaobo He wrote:
+AD4 In function +AGA-c4iw+AF8-dealloc+AF8-mw+AGA, variable mhp's value is printed after
+AD4 freed, which triggers undefined behavior according to this post:
+AD4 https://trust-in-soft.com/dangling-pointer-indeterminate/.
+AD4 
+AD4 This commit fixes it by swapping the order of +AGA-kfree+AGA and +AGA-pr+AF8-debug+AGA.
+AD4 
+AD4 Signed-off-by: Shaobo He +ADw-shaobo+AEA-cs.utah.edu+AD4
+AD4 ---
+AD4  drivers/infiniband/hw/cxgb4/mem.c +AHw 2 +--
+AD4  1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4 
+AD4 diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
+AD4 index 7b76e6f..bb8e0bc 100644
+AD4 --- a/drivers/infiniband/hw/cxgb4/mem.c
+AD4 +-+-+- b/drivers/infiniband/hw/cxgb4/mem.c
+AD4 +AEAAQA -684,8 +-684,8 +AEAAQA int c4iw+AF8-dealloc+AF8-mw(struct ib+AF8-mw +ACo-mw)
+AD4  			  mhp-+AD4-wr+AF8-waitp)+ADs
+AD4  	kfree+AF8-skb(mhp-+AD4-dereg+AF8-skb)+ADs
+AD4  	c4iw+AF8-put+AF8-wr+AF8-wait(mhp-+AD4-wr+AF8-waitp)+ADs
+AD4 -	kfree(mhp)+ADs
+AD4  	pr+AF8-debug(+ACI-ib+AF8-mw +ACU-p mmid 0x+ACU-x ptr +ACU-p+AFw-n+ACI, mw, mmid, mhp)+ADs
+AD4 +-	kfree(mhp)+ADs
+AD4  	return 0+ADs
+AD4  +AH0

Please quote the relevant paragraphs from the C standard. All I have found
about free() in ISO/IEC 9899:2017 is the following:

Description
The free function causes the space pointed to by ptr to be deallocated, that
is, made available for further allocation. If ptr is a null pointer, no
action occurs. Otherwise, if the argument does not match a pointer earlier
returned by a memory management function, or if the space has been
deallocated by a call to free or realloc, the behavior is undefined.

That is not sufficient to claim that the above code triggers undefined
behavior.

Bart.
