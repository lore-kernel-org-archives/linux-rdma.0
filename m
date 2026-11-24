Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529885;
	b=ObJDeQds7Iur3YVRn9CBljeWyT4soXOcaqhx2xyVt1GW5Oa7VIEtdQOtUxlCBwOWW22F
	 e2QvusfCKz97iDrypW/bBmspa/s9qFqOgLPQPQG17oaczNEPwKjGwiI1K2EHEQIatk7rz
	 InH2J1z6plD9yXhjo/uqeKRhdSsFfST/nH6AysccmJhnLlvHthO//jp7zxDay1oWKltp8
	 1dmhBHpcHK97CZndN7Lmdxv+YfDmNJyT5Fhj0WMQ9jXtrryH2Ge9d7PZity5VW+W556H2
	 8H2B4QCdIGR5556QrZWEW3I1t9CkX6ehx+pdyENlR828wxqYs2Vqym9DJMaY1AAzAbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529885;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RcEZBau4Vg0AeEXj4m9HmtRiHgUy7WeKZ8ntHILtOX8=;
	b=4d4IHRsos7GezzWal+HHfOkLsuzbJBzAe/ePZP/Y81rFuh4HTTsfTvgJFGty0a8QJhGA
	 Xe03Fu7dUaXWkQmNj/22O69lWTeaSV3T2WKEwhRGZZHgpKthV6xrLccnnqKjtQtK5i5oc
	 7XXfIcqiqVfI9g6L4bw42HIuwzY2ZXJyGbBiuZfAaBK7ZmZbydJxFwuT7ulZNARpscun2
	 WiBJ9pK/JXMEakU+Ckelg851HbjzFBct+GRapAzWo7ndcMDXqdHDda4trEruPt3Xv4qT3
	 d3CCkQ3B5PUxBg7qhzLr3/8Txk8hGvtL1SeKDmL6c0gyU0lGqo1qYZxslMQpV7vUuWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HphSiGhN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B262606A31E;
	Tue, 24 Nov 2026 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HphSiGhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624951F000CA;
	Tue, 24 Nov 2026 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529884;
	bh=RcEZBau4Vg0AeEXj4m9HmtRiHgUy7WeKZ8ntHILtOX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HphSiGhNs14GVrdk82c2baLULqVwTRrGG+T1Ug40RGxbSfmbi2x/3fLfoXh6N1NoL
	 nV/8GMv7DYqz/+T56ryRCRWKY3VvscQgsMpelPDytRBKTg5lZzQkyvZAV6HQXMyORP
	 sT/7toX1vnbW1oQlsgZfCfMko74ayp/7Ie9LtvdWTvoLXYCfu1y6eEcMxznfSzsWBi
	 6PUnYKTs7kPl+nj6cCe2psgn7wFdpBi+hmc9HQRmxGj7Uf6rlZfRldbpnjcaDZUGcn
	 yYAplJRTW/jWRtDGlsFWuqaaU8F5RTZ+BPqGUwiq95Fie3YsH2U8fLC6MtqZVB1SRq
	 8Jy6GDtjW4arA==
Date: Tue, 24 Nov 2026 16:18:00 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Ziheng Wei <zihengw03@163.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/hfi1: free CPU to SDMA map nodes after an RCU grace
 period
Message-ID: <20261124141800.GV14811@unreal>
References: <20261116130940.1629295-1-zihengw03@163.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116130940.1629295-1-zihengw03@163.com>

On Mon, Nov 16, 2026 at 09:09:40PM +0800, Ziheng Wei wrote:
> sdma_select_user_engine() looks up the per-CPU sdma_rht_node in
> dd->sdma_rht under rcu_read_lock() and reads rht_node->map[vl],
> map->mask and map->sde[].  sdma_set_cpu_to_sde_map(), called when the
> cpu_list sysfs attribute of an SDMA engine is written, removes a node
> whose maps have become empty with rhashtable_remove_fast() and then
> kfree()s the maps and the node right away.  There is no RCU grace
> period between the removal and the free, so a user SDMA submission on
> that CPU can read the node and the map after they have been freed.  If
> the memory has been reused, the map pointer and the engine pointer read
> from it are arbitrary, and the caller goes on to use that engine.
> 
> Writing cpu_list requires CAP_SYS_ADMIN.  The reader is reachable by any
> user that can open /dev/hfi1_N, when the task submitting user SDMA
> requests is pinned to a single CPU.  So this needs an administrator to
> change the SDMA engine CPU lists while jobs are running.

