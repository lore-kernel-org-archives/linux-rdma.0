From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband:mlx4:Fix assumation that ib_get_cached_pkey
 runs successfully in build_mlx_header
Date: Thu, 10 Sep 2015 08:48:23 +0300
Message-ID: <55F119A7.5060906@mellanox.com>
References: <1441839861-4342-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441839861-4342-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eugenia-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/10/2015 2:04 AM, Nicholas Krause wrote:
> This fixes a incorrect assumation that ib_get_cached_pkey always runs
> successfully in the function build_mlx_header by checking if the calls
> to this particular function return the error code, -EINVAL in order to
> signal they failed to grap the public key for the device structure pointer
> passed to this function and if so return immediately to the caller of
> mlx_header with the error code -EINVAL to signal a error has occurred
> when calling this particular function that the caller must handle in
> its own intended error paths.

I am totally breathless, put 2-3 periods somewhere along this crazingly 
long sentence.

Does this fixes some specific commit? if yes, please add Fixes: tag @ 
before your S.O.B linewith the offending commit short ID (--abbrev=12)

run speller (e.g assumation  --> assumption), use IB/mlx4: prefix, add 
space between the ":" to the 1st word of the title, e.g:

IB/mlx4: Fix assumption that ib_get_cached_pkey runs successfully in 
build_mlx_header

Or.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
