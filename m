Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1861844C4EA
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 20:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839391; cv=none; b=ZYRDCl1ViBq0IAth1VMP7ClsIivloIe24s2brWEcXd9Bu19gg+DX3RJinCtNxk5M1XJzBcXsh7qgw/92YkB8Wl+L83khJZtEsib2/AKuOzUu9NXLKFVdZKpHDtyjWrBuXFNPx9q+DSkosIIFiG36fJdS5E8HbvtTEKYq+RDUjnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839391; c=relaxed/simple;
	bh=IeQBFCH3bM4bVxRkUROK9805WYYXPr2VLMisCc8LPq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxaGrB6hwQYZ9B+PpQZ9gRroj6hw+pUJK2zRslrIdAoK1WBYZZoKlK3nTXSgq/C3tFWB0ZZqkFj9UMO+aSZMVC5esNalpL9UWgu5gfOscJ5U/KaUNc5HxRrNsvNBV+borb7Tzahl1zADZjlUq95vjsJDFo9Bphw3LIO7xfD1eMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=mF1+onUo; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="mF1+onUo"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47db714766aso493561f8f.0
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 13:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839380; x=1785444180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xY1kaJm76bL7mULPuQYN6MgHSE4hk4KEujLtUR/lx4I=;
        b=mF1+onUoH8g5krZlDyx9lcBqRTRrF8paWBw3zaSjWmlVE6WvKJ0hEWSwfUYbccpbQ1
         t9YUnOrozr0YB0sILt9Ctur/Nz1zQ/+OXnwO4Yateq4zcnMQslQTbkXRAru/PCvt6s0v
         oJii8kk5FyPuMEupv9MF29Mgc1Y5C6bhNWmwe7p0TOW3xEArB6PLHLZqPweAU+ntzo1B
         ktrg4VEg0Gh8PWx+hQQgfsVKYPv7TvjDzrQV917gexA2Xy6m7/K6teAHHecYcbfbwQil
         nTYInJ/HyX7DpgOhTOvw6luyy1O0Q+pApnsCG6gVUm6a/fJMfcX/7HCemMP8nZ376T66
         QUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839380; x=1785444180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xY1kaJm76bL7mULPuQYN6MgHSE4hk4KEujLtUR/lx4I=;
        b=cUpuEg6VdRqgl6NWVNLd7swuqHWrgO/m2j5e2BDKrXHEVq9rPlnXe0hcnxWbp5kc3u
         CqNOUk73Q0SOuc+C1Fc9sYFbtIQVCTOpnYPg2NQjTqFPE02Sg4/H2GazhmSLkPCTZHF0
         q8wBpQwkt0ozqZyQ+GFiOA5NZyNcsg6us5hyngoHd11oa39O2KGDlNWlAeN+Xfjj7WOz
         T75sNYH4WQwMseBna64Qv5NJIUp9PmwaxAGYxkxTXw0oDCpy361DlUlwq+k8ABZrLAdX
         sk/Jl3SuqMK+nY8QgoWgja+ctAYwC7b1It/PzXZVsXR5nOAhcb0MgyzWW2+TQNdSozJa
         4MDw==
X-Forwarded-Encrypted: i=1; AHgh+Rq0LIgUYqNrrKvkPvw4852jBsn4tLtA95nrv2sHfF4eoktm0HMo1mOjlDFCM5/r3oiRNkWBXAAmQ0yj@vger.kernel.org
X-Gm-Message-State: AOJu0YwiGc7rCD7+U9jb3CJysC3s/XdCkgj75ohO7KVYoJF2TQbMHLOY
	cbwV4ZqIm53ZJp+fnkV43MKrl36stVyHRfGcDnhQOkTgyWrIQNcI7zK3EMm5fYxqnw==
X-Gm-Gg: AR+sD12JBhTVn6TvOBW3xKrsvSUCBsGtUWYViwOXj0e6173W+ce6s7OR8BJA8/LZoAN
	48EF7l+QxTpr0tNnXuXACprHKFo4xVhAFenzuY1n0wGBXdYmalNR/ICwRnJgqTxAEb4Z7Ue7w0c
	M/7GRio6fnGd+ZjO05jTn9tGqRmThc13SID1MXQ4iplaSML5IEPNLh7LzlOsfN0tPnJxQUSAVpc
	AK57ez8GBSQSedCglS0S1z9gP3uoszsdsoTo4I383ZZ3cPnoDPRxnu47JODNGQZ48OUJvW1zqmC
	EXOC28KYmOAy++83wKWT/IyNzsoT6dIa1Gm4i5uxTBYKPX6gd4C0kY+4SIaQAUj6oeDi37KNFGl
	BYIP2dr0ZF+y0/F5GfUgYqFAZ0r73TXwx1RDm3HHT2XjovGRuwB7fqiEbxMLca3IxndunTdbeuk
	phLSWlFS1OKjLufmbDIZIbHI7Thg7GCHsSfO73omsRTgx30I64DftiAiIk1/Cu+8pPU+qkR+7Kw
	qnR2S+pzPwCshphXul2VCLLI/ZJrXcbTycKybPbzA==
X-Received: by 2002:a05:6000:2309:b0:47f:9208:9e4 with SMTP id ffacd0b85a97d-47f92080a4cmr4670984f8f.31.1784839379605;
        Thu, 23 Jul 2026 13:42:59 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:42:59 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v5 03/10] md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
Date: Thu, 23 Jul 2026 22:41:59 +0200
Message-ID: <20260723204206.76930-4-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260723204206.76930-1-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A write that skips write-behind (full behind queue, a waiting
reader, failed behind-bio allocation) races the in-flight behind
write it overlaps: nothing orders the two on the write-mostly
member, and if the older behind data lands last the member keeps
stale data for sectors already acknowledged as rewritten.

Serialize on CollisionCheck, which marks exactly the rdevs owning a
serial tree: serialize_policy rdevs plus write-mostly members when
write-behind arms serialization -- the case the MD_SERIALIZE_POLICY
test misses.  remove_serial() under the same condition.  This also
avoids the old gate's latent NULL deref for rdevs hot-added under
serialize_policy (they never get a serial tree).

Fixes: 69df9cfc7042 ("raid1: serialize the overlap write")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..997f79c05db7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -564,7 +564,7 @@ static void raid1_end_write_request(struct bio *bio)
 				call_bio_endio(r1_bio);
 			}
 		}
-	} else if (test_bit(MD_SERIALIZE_POLICY, &rdev->mddev->flags))
+	} else if (test_bit(CollisionCheck, &rdev->flags))
 		remove_serial(rdev, lo, hi);
 	if (r1_bio->bios[mirror] == NULL)
 		rdev_dec_pending(rdev, conf->mddev);
@@ -1677,7 +1677,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
+			/*
+			 * CollisionCheck marks every rdev with a serial
+			 * tree; order against in-flight write-behind I/O.
+			 */
+			if (test_bit(CollisionCheck, &rdev->flags))
 				wait_for_serialization(rdev, r1_bio);
 		}
 
-- 
2.52.0

