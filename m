Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C33280CFC
	for <linux-rdma@vger.kernel.org>; Sat, 28 Feb 2026 06:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772258857; cv=none; b=ix9NuyQRuinMN/fn/mpWQGFhn7ojQWVmWomD9Yk1phpRkJ7xcz63EvpyHIZxuGm8vDx6f0dZULpqJBOvf5tcNJ9oZcskxh3Vao0n4Iq/mFbtxXuwMJkbabXsrufYQ9yJZOQAcWfUkpD1ri8/zZRtiQbm2YuqPHIEFBSrdgbYcVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772258857; c=relaxed/simple;
	bh=klETYOI6rFQ8d0aZx+ayWEPKdsN7JG4laI2Qr6IKSpE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=mvDXqytic996LvH9DOPr1DySA6RrIe/Ee5+bh2xzu9gdl/zsYOqZ+5ndLHYhUxdSMxr0C92sGlmsHVV28L09/ZqjkJTITJzL2RFL0SDmt8qNG+ZsfdfxFY8iYMGwOlvzQdP6NhRTyLjUpMPspqJxCuQ1OqIUIXfM1tY8XBytndk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 61S67V9U003606;
	Sat, 28 Feb 2026 15:07:31 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.2] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 61S67VBN003597
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 28 Feb 2026 15:07:31 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <d800131b-d257-4dc7-adcf-7c35e7a223d2@I-love.SAKURA.ne.jp>
Date: Sat, 28 Feb 2026 15:07:29 +0900
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [rdma] "rdma link del" operation hangs at wait_for_completion()
 when a file descriptor is in use.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: OFED mailing list <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
References: <cc96166a-a469-4bc9-bfbe-de6f40dffe97@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <cc96166a-a469-4bc9-bfbe-de6f40dffe97@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav405.rs.sakura.ne.jp

On 2025/12/04 17:26, Tetsuo Handa wrote:
> I found that running the attached example program causes khungtaskd message. What is wrong?

I found that this is a deadlock caused by "struct ib_device_ops"->disassociate_ucontext == NULL.
If the thread which called ib_uverbs_remove_one() is unable to call ib_uverbs_release_file()
 from ib_uverbs_close() because it is blocked at wait_for_completion(), it forms a deadlock.
I think that we need to make the following change, by providing non-NULL disassociate_ucontext
callback.

By the way, it seems that all non-NULL disassociate_ucontext callback users are passing no-op
function as callback. What is needed for safely disassociate ucontex for those who currently
do not provide disassociate_ucontext callback? If nothing is needed, can we remove
disassociate_ucontext callback?


diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 7b68967a6301..f1e20928391b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -1248,43 +1248,39 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 	}
 	mutex_unlock(&uverbs_dev->lists_mutex);
 
 	uverbs_disassociate_api(uverbs_dev->uapi);
 }
 
 static void ib_uverbs_remove_one(struct ib_device *device, void *client_data)
 {
 	struct ib_uverbs_device *uverbs_dev = client_data;
-	int wait_clients = 1;
 
 	cdev_device_del(&uverbs_dev->cdev, &uverbs_dev->dev);
 	ida_free(&uverbs_ida, uverbs_dev->devnum);
 
 	if (device->ops.disassociate_ucontext) {
 		/* We disassociate HW resources and immediately return.
 		 * Userspace will see a EIO errno for all future access.
 		 * Upon returning, ib_device may be freed internally and is not
 		 * valid any more.
 		 * uverbs_device is still available until all clients close
 		 * their files, then the uverbs device ref count will be zero
 		 * and its resources will be freed.
 		 * Note: At this point no more files can be opened since the
 		 * cdev was deleted, however active clients can still issue
 		 * commands and close their open files.
 		 */
 		ib_uverbs_free_hw_resources(uverbs_dev, device);
-		wait_clients = 0;
 	}
 
 	if (refcount_dec_and_test(&uverbs_dev->refcount))
 		ib_uverbs_comp_dev(uverbs_dev);
-	if (wait_clients)
-		wait_for_completion(&uverbs_dev->comp);
 
 	put_device(&uverbs_dev->dev);
 }
 
 static int __init ib_uverbs_init(void)
 {
 	int ret;
 
 	ret = register_chrdev_region(IB_UVERBS_BASE_DEV,

