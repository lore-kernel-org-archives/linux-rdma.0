From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Fwd: mlx5_ib_post_send panic on s390x
Date: Thu, 9 Mar 2017 10:54:13 +0100
Message-ID: <e57691e1-55bc-308a-fc91-0a8072218dd5@linux.vnet.ibm.com>
References: <56246ac0-a706-291c-7baa-a6dd2c6331cd@linux.vnet.ibm.com>
 <dcc90daa-b932-8957-d8bc-e1f02d04e03a@linux.vnet.ibm.com>
 <20e4f31e-b2a7-89fb-d4c0-583c0dc1efb6@mellanox.com>
 <491cf3e1-b2f8-3695-ecd4-3d34b0ae9e25@linux.vnet.ibm.com>
 <AM4PR0501MB278723F1BF4DA9846C664C62C52C0@AM4PR0501MB2787.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB278723F1BF4DA9846C664C62C52C0-dp/nxUn679jFcPxmzbbP+MDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 03/06/2017 02:08 PM, Eli Cohen wrote:
>>>
>>> The problem seems to be caused by the usage of plain memcpy in set_data_inl_seg().
>>> The address provided by SMC-code in struct ib_send_wr *wr is an 
>>> address belonging to an area mapped with the ib_dma_map_single() 
>>> call. On s390x those kind of addresses require extra access functions (see arch/s390/include/asm/io.h).
>>>
> 
> By definition, when you are posting a send request with inline, the address must be mapped to the cpu so plain memcpy should work.
>
In the past I run SMC-R with Connect X3 cards. The mlx4 driver does not seem to contain extra coding for IB_SEND_INLINE flag for ib_post_send. Does this mean for SMC-R to run on Connect X3 cards the IB_SEND_INLINE flag is ignored, and thus I needed the ib_dma_map_single() call for the area used with ib_post_send()? Does this mean I should stay away from the IB_SEND_INLINE flag, if I want to run the same SMC-R code with both, Connect X3 cards and Connect X4 cards?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
