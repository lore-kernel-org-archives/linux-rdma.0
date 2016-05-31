From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 08:35:10 -0700
Message-ID: <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464602994-21226-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/30/16 03:09, Max Gurtovoy wrote:
> ib_device_cap_flags 64-bit expansion caused a possible caps overlapping
> (depending on machine endianness) and made consumers read wrong device
> capabilities. For example IB_DEVICE_SG_GAPS_REG was falsely read by the
> iser driver causing it to use a non-existing capability. Fix this by
> casting ib_device_cap_flags enumerations to ULL.
>
 > [ ... ]
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> [ ... ]
>  enum ib_device_cap_flags {
 >       [ ... ]
>  	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
>       [ ... ]
>  };

How can this patch make a difference? The presence of any constant in an 
enum that does not fit in a 32-bit integer makes an enum 64 bits wide. 
In other words, all the changes from "1" into "1ULL" in this patch do 
not have any effect. From the C standard: "Each enumerated type shall be 
compatible with char, a signed integer type, or an unsigned integer 
type. The choice of type is implementation-defined but shall be capable 
of representing the values of all the members of the enumeration. [...] 
An implementation may delay the choice of which integer type until all 
enumeration constants have been seen."

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
