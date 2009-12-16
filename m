From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
Date: Wed, 16 Dec 2009 11:03:21 +0200
Message-ID: <4B28A259.3040909@mellanox.co.il>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocm1csgb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/14/2009 8:37 PM, Roland Dreier wrote:
>
>   - mlx4 SR-IOV support.  Again, main problem was my lack of time.  I
>     agree in principle with this stuff, just want to be careful that we
>     don't turn the mlx4 driver into an unmaintainable mess of "if
>     (sriov) something; else something_else" all over.
>    

Roland,
You have not sent any comments to our patches that were sent few weeks 
ago on time for 2.6.32 inclusion,
and now I am surprised you do not accept them for 2.6.32.
I think we still have time to work together and fix your concerns on 
mlx4 driver.
Can you send more concrete comments so we can fix them?

Since we have a HW that supports SRIOV and many people are interested in 
this new technology for KVM thus it is important that we drive it now

Thanks
Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
