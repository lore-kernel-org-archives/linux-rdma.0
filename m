From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/5] rxe_cfg: Initialize $rxe_mtu even if ibv_definfo
 fails
Date: Thu, 13 Oct 2016 14:00:02 +0300
Message-ID: <f7b692f7-7831-79ab-9f16-9149cdc5cae8@mellanox.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <298d9c50-821d-b3f6-cfb3-366ad919c025@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <298d9c50-821d-b3f6-cfb3-366ad919c025-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/7/2016 9:38 PM, Bart Van Assche wrote:
> This patch avoids that the following error message is printed if
> ibv_devinfo fails:
>
> Use of uninitialized value $rmtu in string at /usr/local/bin/rxe_cfg line 364.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> ---
>  providers/rxe/rxe_cfg | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/providers/rxe/rxe_cfg b/providers/rxe/rxe_cfg
> index 0310d25bad91..1e6a5db2f2b8 100755
> --- a/providers/rxe/rxe_cfg
> +++ b/providers/rxe/rxe_cfg
> @@ -220,6 +220,7 @@ sub get_dev_info {
>  		$rxe_mtu{$rxe} = $line;
>  	    }
>  	}
> +	$rxe_mtu{$rxe} = "(?)" if (!$rxe_mtu{$rxe});
>      }
>  }
>
>
Ack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
