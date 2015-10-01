From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 16/26] IB/srp: Convert to new registration API
Date: Thu, 1 Oct 2015 11:10:10 -0700
Message-ID: <560D7702.1050806@sandisk.com>
References: <1443116118-10730-1-git-send-email-sagig@mellanox.com>
 <1443116118-10730-17-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443116118-10730-17-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/24/2015 10:35 AM, Sagi Grimberg wrote:
> +	if (dev->use_fast_reg) {
> +		state.sg = idb_sg;
> +		state.sg_nents = 1;
> +		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
> +		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
> +		ret = srp_map_finish_fr(&state, ch);
> +		if (ret < 0)
> +			return ret;
> +	} else if (dev->use_fmr) {

Hello Sagi,

Had you considered to use sg_init_one() instead of using sg_set_buf() 
and setting sg_nents to one ? The former function sets the end marker in 
the idb_sg scatterlist and also sets sg_magic if CONFIG_DEBUG_SG has 
been enabled.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