This is unlikely to occur in any real-world scenario.

Thanks

> 
> The debugfs dump in sdma_seqfile_dump_cpu_list() has the same problem,
> and in addition does not hold the RCU read lock at all while walking
> the node, because rhashtable_lookup_fast() drops it before returning.
> 
> Free the node and its maps from an RCU callback, as is already done for
> dd->sdma_map, and do the debugfs lookup and walk inside an RCU read-side
> critical section.  hfi1_free_devdata() calls rcu_barrier() before
> sdma_clean(), so no callback can still be pending when the hash table
> is destroyed.
> 
> Found by LLM-assisted static analysis.  Not reproduced, as I have no
> Omni-Path hardware; build tested only.
> 
> Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
> Fixes: af3674d62d34 ("IB/hfi1: Add new debugfs sdma_cpu_list file")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziheng Wei <zihengw03@163.com>
> ---
> 
> Notes:
>     The changelog was drafted with an AI assistant from my analysis;
>     I have reviewed the code, the fix and the text.
> 
>  drivers/infiniband/hw/hfi1/sdma.c | 45 ++++++++++++++++++-------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
> index a71fc8f2d..bf9e362f1 100644
> --- a/drivers/infiniband/hw/hfi1/sdma.c
> +++ b/drivers/infiniband/hw/hfi1/sdma.c
> @@ -801,6 +801,7 @@ struct sdma_rht_node {
>  	unsigned long cpu_id;
>  	struct sdma_rht_map_elem *map[HFI1_MAX_VLS_SUPPORTED];
>  	struct rhash_head node;
> +	struct rcu_head rcu;
>  };
>  
>  #define NR_CPUS_HINT 192
> @@ -886,6 +887,22 @@ static void sdma_cleanup_sde_map(struct sdma_rht_map_elem *map,
>  	}
>  }
>  
> +static void sdma_rht_free(void *ptr, void *arg)
> +{
> +	struct sdma_rht_node *rht_node = ptr;
> +	int i;
> +
> +	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
> +		kfree(rht_node->map[i]);
> +
> +	kfree(rht_node);
> +}
> +
> +static void sdma_rht_free_rcu(struct rcu_head *head)
> +{
> +	sdma_rht_free(container_of(head, struct sdma_rht_node, rcu), NULL);
> +}
> +
>  /*
>   * Prevents concurrent reads and writes of the sdma engine cpu_mask
>   */
> @@ -1027,10 +1044,11 @@ ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
>  							     sdma_rht_params);
>  				WARN_ON(ret);
>  
> -				for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
> -					kfree(rht_node->map[i]);
> -
> -				kfree(rht_node);
> +				/*
> +				 * sdma_select_user_engine() may still be
> +				 * using the node under rcu_read_lock().
> +				 */
> +				call_rcu(&rht_node->rcu, sdma_rht_free_rcu);
>  			}
>  		}
>  	}
> @@ -1055,17 +1073,6 @@ ssize_t sdma_get_cpu_to_sde_map(struct sdma_engine *sde, char *buf)
>  	return strnlen(buf, PAGE_SIZE);
>  }
>  
> -static void sdma_rht_free(void *ptr, void *arg)
> -{
> -	struct sdma_rht_node *rht_node = ptr;
> -	int i;
> -
> -	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
> -		kfree(rht_node->map[i]);
> -
> -	kfree(rht_node);
> -}
> -
>  /**
>   * sdma_seqfile_dump_cpu_list() - debugfs dump the cpu to sdma mappings
>   * @s: seq file
> @@ -1081,10 +1088,10 @@ void sdma_seqfile_dump_cpu_list(struct seq_file *s,
>  	struct sdma_rht_node *rht_node;
>  	int i, j;
>  
> -	rht_node = rhashtable_lookup_fast(dd->sdma_rht, &cpuid,
> -					  sdma_rht_params);
> +	rcu_read_lock();
> +	rht_node = rhashtable_lookup(dd->sdma_rht, &cpuid, sdma_rht_params);
>  	if (!rht_node)
> -		return;
> +		goto out;
>  
>  	seq_printf(s, "cpu%3lu: ", cpuid);
>  	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++) {
> @@ -1107,6 +1114,8 @@ void sdma_seqfile_dump_cpu_list(struct seq_file *s,
>  	}
>  
>  	seq_puts(s, "\n");
> +out:
> +	rcu_read_unlock();
>  }
>  
>  /*
> 
> base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
> -- 
> 2.43.0
> 
